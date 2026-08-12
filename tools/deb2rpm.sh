#!/bin/bash
# deb2rpm.sh —— 将 deepin-wine 风格 .deb 转换为 .rpm（当前仅 amd64→x86_64）
# 用法: deb2rpm.sh <deb文件|目录>... [-o 输出目录]
# 依赖: ar、tar、xz、rpmbuild（Fedora 无需 dpkg）
set -euo pipefail

# 强制 UTF-8 locale：rpmbuild 需 UTF-8 才能正确处理中文等非 ASCII 文件名
# （CI 的 fedora 容器默认 C locale 会导致 %install/%files 中文路径匹配失败）
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# 第三方自包含包常含指向打包者本机构建路径的 RPATH，跳过 rpm 的 RPATH 检查
export QA_RPATHS=0x3f

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAPPING="$SCRIPT_DIR/fedora-mapping.tsv"

OUT="rpms"
INPUTS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o) OUT="${2:?缺少输出目录参数}"; shift 2;;
    -h|--help) echo "用法: $0 <deb文件|目录>... [-o 输出目录]"; exit 0;;
    *) INPUTS+=("$1"); shift;;
  esac
done

[[ ${#INPUTS[@]} -eq 0 ]] && { echo "错误: 未提供 .deb 文件或目录" >&2; exit 1; }

# 展开输入为 deb 文件列表
DEBS=()
for x in "${INPUTS[@]}"; do
  if [[ -d "$x" ]]; then
    for f in "$x"/*.deb; do [[ -f "$f" ]] && DEBS+=("$f"); done
  elif [[ -f "$x" ]]; then
    DEBS+=("$x")
  else
    echo "警告: 忽略不存在的路径: $x" >&2
  fi
done
[[ ${#DEBS[@]} -eq 0 ]] && { echo "错误: 未找到 .deb 文件" >&2; exit 1; }

if [[ $EUID -eq 0 ]]; then
  echo "错误: rpmbuild 不允许以 root 运行，请以普通用户执行（CI 中先 useradd builder 再 su）" >&2
  exit 1
fi

for t in ar tar xz rpmbuild; do
  command -v "$t" >/dev/null 2>&1 || { echo "错误: 缺少命令 $t" >&2; exit 1; }
done

mkdir -p "$OUT"
OUT="$(cd "$OUT" && pwd)"

# 将 deb 依赖包名映射为 Fedora 包名并输出 spec 行；未命中的输出注释（交由 rpm 自动依赖兜底）
map_deps() {
  local deps="$1" prefix="${2:-Requires}"
  [[ -z "$deps" ]] && return 0
  local -A seen=()
  local IFS=','
  for item in $deps; do
    local name
    name=$(printf '%s' "$item" | awk '{print $1}' | tr -d '|() ')
    [[ -z "$name" ]] && continue
    if [[ -n "${seen[$name]:-}" ]]; then continue; fi
    seen[$name]=1
    local fed
    fed=$(awk -F'\t' -v n="$name" '$1==n {print $2; exit}' "$MAPPING" 2>/dev/null || true)
    if [[ -n "$fed" ]]; then
      printf '%s: %s\n' "$prefix" "$fed"
    else
      printf '# 未映射依赖(交由 rpm 自动依赖): %s\n' "$name"
    fi
  done
}

# 从 control 文本提取字段值（支持续行，多行合并由调用方按需处理）
extract_field() {
  local ctrl="$1" field="$2"
  awk -v F="$field" '
    $0 ~ "^"F":" { inf=1; line=$0; sub(/^[^:]*:[ \t]*/, "", line); sub(/\r$/, "", line); print line; next }
    inf && /^[ \t]+/ { line=$0; sub(/^[ \t]+/, "", line); sub(/\r$/, "", line); print line; next }
    inf && /^[A-Za-z0-9-]+:/ { inf=0 }
  ' <<< "$ctrl"
}

