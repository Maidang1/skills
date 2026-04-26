---
name: researching-repositories
description: Use when a user wants to deeply understand an unfamiliar open-source repository, avoid README-style summaries, produce a durable mdBook, explain design intent, module architecture, real execution paths, tests-as-specs, or demo reimplementation.
---

# 开源仓库深度研究与成书

## Purpose

把一个陌生开源仓库研究成一本 **有主线、有判断、有图、有源码证据** 的 mdBook。目标读者可以是初学者，但内容不能浅：读完后应能说清仓库为什么存在、核心设计理念是什么、重要模块如何协作、关键流程如何运行，以及如何基于这些理解实现一个最小 demo。

这不是 README 摘要、目录导览、均匀综述，也不是为了“初学者友好”而删掉深刻概念。

## Core Output Contract

每本书必须交付：

1. **仓库 thesis**：一句话说明仓库为什么存在，以及它用什么核心方式解决问题。
2. **reading spine**：初学者进入仓库的阅读路线，解释先读什么、为什么先读它。
3. **public boundary inventory**：包入口、CLI、子路径、插件、配置、兼容层等公开入口。
4. **global flow diagram**：至少 1 张入口到核心能力再到输出的流程图，包含真实分叉点。
5. **module architecture diagrams**：每个 P0/P1 重要模块至少 1 张架构/协作图。
6. **module deep dives**：讲清角色、边界、设计意图、关键概念、协作关系、失败模式和源码级执行。
7. **tests-as-specs**：说明哪些测试定义了哪些行为边界，修改后应回归什么。
8. **demo reconstruction**：给出最小可复现版本的保留/裁剪、目录、步骤和验证。
9. **claim ledger**：所有关键判断带文件、符号、调用链、测试或命令证据，并标注状态。

## Workflow

| Step | 动作 | 完成标准 |
| --- | --- | --- |
| 1 | 固定快照 | 记录 repo、branch、commit、dirty status、研究范围、核心源码规模 |
| 2 | 建 research packet | 找公开入口、P0/P1/P2 模块、2-4 条关键路径、代表性测试族、文档漂移风险 |
| 3 | 提炼 thesis | 写 1 句 thesis + 3-5 个支撑判断，并用 S1/S2 证据约束 |
| 4 | 设计章节 | 按 thesis、reading spine、关键流程和模块优先级拆章，不按目录平均铺开 |
| 5 | 写流程和模块 | 先画 global flow，再写 P0/P1 模块深挖和 module architecture diagrams |
| 6 | 写横向机制 | 测试语义、配置、构建、错误边界、兼容层、文档漂移 |
| 7 | 反推 demo | 从真实设计裁剪最小实现，说明保留什么、裁掉什么、如何验证 |
| 8 | Gate 校验 | Deep Understanding、Diagram、Anti-AI 任一失败就回写补证或重写章节 |

前 3 步不要变成目录考古。尽快形成 thesis，然后让后续章节不断验证或修正它。

## Quality Gates

### Deep Understanding Gate

最终书稿必须能稳定回答：

1. 仓库为什么存在？核心设计理念是什么？
2. 公开入口有哪些？每个入口由哪一层维护？
3. 重要模块分别解决什么问题，如何协作，边界在哪里？
4. 同一能力如果有多条路径，共享什么，在哪里分叉，行为差异是什么？
5. 至少一条复杂输入如何按源码分支逐步得到输出？
6. 哪些测试定义了行为规格，哪些文档和当前源码有漂移？
7. 如果自己实现 demo，要保留哪些抽象、裁掉哪些能力、先验证什么？

### Diagram Gate

至少包含：

- global flow diagram：外部输入/调用入口 -> 入口层 -> 调度层 -> 核心模块 -> 输出层。
- module architecture diagrams：每个 P0/P1 模块的边界、内部组件、上下游、扩展点和错误出口。
- path replay diagram：当核心价值在解析、编译、调度、匹配、渲染、状态机等逻辑里时，补真实输入的分支重放图。

图不是目录树。关键节点和边必须能追溯到文件、类型、调用、注册、测试或命令证据。

### Anti-AI Gate

出现以下任一情况即不合格：

- 没有仓库 thesis，只是“这是一个用于 X 的项目”。
- 每章结构和语气都一样，看不出仓库特有重点。
- P0 模块和边缘目录篇幅接近，没有主次。
- 模块描述可以替换到任何仓库仍然成立。
- 只有职责和调用链，没有设计意图、边界、取舍和失败模式。
- 为了初学者友好而跳过困难概念。
- 读者看完仍不知道先读哪条路径、先改哪里、该跑哪些测试。

## Scale Heuristic

开始前统计非生成、非依赖、非测试的核心源码文件数，并写入阅读指南。

| 规模 | 核心文件数 | 建议章节数 | 模块深挖 |
| --- | --- | --- | --- |
| 小型 | < 20 | 5-7 章 | 2-3 个核心模块，可合并横向机制 |
| 中型 | 20-100 | 8-12 章 | 3-5 个核心模块 |
| 大型 | 100+ | 12+ 章或多卷 | 5+ 个核心模块，按子系统分卷 |

章节数量可以调整，但必须解释为什么这样拆。模板只是脚手架，不是章节答案。

## Execution Modes

- **并行模式**：主 agent 负责 thesis、global flow、public boundary、统一口径和最终 Gate；subagent 分别深挖模块。
- **分轮模式**：按 research packet、模块章节、最终 Gate 拆成三轮。
- **小型仓库单次完成**：仍需先写 thesis 和图，再写章节。

模块 subagent 的 brief 必须包含仓库 thesis、global flow 摘要、模块主题、固定深挖问题、证据格式和图示要求，避免各写各的。

## Quick Start

1. 运行 `scripts/scaffold-mdbook.sh <output-dir>` 创建 mdBook 骨架。
2. 填写 `src/index.md` 的快照、thesis、reading spine、P0/P1 模块、图示清单和证据约定。
3. 根据真实模块改写 `src/SUMMARY.md`，不要沿用示例结构。
4. 按 workflow 写章节、图、证据清单。
5. 运行 `mdbook build`（如环境可用），再执行三大 Gate 校验。

## References

- `reference/chapter-rules.md`：章节设计、模块深挖、图示规则。
- `reference/evidence-protocol.md`：claim ledger、证据强度、漂移校验。
- `reference/tool-guide.md`：探索顺序、命令、Codex/OMX 环境适配。
- `reference/writing-quality.md`：反 AI 味改稿、章节语气、禁用句式。
- `evals/repository-research-evals.md`：RED/GREEN/REFACTOR 压力测试和评分矩阵。
