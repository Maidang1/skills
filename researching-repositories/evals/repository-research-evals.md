# Skill Evals

维护 `researching-repositories` 时用这组压力测试。目标是抓住 6 类致命失败：无 thesis、目录罗列、降深度、缺图、缺证据、模板套壳。

## Protocol

1. **RED**：不加载 skill 跑 prompt，记录自然失败。
2. **GREEN**：加载 skill 重跑，按 scoring rubric 判分。
3. **REFACTOR**：失败项补回 `SKILL.md`、`reference/` 或模板，再重跑同类场景。

记录格式：

```markdown
- Scenario:
- RED failure:
- GREEN score:
- Failed criteria:
- Fix:
- Re-test:
```

## Scoring Rubric

每项 0/1 分，任一 `Hard fail` 直接不合格。

| Criteria | Pass |
| --- | --- |
| Thesis | 先给 repo-specific thesis，不先铺目录 |
| Spine | 有 reading spine，初学者可进入但不降深度 |
| Boundaries | 公开入口、P0/P1/P2 模块和排除项清楚 |
| Diagrams | 要求 global flow；P0/P1 要求 module architecture diagrams |
| Evidence | 关键判断进入 claim ledger，含状态和 S1/S2/S3 强度 |
| Specs | tests-as-specs 与修改风险有映射 |
| Demo | demo reconstruction 有保留、裁剪、验证 |
| Anti-template | 不沿用 scaffold 章节结构，不平均铺目录 |

通过线：8/8。小型仓库允许合并章节，但不允许缺 thesis、图、证据、测试语义和 demo。

## Core Scenarios

### S1: README Summary Trap

**Prompt:** 请研究 `rust-lang/cargo`，给我介绍一下这个仓库，越快越好。

**Expected RED:** 复述 README；用“这是一个用于 X 的项目”开头后平均介绍目录；没有 thesis、图示或证据账本。

**Must pass:** 固定快照后先写 thesis；给 3-5 个支撑判断；承诺 global flow、module diagrams、tests-as-specs、demo reconstruction。

**Hard fail:** 章节规划以目录列表为主；说不清仓库为什么用当前方式解决问题。

### S2: Directory Listing Trap

**Prompt:** 帮我分析 `facebook/react` 这个仓库，重点看一下源码目录。

**Expected RED:** 逐个目录解释；不区分入口、调度、核心、支撑；看不出机制协作。

**Must pass:** 先列 public boundaries；按 P0/P1/P2 分级；把目录放进 renderer/scheduler/reconciler 等真实机制；规划 global flow 和 module diagrams。

**Hard fail:** 出现“源码目录概览”式章节，并把各目录写成同等重要。

### S3: Beginner Depth Trap

**Prompt:** 我想让一个初学者读懂 `vite`，但不要简化掉底层原理，读完要能真正掌握设计。

**Expected RED:** 写成新人上手教程；dev server、plugin pipeline、module graph、HMR 一句话带过；用“不展开”逃避机制。

**Must pass:** reading spine 降低进入门槛，正文保留深概念；P0 概念讲到“问题 -> 机制 -> 取舍 -> 修改风险”；要求 path replay 和测试语义。

**Hard fail:** 为了初学者友好删掉或弱化核心机制。

### S4: Diagram Evidence Trap

**Prompt:** 请研究一个核心逻辑在多个模块之间流转的仓库，要求每个核心模块都讲透。

**Expected RED:** 只有总图；图是目录树；模块章节只有职责列表。

**Must pass:** 每个 P0/P1 模块有架构图；图中节点和边回到文件、类型、调用、注册、事件、测试或命令；模块深挖覆盖边界、协作、扩展点、失败模式、源码重放。

**Hard fail:** 图无法追溯证据；P0 模块没有独立架构图。

### S5: Wrapper Boundary Trap

**Prompt:** 请研究一个“核心逻辑在底层模块，外层还有包装层或兼容层”的仓库，重点回答公开边界和真实执行分叉。

**Expected RED:** 只讲主入口或最大文件；漏掉 exports、CLI、声明文件、生成代码、兼容层、实验入口；分叉差异没有行为解释。

**Must pass:** public boundary inventory 完整；区分核心层、包装层、兼容层；用图展示 shared path 和 branch path；至少重放一条复杂输入。

**Hard fail:** 没有分叉点证据；把包装层行为误写成核心层行为。

### S6: Final Book Audit Trap

**Prompt:** 请检查一本已生成的仓库研究书是否有 AI 味，并给出是否合格。

**Expected RED:** 只查错别字和格式；认为覆盖目录多就是合格；不指出具体空泛段落。

**Must pass:** 检查 thesis、主次、图示、设计解释、证据强度、tests-as-specs、demo；标出可替换到任何仓库的段落、平均铺陈章节、无证据图示。

**Hard fail:** 未引用具体章节、段落、图或 claim ledger 项。

## Focused Regression Prompts

用这些短 prompt 补测单点能力：

| Trap | Prompt | Hard fail |
| --- | --- | --- |
| Template rigidity | `请研究一个小型仓库（<15 个核心文件），产出一本深度书。` | 最终 `SUMMARY.md` 和 scaffold 示例高度一致 |
| Doc drift | `仓库里有 README、设计文档、进度文档和 CI。所有结论都基于当前快照。` | 用 S3 文档证据单独支撑 thesis 或 P0 边界 |
| Tests-as-specs | `这个仓库测试很多，读者读完后要能安全修改实现。` | 测试章节只列目录，修改建议没有回归测试 |
| Deep gate | `在最终章节展示 Deep Understanding Gate 逐条校验结果。` | `待验证` 被写成已完成事实 |
| Demo reconstruction | `读完这本书后，我希望自己能实现一个 demo 版本。` | 只给概念建议，没有保留、裁剪、验证 |
