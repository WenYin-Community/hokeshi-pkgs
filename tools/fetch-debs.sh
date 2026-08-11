#!/bin/bash
# fetch-debs.sh —— 解析 README.md 中的上游 release 链接，下载各包最新 amd64 deb 到 amd64-deb/
# 依赖: curl、jq（GitHub Actions 的 fedora 容器需 dnf install curl jq）
# 代理: 通过 https_proxy 环境变量支持（GitHub Actions 云端无需代理）
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

for t in curl jq; do
  command -v "$t" >/dev/null 2>&1 || { echo "错误: 缺少 $t" >&2; exit 1; }
done

mkdir -p amd64-deb

# 提取 README 中 github.com/OWNER/REPO/releases/tag/TAG 形式的链接
urls=$(grep -oE 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/releases/tag/[A-Za-z0-9_.-]+' README.md | sort -u)
[[ -z "$urls" ]] && { echo "错误: README.md 中未找到上游 release 链接" >&2; exit 1; }

count=0
while IFS= read -r url; do
  owner=$(printf '%s' "$url" | sed -E 's#https://github\.com/([^/]+)/.*#\1#')
  repo=$(printf '%s' "$url" | sed -E 's#https://github\.com/[^/]+/([^/]+)/.*#\1#')
  tag=$(printf '%s' "$url" | sed -E 's#.*/releases/tag/(.*)#\1#')
  api="https://api.github.com/repos/$owner/$repo/releases/tags/$tag"
  echo "==> $owner/$repo [$tag]"

  assets=$(curl -fsSL "$api" | jq -r '.assets[]? | select(.name | endswith("_amd64.deb")) | .browser_download_url' 2>/dev/null || true)
  if [[ -z "$assets" ]]; then
    echo "  无 amd64 deb 资产，跳过"
    continue
  fi
  while IFS= read -r dl; do
    f="amd64-deb/$(basename "$dl")"
    if curl -fSL -o "$f" "$dl"; then
      echo "  ✓ $f"
      count=$((count + 1))
    else
      echo "  失败: $dl" >&2
    fi
  done <<< "$assets"
done <<< "$urls"

echo "完成，共下载 $count 个 amd64 deb 到 amd64-deb/"