# 依据 data.tar.xz 生成 %files 段（非目录条目 + 空目录 %dir）
generate_files() {
  local data="$1"
  tar -tJf "$data" 2>/dev/null | awk '
    function mark(p, d) {
      d = p
      while (d != "") {
        nonempty[d]=1
        if (d !~ /\//) break
        sub(/\/[^\/]*$/, "", d)
      }
    }
    function esc(s) { gsub(/ /, "\\ ", s); return s }
    {
      p = $0
      sub(/^\.\//, "", p)
      if (p == "" || p == ".") next
      if (p ~ /\/$/) { sub(/\/$/, "", p); dirs[p]=1; mark(p) }
      else { print "/" esc(p); mark(p) }
    }
    END {
      for (d in dirs) if (!(d in nonempty) && d != "") print "%dir /" esc(d)
    }' | sort -u
}

# 提取 deb 维护脚本；含 deb 特有命令时忽略该脚本段
include_script() {
  local file="$1"
  [[ -f "$file" ]] || return 1
  if grep -qE 'dpkg|update-alternatives|deb-systemd|invoke-rc\.d|debconf' "$file"; then
    echo "  警告: $file 含 deb 特有命令，已忽略其脚本段" >&2
    return 1
  fi
  sed '/^#!\//d' "$file"
}

convert_one() {
  local deb="$1"
  local work="$OUT/.work"
  local name pkg version arch depends conflicts description homepage
  name=$(basename "$deb")
  echo "==> 转换: $name"
  rm -rf "$work"
  mkdir -p "$work/rpmbuild"

  # 解出 control 与 data（先算绝对路径，避免 cd 后相对路径失效）
  local abs_deb
  abs_deb="$(realpath "$deb")"
  (cd "$work" && ar x "$abs_deb")
  local ctrl
  ctrl=$(tar -xJOf "$work/control.tar.xz" ./control 2>/dev/null || tar -xJOf "$work/control.tar.xz" control)

  pkg=$(extract_field "$ctrl" Package | head -1 | tr -d ' ')
  version=$(extract_field "$ctrl" Version | head -1 | tr -d ' ')
  arch=$(extract_field "$ctrl" Architecture | head -1 | tr -d ' ')
  depends=$(extract_field "$ctrl" Depends | tr '\n' ' ' | sed 's/  */ /g; s/^ //; s/ $//')
  conflicts=$(extract_field "$ctrl" Conflicts | tr '\n' ' ' | sed 's/  */ /g; s/^ //; s/ $//')
  description=$(extract_field "$ctrl" Description | sed '/^\.$/d')
  homepage=$(extract_field "$ctrl" Homepage | head -1)

  [[ -z "$pkg" || -z "$version" ]] && { echo "  错误: 无法解析 $name 的包名/版本" >&2; return 1; }

  local rpmarch
  case "$arch" in
    amd64) rpmarch="x86_64";;
    all|noarch) rpmarch="noarch";;
    *) echo "  跳过: 非 amd64 架构 ($arch)" >&2; return 0;;
  esac

  local rpmver summary desc data
  rpmver=$(printf '%s' "$version" | sed 's/[^0-9A-Za-z.]/_/g')
  summary=$(printf '%s' "$(extract_field "$ctrl" Description | head -1)" | sed 's/%/%%/g')
  summary=${summary:-$pkg}
  desc=$(printf '%s' "$description" | sed 's/%/%%/g')
  data="$(realpath "$work/data.tar.xz")"
  [[ -f "$data" ]] || { echo "  错误: 缺少 data.tar.xz" >&2; return 1; }

  # 解出维护脚本（preinst/postinst/prerm/postrm）
  (cd "$work" && tar -xJf control.tar.xz 2>/dev/null || true)

  local out_spec="$work/package.spec"
  {
    printf 'Name:           %s\n' "$pkg"
    printf 'Version:        %s\n' "$rpmver"
    printf 'Release:        1\n'
    printf 'Summary:        %s\n' "$summary"
    printf 'License:        unknown\n'
    printf 'BuildArch:      %s\n' "$rpmarch"
    printf 'AutoReqProv:    yes\n'
    [[ -n "$homepage" ]] && printf 'URL:            %s\n' "$homepage"
    printf '\n%%description\n'
    printf '%s\n' "$desc"
    printf '\n%%prep\n\n%%build\n\n'
    printf '%%install\n'
    printf 'tar -xJf %s -C $RPM_BUILD_ROOT\n\n' "$data"
    local s seg body f
    for s in pre:preinst post:postinst preun:prerm postun:postrm; do
      seg="${s%%:*}"; f="$work/${s##*:}"
      body=$(include_script "$f") && printf '%%%s\n%s\n' "$seg" "$body"
    done
    printf '%%files\n'
    generate_files "$data"
  } > "$out_spec"

  echo "  生成 spec: Name=$pkg Version=$rpmver Arch=$rpmarch"

  if ! rpmbuild --define "_topdir $work/rpmbuild" --target "$rpmarch" -bb "$out_spec" > "$work/build.log" 2>&1; then
    echo "  构建失败: $name，build.log 内容如下：" >&2
    sed 's/^/    /' "$work/build.log" >&2
    cp "$work/build.log" "$OUT/${name%.deb}.build.log"
    return 1
  fi

  local rpms=()
  while IFS= read -r r; do rpms+=("$r"); done < <(find "$work/rpmbuild/RPMS" -name '*.rpm' 2>/dev/null)
  if [[ ${#rpms[@]} -eq 0 ]]; then
    echo "  构建失败: 未生成 rpm（日志: $work/build.log）" >&2
    return 1
  fi
  for r in "${rpms[@]}"; do
    cp "$r" "$OUT/"
    echo "  ✓ 产物: $(basename "$r")"
  done
  rm -rf "$work"
}

fail=0
for deb in "${DEBS[@]}"; do
  convert_one "$deb" || fail=1
done

echo "完成。rpm 输出目录: $OUT"
exit "$fail"
