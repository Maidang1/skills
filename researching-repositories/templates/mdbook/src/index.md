# __REPO_NAME__ 深度研究

## 研究快照

| 项 | 值 |
| --- | --- |
| 仓库地址 | `__REPO_URL__` |
| 分支 | `<branch>` |
| Commit | `<commit-sha>` |
| 工作区状态 | `<clean / dirty + summary>` |
| 研究日期 | `<yyyy-mm-dd>` |
| 研究范围 | `<核心目录、包、模块>` |
| 排除范围 | `<不研究的目录、历史版本、生态包>` |
| 核心源码规模 | `<非生成、非依赖、非测试文件数>` |
| 读者画像 | `<第一次深入阅读该仓库、希望掌握设计理念的工程师>` |

## 仓库 Thesis

> 用一句话说明这个仓库为什么存在，以及它解决问题的核心方式。

支撑判断：

| 判断 | 类型 | 证据 | 状态 |
| --- | --- | --- | --- |
| `<设计重心>` | `事实/推断` | `<path#symbol/test/command>` | `已验证/待验证/有漂移` |
| `<关键抽象>` | `事实/推断` | `<path#symbol/test/command>` | `已验证/待验证/有漂移` |
| `<核心流程或取舍>` | `事实/推断` | `<path#symbol/test/command>` | `已验证/待验证/有漂移` |

## Research Packet

| 项 | 内容 |
| --- | --- |
| Public boundaries | `<包入口、CLI、子路径、插件、配置、兼容层>` |
| P0 modules | `<没有它就无法解释 thesis 的模块>` |
| P1 modules | `<关键支撑模块>` |
| P2/P3 exclusions | `<边缘设施、生成物、依赖等>` |
| Critical flows | `<2-4 条入口到输出的关键路径>` |
| Representative tests | `<测试族和行为语义>` |
| Drift risks | `<README/design docs/status docs 与源码可能不一致处>` |

## 这本书回答什么

1. 这个仓库为什么存在，核心设计理念是什么。
2. 公开入口有哪些，入口如何进入核心能力。
3. 重要模块各自承担什么角色、边界在哪里、为什么这样拆。
4. 一条复杂输入如何沿源码分支变成输出。
5. 哪些测试定义行为规格，修改时应该回归什么。
6. 如何基于这些理解实现一个最小 demo。

## Reading Spine

- 第一遍：按 SUMMARY.md 的“全景 -> 主流程 -> 核心模块 -> 测试/Demo”顺序读。
- 第二遍：跟着 global flow diagram，从入口追到核心模块。
- 第三遍：选一个 P0 模块，结合 module architecture diagram 和 tests-as-specs 做源码级重放。

## 图示清单

| 图 | 位置 | 证据状态 |
| --- | --- | --- |
| Global flow diagram | `<章节或文件>` | `<已验证/待验证>` |
| Module architecture diagram: `<P0 module>` | `<章节或文件>` | `<已验证/待验证>` |
| Path replay diagram: `<critical flow>` | `<章节或文件>` | `<已验证/待验证>` |

## 证据约定

- `事实`：当前源码、测试或命令结果直接支持。
- `推断`：多处证据支撑，但不是源码直接声明。
- `建议`：为了学习路径、demo 或修改策略做出的提炼。
- 状态：`已验证 / 有漂移 / 待验证`。
- 强度：`S1` 当前源码 + 测试/命令；`S2` 当前源码 + 符号/调用链；`S3` 文档、注释或名称线索。
