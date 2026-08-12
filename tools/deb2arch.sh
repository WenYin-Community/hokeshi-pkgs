#!/bin/bash
# deb2arch.sh —— 将 deepin-wine 风格 .deb 转换为 Arch Linux .pkg.tar.zst（仅 amd64→x86_64）
# 用法: deb2arch.sh <deb文件|目录>... [-o 输出目录]
# 依赖: ar、tar、xz、bsdtar、zstd
set -euo pipefail

# 强制 UTF-8 locale：包内含中文等非 ASCII 文件名时需 UTF-8
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAPPING="$SCRIPT_DIR/arch-mapping.tsv"

OUT="arch-pkg"
INPUTS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o) OUT="${2:?缺少输出目录参数}"; shift 2;;
    -h|--help) echo "用法: $0 <deb文件|目录>... [-o 输出目录]"; exit 0;;
    *) INPUTS+=("$1"); shift;;
  esac
done

[[ ${#INPUTS[@]} -eq 0 ]] && { echo "错误: 未提供 .deb 文件或目录" >&2; exit 1; }

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

for t in ar tar xz bsdtar zstd; do
  command -v "$t" >/dev/null 2>&1 || { echo "错误: 缺少命令 $t" >&2; exit 1; }
done

mkdir -p "$OUT"
OUT="$(cd "$OUT" && pwd)"

# 将 deb 依赖包名映射为 Arch 包名并输出 .PKGINFO 行；未命中的提示校准
map_deps() {
  local deps="$1" prefix="${2:-depend}"
  [[ -z "$deps" ]] && return 0
  local -A seen=()
  local IFS=','
  for item in $deps; do
    local name
    name=$(printf '%s' "$item" | awk '{print $1}' | tr -d '|() ')
    [[ -z "$name" ]] && continue
    if [[ -n "${seen[$name]:-}" ]]; then continue; fi
    seen[$name]=1
    local arch
    arch=$(awk -F'\t' -v n="$name" '$1==n {print $2; exit}' "$MAPPING" 2>/dev/null || true)
    if [[ -n "$arch" ]]; then
      printf '%s = %s\n' "$prefix" "$arch"
    else
      echo "  未映射依赖(需手工校准 arch-mapping.tsv): $name" >&2
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

# 将 deb 维护脚本包装为 Arch .INSTALL 钩子；含 deb 特有命令时忽略该脚本段
install_hook() {
  local src="$1" fn="$2"
  [[ -f "$src" ]] || return 1
  if grep -qE 'dpkg|update-alternatives|deb-systemd|invoke-rc\.d|debconf' "$src"; then
    echo "  警告: $(basename "$src") 含 deb 特有命令，已忽略其安装钩子" >&2
    return 1
  fi
  printf '%s() {\n' "$fn"
  # pacman 以 root 运行 .INSTALL，剥离 deb 脚本中冗余的 sudo 前缀（root 下 sudo cmd ≡ cmd）
  sed -e '/^#!\//d' -e 's/\bsudo[[:space:]]\+//g' "$src"
  printf '}\n'
}

convert_one() {
  local deb="$1"
  local work="$OUT/.work"
  local name pkg version arch depends conflicts description homepage
  name=$(basename "$deb")
  echo "==> 转换: $name"
  rm -rf "$work"
  mkdir -p "$work"

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

  local pkgarch
  case "$arch" in
    amd64) pkgarch="x86_64";;
    all|noarch) pkgarch="any";;
    *) echo "  跳过: 非 amd64 架构 ($arch)" >&2; return 0;;
  esac

  # Arch pkgver 仅允许 [0-9A-Za-z._+]：- ~ 转 _，其余非法字符删除
  local pkgver
  pkgver=$(printf '%s' "$version" | sed 's/-/_/g; s/~/_/g; s/[^0-9A-Za-z._+]//g; s/^[._]*//; s/[._]*$//')
  pkgver="${pkgver:-0}-1"

  local data
  data="$(realpath "$work/data.tar.xz")"
  [[ -f "$data" ]] || { echo "  错误: 缺少 data.tar.xz" >&2; return 1; }

  (cd "$work" && tar -xJf control.tar.xz 2>/dev/null || true)

  local pkgroot="$work/pkgroot"
  mkdir -p "$pkgroot"
  tar -xJf "$data" -C "$pkgroot"

  local desc size builddate
  desc=$(printf '%s' "$(extract_field "$ctrl" Description | head -1)")
  size=$(du -sb "$pkgroot" | awk '{print $1}')
  builddate=$(date +%s)

  {
    printf 'pkgname = %s\n' "$pkg"
    printf 'pkgbase = %s\n' "$pkg"
    printf 'pkgver = %s\n' "$pkgver"
    [[ -n "$desc" ]] && printf 'pkgdesc = %s\n' "$desc"
    [[ -n "$homepage" ]] && printf 'url = %s\n' "$homepage"
    printf 'builddate = %s\n' "$builddate"
    printf 'packager = hokeshi-pkgs\n'
    printf 'size = %s\n' "$size"
    printf 'arch = %s\n' "$pkgarch"
    printf 'license = unknown\n'
    map_deps "$depends" depend
    map_deps "$conflicts" conflict
  } > "$pkgroot/.PKGINFO"

  local inst="$pkgroot/.INSTALL"
  rm -f "$inst"
  {
    install_hook "$work/preinst" "pre_install"
    install_hook "$work/postinst" "post_install"
    install_hook "$work/prerm" "pre_remove"
    install_hook "$work/postrm" "post_remove"
  } > "$inst" 2>/dev/null
  [[ -s "$inst" ]] || rm -f "$inst"

  (cd "$pkgroot" && bsdtar --format=mtree --options='all,use-set,type,uid,gid,mode,time,size,md5,sha256,link' \
      --exclude '.PKGINFO' --exclude '.MTREE' --exclude '.INSTALL' -cf .MTREE * 2>/dev/null || true)

  local out="$OUT/$pkg-$pkgver-$pkgarch.pkg.tar.zst"
  local mt="" tops
  [[ -f "$pkgroot/.MTREE" ]] && mt=".MTREE"
  [[ -f "$pkgroot/.INSTALL" ]] && [[ -s "$pkgroot/.INSTALL" ]] && inst=".INSTALL" || inst=""
  tops=$(tar -tJf "$data" | awk '{sub(/^\.\//,""); sub(/\/.*/,""); if ($0!="." && $0!="") print}' | sort -u)
  (cd "$pkgroot" && bsdtar --zstd -cf "$out" .PKGINFO $mt $inst $tops)

  echo "  ✓ 产物: $(basename "$out")"
  echo "  .PKGINFO:"
  sed 's/^/    /' "$pkgroot/.PKGINFO"
  rm -rf "$work"
}

fail=0
for deb in "${DEBS[@]}"; do
  convert_one "$deb" || fail=1
done

echo "完成。Arch 包输出目录: $OUT"
exit "$fail"
