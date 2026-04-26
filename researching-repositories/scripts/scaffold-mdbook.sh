#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $0 <output-dir>" >&2
}

if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

script_dir="$(cd "$(dirname "$0")" && pwd)"
template_dir="$script_dir/../templates/mdbook"
output_dir="$1"

if [ ! -d "$template_dir/src" ]; then
  echo "Template directory not found: $template_dir" >&2
  exit 1
fi

if [ -e "$output_dir" ]; then
  echo "Target already exists: $output_dir" >&2
  echo "Refusing to overwrite. Choose a new directory or remove the target manually." >&2
  exit 1
fi

mkdir -p "$output_dir/src" "$output_dir/src/diagrams" "$output_dir/src/appendix"
cp "$template_dir/book.toml" "$output_dir/book.toml"
cp "$template_dir/src/index.md" "$output_dir/src/index.md"
cp "$template_dir/src/SUMMARY.md" "$output_dir/src/SUMMARY.md"

cat > "$output_dir/src/appendix/evidence-ledger.md" <<'LEDGER'
# 证据清单

| 结论 | 标签 | 状态 | 强度 | 证据类型 | 路径或符号 | 备注 |
| --- | --- | --- | --- | --- | --- | --- |
| `<claim>` | `事实/推断/建议` | `已验证/有漂移/待验证` | `S1/S2/S3` | `file/test/doc/command` | `<path#symbol>` | `<note>` |
LEDGER

cat > "$output_dir/src/diagrams/README.md" <<'DIAGRAMS'
# Diagrams

保存 Mermaid 图或图示说明。每张图都应能追溯到源码、测试或命令证据。

必备图示：

- global flow diagram：入口 -> 调度 -> 核心模块 -> 输出，包含至少一个真实分叉。
- module architecture diagrams：每个 P0/P1 模块的边界、内部组件、上下游、扩展点和错误出口。
- path replay diagram：用真实输入展示分支、状态变化和输出。
DIAGRAMS

cat <<MSG
Scaffolded mdBook at: $output_dir

Next steps:
  1. Fill repo snapshot, thesis, research packet, support judgments, and reading spine in src/index.md
  2. Replace src/SUMMARY.md with chapters based on the actual repository thesis, flows, and P0/P1 modules
  3. Add a global flow diagram, P0/P1 module architecture diagrams, and at least one path replay diagram
  4. Fill src/appendix/evidence-ledger.md as claims are written
  5. Run mdbook build when mdBook is available

Hard rules:
  - Do not keep placeholder chapter names or scaffold chapter structure
  - Do not average all directories equally
  - Do not remove deep concepts for beginner friendliness
  - Every important diagram needs S1/S2 evidence
MSG
