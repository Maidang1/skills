# 工具使用与环境适配

目标是用最少噪音拿到可信源码证据，并把工具结果转化为仓库主线、流程图、模块架构图和测试语义。工具输出不能直接替代正文。

## 目录

- [工具选择原则](#工具选择原则)
- [Research Packet](#research-packet)
- [Codex / OMX 环境](#codex--omx-环境)
- [最小研究命令](#最小研究命令)
- [入口发现模式](#入口发现模式)
- [推荐探索顺序](#推荐探索顺序)
- [图示取证流程](#图示取证流程)
- [测试语义采集](#测试语义采集)
- [外部资料使用边界](#外部资料使用边界)
- [并行研究分工](#并行研究分工)
- [停止探索条件](#停止探索条件)

## 工具选择原则

1. **先定位公开入口，再看内部实现**：不要从全仓库目录罗列开始。
2. **先找主路径，再补横向机制**：避免搜索噪音吞掉研究时间。
3. **先取证，再写判断**：每个 thesis、模块边界、流程分叉都要能回到证据。
4. **命令能验证才运行**：环境缺失时标注 `待验证`，不要编造结果。
5. **已知项目要复核当前快照**：不要依赖模型旧知识。

## Research Packet

开始写正文前，先收集一个最小 research packet：

```text
snapshot: branch / commit / dirty status
stack: language, package manager, build/test tools
public entrypoints: package exports, CLI, routes, plugins, config entry
core modules: P0/P1/P2 with reason
critical flows: 2-4 paths with entry and output
representative tests: test families and semantic coverage
known docs: README/design docs/status docs and drift risk
```

没有 research packet 就直接写章节，通常会变成 AI 味综述。

## Codex / OMX 环境

如果当前 session 启用了 `USE_OMX_EXPLORE_CMD`，简单只读探索优先用：

```bash
omx explore --prompt "Inspect <repo>. Identify public entrypoints, key modules, and likely critical paths. Cite paths."
```

适合 `omx explore` 的任务：

- 找入口文件、导出表、CLI 子命令、注册点。
- 归纳目录和模块边界。
- 快速列出测试族和构建脚本。
- 询问某个具体路径或符号关系。

不适合 `omx explore` 的任务：

- 修改文件。
- 跑测试或构建。
- 大段复杂推理和成书整合。
- 需要浏览器、IDE 或外部服务的任务。

`omx explore` 不可用或回答含糊时，回到普通文件读取、grep/rg、语言服务和 shell 命令。

## 最小研究命令

在目标仓库根目录执行或等价获取：

```bash
git rev-parse --abbrev-ref HEAD
git rev-parse HEAD
git status --short
```

识别语言栈：

```bash
ls Cargo.toml 2>/dev/null && echo Rust
ls package.json 2>/dev/null && echo Node
ls pyproject.toml setup.py setup.cfg 2>/dev/null && echo Python
ls go.mod 2>/dev/null && echo Go
```

核心文件规模统计要排除依赖、生成物、构建产物和测试目录。可以用 `git ls-files`、`rg --files`、Glob 或 IDE 文件搜索实现。

## 入口发现模式

| 语言/类型 | 重点文件 | 搜索模式 |
| --- | --- | --- |
| Node/TS | `package.json`, `exports`, `bin`, `src/index*` | `export`, `module.exports`, `program.command`, `create*` |
| Rust | `Cargo.toml`, `src/lib.rs`, `src/main.rs` | `pub use`, `pub mod`, `pub fn`, `clap`, `struct Opt` |
| Python | `pyproject.toml`, `setup.py`, package `__init__.py` | `__all__`, `entry_points`, `def main`, `click`, `argparse` |
| Go | `go.mod`, `cmd/*`, package roots | `func main`, exported `type`, exported `func` |
| Web/UI | routes, app entry, component registry | `route`, `Router`, `createRoot`, `export default` |

## 推荐探索顺序

1. **入口层**：package metadata、CLI、routes、exports、examples。
2. **调度层**：command dispatcher、plugin registry、router、orchestrator、state machine。
3. **核心层**：parser/compiler/runtime/matcher/renderer/storage 等仓库价值所在。
4. **边界层**：errors、config、compat、adapters、generated code。
5. **规格层**：tests、fixtures、snapshots、golden files。
6. **文档层**：README、design docs、status docs，用于漂移校验。

这个顺序可以调整，但不要先陷入工具脚本或边缘目录。

## 图示取证流程

画图前先收集：

1. 节点：真实文件、模块、类型、核心函数。
2. 边：导入、调用、注册、事件、数据流。
3. 分叉：配置、参数、类型判断、错误分支。
4. 输出：返回值、文件、网络请求、UI 状态、产物。

图中每个重要节点和边都要能在证据清单里找到来源。

## 测试语义采集

优先收集测试目录结构、代表性 fixture 和测试名称，再选择可运行命令。

常见命令：

```bash
npm test -- --list 2>/dev/null || true
pnpm test -- --list 2>/dev/null || true
cargo test -- --list 2>/dev/null || true
python -m pytest --collect-only 2>/dev/null || true
go test ./... -list '.*' 2>/dev/null || true
```

如果测试无法运行，写清阻塞点，并从测试源码中提取行为规格，状态标为 `待验证`。

## 外部资料使用边界

开源仓库研究可以使用官方文档、release note、issue/PR、设计文档作为辅助，但优先级低于当前源码。

- 官方文档：可解释意图，但要回到源码确认当前行为。
- Issue/PR：可解释历史背景，但不能直接写成当前事实。
- 第三方文章：最多作为线索，不作为关键证据。
- 包版本、最新 API、当前维护状态等易变信息需要实时核验。

## 并行研究分工

主 agent 负责：

- 仓库 thesis。
- 全局流程图。
- 公开边界清单。
- 章节统一口径和 Anti-AI Gate。

模块 subagent 负责：

- 单模块 12 问。
- 模块架构图。
- 源码级重放。
- 模块证据清单。

交付给 subagent 的 brief 必须包含仓库 thesis，避免模块章节各写各的、失去主线。

## 停止探索条件

满足以下条件再开始成章写作：

- 至少有一个可验证的仓库 thesis。
- 公开入口清单已覆盖主要入口。
- 至少 2 条关键路径有入口、核心模块和输出。
- P0 模块已排序并有选择理由。
- 测试族已映射到主要行为语义。
- 证据清单已有 S1/S2 证据支撑核心判断。
