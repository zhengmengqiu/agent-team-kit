# AgentTeam 使用说明（明细版）

> **对象**：需要完整理解 AgentTeam 工作流、角色边界、分轨、Gate、模板体系的人。  
> **只想快速跑一个需求**：看 [`AgentTeam-快速上手.md`](./AgentTeam-快速上手.md)。  
> **权威源**：本文是导读；以仓库内文档为准 —— `docs/agent-team/coach-playbook.md`（SOP）、`coach-kickoff-template.md`（模板）、`.cursor/agents/`（Agent 定义）。

---

## 目录

1. [AgentTeam 是什么](#1)
2. [三类对话与角色边界](#2)
3. [目录与产出路径约定](#3)
4. [完整生命周期（P0～P8）](#4)
5. [复杂度分轨：Simple vs Complex](#5)
6. [Gate 体系（必须理解）](#6)
7. [开放问题 OQ 与待办清单 pending-todos](#7)
8. [模板速查（A～L、P0、OQ、P3-Q、11-P1/P2）](#8)
9. [规范维护：@agent-team-maintainer 与 META 模板](#9)
10. [两个现成 mock 需求 + 完整开跑提示词](#10)
11. [常见问题 FAQ](#11)

---

<a id="1"></a>

## 1. AgentTeam 是什么

AgentTeam 是 **agent-team-kit**（**标准源 / kit**）的一套 **多 Agent 协作开发工作流**。核心思想：

- **教练对话是导航仪**（长期保留一个），只判断阶段、给提示词、把关 Gate；
- **执行对话按步新开**，每一步由专门 Agent（分析/架构/开发/测试/审查）干活；
- 通过 **对话命名 + `handoff-to-coach.md` + Git checkpoint** 形成闭环，避免上下文污染与丢步。不要拷执行窗全文回教练。

> 新业务项目接入 kit，见 `docs/agent-team/bootstrap-new-project.md`。

---

<a id="2"></a>

## 2. 三类对话与角色边界

| 对话 | @谁 | 模式 | 新开频率 | 职责 | 禁止 |
|------|-----|------|----------|------|------|
| **教练** | `@agent-team-coach` | 任意 | 每需求**一次**，长期保留 | 判阶段、给提示词、解读报告、把关 Gate | 写代码、写 spec、跑测试 |
| **整理（P0）** | `@requirement-input-prep` | Agent | 每需求一次 | 建 `input/`、场景识别、整理报告 | 写 proposal |
| **执行** | `@requirements-analyst` / `@architect` / `@backend-developer` / `@tester` / `@code-reviewer` | Agent | 每步**新开** | 按提示词交付产物 | 自己臆造全流程 |
| **规范维护** | `@agent-team-maintainer` | 任意 | 改规范时开 | 优化 playbook/模板/分轨、维护 evolution-checkpoint | 写业务代码、替教练发 feature 提示词 |

**硬性铁律**：

1. 教练只导航，**执行一律在另开的执行对话完成**。
2. **改 AgentTeam 规范**用 maintainer，**跑 feature** 用 coach，**同一对话禁止混用**。
3. 本标准源 **server-only**：只交付后端 REST API，不交付前端页面 / UI E2E。

---

<a id="3"></a>

## 3. 目录与产出路径约定（强制）

功能 spec 统一写入 `docs/features/{feature_name}/`，**禁止**写入 `.dev-flow/`。

| 文档 | 路径 |
|------|------|
| 需求 input（P0） | `docs/features/{feature}/input/`（prd.md、images/ 等） |
| proposal | `docs/features/{feature}/proposal.md` |
| design | `docs/features/{feature}/design.md` |
| tasks | `docs/features/{feature}/tasks.md` |
| 待办清单 | `docs/features/{feature}/pending-todos.md`（P2 后创建，P3~P7 持续维护） |
| 会话存档 | `docs/features/{feature}/session-checkpoint.md`（含 `track` 字段） |
| **回传教练** | `docs/features/{feature}/handoff-to-coach.md`（执行结束覆盖写） |
| 测试报告 | `docs/features/{feature}/test-report-{YYYYMMDD}.md` |
| 归档 | `docs/features/{feature}/archive/handoff-{YYYYMMDD}.md` |

`{feature_name}`：用户指定或从需求标题 kebab-case 推导（≤40 字符）。

**AgentTeam 规范文档**（不随 feature 变）在 `docs/agent-team/`；Agent 定义在 `.cursor/agents/`。

---

<a id="4"></a>

## 4. 完整生命周期（P0～P8）

| Phase | 对话名示例 | @ | 产出 | 关键 Gate |
|-------|-----------|---|------|-----------|
| **P0** 需求整理 | `{feature}-P0-整理-input材料` | `@requirement-input-prep` | `input/` + 整理报告 | — |
| **开教练** | `{项目名}-教练-{feature}` | `@agent-team-coach` | checkpoint + `track` | **Gate 0** 分轨 |
| **P1** 需求 | `{feature}-P1-需求-proposal编写` | `@requirements-analyst` | proposal.md（含开放问题表） | **Gate 1 / Gate 1-OQ** |
| **P2** 设计 | `{feature}-P2-架构-design与tasks` | `@architect` | design.md + tasks.md + 初始化 pending-todos | **Gate 2 / Gate 2-OQ** |
| **P3** 开发 | `{feature}-P3A/B/C-开发-...` | `@backend-developer` | 代码（分批） | **Gate P3-batch / P3→P4** |
| **P4** 测试 | `{feature}-P4-测试-AC冒烟与报告` | `@tester` | test-report | 报告 READY |
| **P6** 审查 | `{feature}-P6-审查-代码审查报告` | `@code-reviewer` | 审查报告 | 无 CRITICAL/HIGH |
| **P6-S*** 修复 | `{feature}-P6-S1/S4/S5-...` | developer / tester | 修复 + 复测 | Push Gate |
| **P7** 提交 | `{feature}-P7-开发-commit与PR` | `@backend-developer` / 你 | commit / PR | Push Gate READY |
| **P8** 归档 | — | 你 | archive/handoff | — |

每步固定动作：教练给【对话名】+ 提示词 → 新开对话粘贴 → 执行 → **Write** `handoff-to-coach.md`（聊天只出 D-人读）→ 回教练「读 handoff」→ 更新 checkpoint。

> **P3 分批**：不要一个窗口做 T1–T14。建议基础设施 / 核心业务 / 收尾各一批。

---

<a id="5"></a>

## 5. 复杂度分轨：Simple vs Complex

分轨在 **Gate 0**（开教练后、进 P1 前）决定，**默认 Simple**。原则：**Complex 不替换 Simple 流程，而是在标准流程之上追加 §11 内容**。

### 判轨 Checklist（命中 ≥2 项 → complex）

| # | 条目 |
|---|------|
| 1 | 涉及 3+ 模块 或跨服务调用 |
| 2 | 明确 QPS/热点/强一致 组合（超默认 B 档） |
| 3 | 预计 P3 tasks >15 或跨多周 |
| 4 | 外部依赖 ≥3 且长期不齐 |
| 5 | 分阶段上线（MVP + 升档 / v1→v2） |
| 6 | 核心资金/库存/合规类强一致 |
| 7 | 需场景推导表 + 观测清单才能闭环验证 |

### 两轨差异

| 维度 | Simple（§10） | Complex（§11 · 追加） |
|------|--------------|----------------------|
| 流程主干 | playbook §3 | §3 + §11 |
| P1 | 容量默认 B 档，可简写 | `## 容量画像`（已知/假设/待验证）+ `## 容量档位`（升档触发）→ 模板 **11-P1** |
| P2 | 常规 design | 追加 `## 场景与负载推导` + `## 核心观测清单` → 模板 **11-P2** |
| P3 | 1～3 批 | 多批 + 明确 MVP + OBS task |
| 额外 Gate | 无 | 可选 Gate 2.5 方案冻结（待试点） |
| 上线后 | 常规归档 | OBS 回填 → 升档 → handoff / 补丁 P2 |

判轨结果写入 `session-checkpoint.md` 的 `track: simple | complex`。想改判轨规则 → maintainer 模板 **META-D**。

---

<a id="6"></a>

## 6. Gate 体系（必须理解）

| Gate | 时机 | 判定 |
|------|------|------|
| **Gate 0** | 开需求时 | simple / complex，写入 checkpoint |
| **Gate 1** | proposal 后 | 核心章节完整；你审核 |
| **Gate 1-OQ** | proposal 后 | 阻塞 P2 的开放问题已在 P1 对话确认 |
| **Gate 2** | design 后 | design/tasks 你确认 |
| **Gate 2-OQ** | design 后 | 阻塞 P3 的 OQ 已决议或接受默认分支 |
| **Gate P3-batch** | P3 每批后 | L1 开放数=0 可进下一批；不阻塞 L2 |
| **Gate P3→P4** | P3 全部完成后 | 教练 Read pending-todos → 出 **P3-Q 问卷** → 你逐条答复 |
| **Push Gate** | P7 前 | Must 级 AC 测试 READY；L1 + 阻塞上线待办已解决 |

**阻塞级**：L1（方案级）未确认 → 阻塞当前 task / 不进 P4；L2（依赖级）默认分支推进，进 P4 前统一确认；L3（实现级）按规范直接做。

---

<a id="7"></a>

## 7. 开放问题 OQ 与待办清单 pending-todos

### OQ（开放问题）贯穿全生命周期

- **P1/P2 是主战场**：发现、登记、确认阻塞项；
- **P3~P7 只继承、不静默猜测**；
- proposal 含 `## 开放问题` 表；design 含 `## 开放问题决议`。

### pending-todos.md（P2 后创建，持续维护）

| 类型 | 说明 | 能否带开放进 P4 |
|------|------|-----------------|
| L2确认 | 非 PO 级歧义，已实现默认分支 | ✅ 进 P4 前统一确认 |
| 依赖 | 中间件/账号/联调方未齐 | ✅ 临时方案 + 补全计划 |
| 联调 | 前端/第三方接口未就绪 | ✅ Blocked/Pending 测项 |
| L1阻塞 | 方案级未确认 | ❌ 不可进 P4 |

**维护规则**：P3 每批回传后更新 pending-todos（禁止只写对话里）；解决项写「确认决议」+ 验证证据；checkpoint 同步「待办开放数」。

---

<a id="8"></a>

## 8. 模板速查

全部模板在 `docs/agent-team/coach-kickoff-template.md`，用 `#template-x` 锚点跳转。

| 模板 | 用途 |
|------|------|
| A 开场 | 教练对话首条（整个需求发一次） |
| B 续接 | 贴回传包要下一步 |
| C 执行头 | 每条执行提示词顶部 |
| D 回传包 | 执行 Agent 结束必出 |
| E 定制约定 | 权限、交付边界等自控项 |
| F Phase1 | proposal 执行提示词 |
| OQ | P1/P2 开放问题块 |
| G Phase4 | AC 冒烟测试 |
| H 全接口联调 | push 前 TOB/TOC |
| I commit/PR | 向教练要 P7 |
| J checkpoint | 更新 session-checkpoint（含 track） |
| K 恢复 | 对话删了从 checkpoint 恢复 |
| L 归档 | handoff archive |
| P0 | Phase 0 需求整理 |
| P3-Q | Gate P3→P4 待办确认问卷 |
| **11-P1** | Complex P1 容量画像 + 容量档位 |
| **11-P2** | Complex P2 场景推导 + 核心观测清单 |

---

<a id="9"></a>

## 9. 规范维护：@agent-team-maintainer

**改 AgentTeam 规范本身**（分轨、playbook、模板、Agent 定义）用 `@agent-team-maintainer`，模板在 `docs/agent-team/maintainer-templates.md`，存档在 `docs/agent-team/evolution-checkpoint.md`。

| 模板 | 用途 |
|------|------|
| META-A | 关窗口后续接规范优化 |
| META-B | 新分轨 / 轨道调整提案 |
| META-C | 变更归类（共享层 vs Complex-only） |
| META-D | Gate 0 checklist 调教 |
| META-E | 一轮优化收尾（更新 evolution-checkpoint） |
| **META-F** | Simple/Complex **试跑反馈**（结构化上报规范问题） |

**维护三问**（判断变更归属）：Simple 也需要？→ 共享层；仅 Complex？→ §11 扩展；改 Gate 语义？→ 共享层同步说明。

**禁止**：双 playbook（`*-simple.md` / `*-complex.md`）、Agent 分叉（`architect-simple.md` 等）。

### 试跑期间如何反馈问题（重要）

- **流程/下一步提示词问题** → 教练对话 `@agent-team-coach`；
- **模板缺项 / Agent 没 Read / 分轨规则问题** → maintainer 对话，用 **META-F** 结构化上报（feature、轨道、Phase、问题清单表、证据片段）。
- 每个 Phase 有小问题就贴，不必攒到 P7。

---

<a id="10"></a>

## 10. 两个现成 mock 需求 + 完整开跑提示词

| 需求 | 预期轨道 | input 路径 |
|------|----------|-----------|
| Spring AI 单轮对话 API | simple | `docs/features/spring-ai-single-chat/input/prd.md` |
| 后台 RBAC 核心 | complex | `docs/features/admin-rbac-core/input/prd.md` |

### Simple 试跑开场（spring-ai-single-chat）

```text
@agent-team-coach

这是 AgentTeam 教练对话。只指导流程和提示词，不写代码、不产出 spec。

【项目】{验证仓项目名，如 spring-ai-study}
【功能】spring-ai-single-chat
【短名】spring-ai-single-chat
【性质】新功能 · 学习实验
【当前】从 Phase 1 开始（P0 已就绪，跳过）
【已有产出】docs/features/spring-ai-single-chat/input/prd.md

【需求要点】
1. Spring AI 整合，单轮对话 REST API
2. POST /api/v1/chat/message + GET /api/v1/chat/health
3. application.yaml + 环境变量配置 API Key，禁止硬编码
4. 空 message→400；未配置→503；上游失败→502
5. server-only，无 UI；AC 见 input/prd.md

【复杂度】小需求 → 请 Gate 0 确认 simple

【补充约定（模板 E）】
- 交付边界：仅后端 REST API，不交付前端与 UI E2E
- AC 分层：[Must] / [UI-Ref] / [Out-of-Scope]

请给我：
0. Gate 0 判轨 + 写入 session-checkpoint 的 track
1. 当前 Phase 判断
2. 是否新开执行对话
3. 带【对话名】的完整 P1 执行提示词
```

### Complex 试跑开场（admin-rbac-core）

```text
@agent-team-coach

这是 AgentTeam 教练对话。只指导流程和提示词，不写代码、不产出 spec。

【项目】{验证仓项目名，如 spring-ai-study}
【功能】admin-rbac-core
【短名】rbac-core
【性质】新功能 · Complex 轨试跑
【当前】从 Phase 1 开始（P0 已就绪，跳过）
【已有产出】docs/features/admin-rbac-core/input/prd.md
【母文档】docs/原型设计/通用后台管理系统产品需求文档（PRD）.md（仅摘 §3、§5.4 的 RBAC MVP 切片）

【需求要点】
1. 用户/角色/权限（RBAC）核心后端 API + 落库
2. 用户 CRUD + 启用禁用 + 分配角色；角色 CRUD + 绑权限码；权限码 CRUD
3. 鉴权：给定 userId + permissionCode → allow/deny；越权返回 403
4. 超级管理员角色不可删除；列表分页默认 10 条
5. MVP 本迭代：用户 + 角色 + 基础鉴权；菜单/数据权限为后续
6. server-only；AC 见 input/prd.md

【复杂度】切片较大 → 请 Gate 0 checklist 核对，预期 complex

【补充约定（模板 E）】
- 交付边界：仅后端 REST API，不交付前端与 UI E2E
- AC 分层：[Must] / [UI-Ref] / [Out-of-Scope]

请给我：
0. Gate 0 判轨 + 写入 session-checkpoint 的 track（预期 complex）
1. 当前 Phase 判断
2. 是否新开执行对话
3. 带【对话名】的完整 P1 执行提示词（含 Write `handoff-to-coach.md` 要求；Complex 轨须含模板 11-P1：容量画像 + 容量档位）
```

> 后续每步用 **模板 B**：回教练窗发「<对话名> 完成，读 handoff」（不要拷执行窗正文）。

---

<a id="11"></a>

## 11. 常见问题 FAQ

**Q：分轨是我选还是系统选？**  
A：Gate 0 由教练 + 你一起过 checklist，默认 Simple；命中 ≥2 项判 Complex。你可表达偏好，但以 checklist 为准。

**Q：整份大 PRD 能当一个 feature 吗？**  
A：不建议。大 PRD 是「母文档 / 需求池」，应切成多个 feature，每个单独走流程（如从通用后台 PRD 切 `admin-rbac-core`）。

**Q：教练对话/执行对话被删了？**  
A：教练用模板 K + Read `session-checkpoint.md` 恢复，按「下一对话名」重开，已完成的不重跑。

**Q：我要自己控接口权限？**  
A：开教练时用模板 E 声明一次，后续提示词自动省略权限校验相关。

**Q：为什么要每步新开对话？**  
A：保持上下文干净，避免一个窗口塞满全流程导致 Agent 跑偏；靠对话命名 + `handoff-to-coach.md` + checkpoint 串起来。

**Q：改了 AgentTeam 规范，怎么同步到别的业务项目？**  
A：见 `docs/agent-team/sync-prompts.md`（回流 / 部署 / 横向复制话术）。

---

## 关键文档索引

| 文档 | 用途 |
|------|------|
| `docs/agent-team/coach-playbook.md` | 逐步 SOP（权威） |
| `docs/agent-team/coach-kickoff-template.md` | 可复制模板 A～L、P0、OQ、P3-Q、11-P1/P2 |
| `docs/agent-team/maintainer-templates.md` | 规范维护 META-A～F |
| `docs/agent-team/evolution-checkpoint.md` | 规范演进存档 |
| `docs/agent-team/delivery-boundary.md` | 服务端 vs 前端、AC 分层 |
| `docs/agent-team/requirement-input-guide.md` | 需求输入整理（P0） |
| `docs/agent-team/bootstrap-new-project.md` | 复制到新项目 |
| `docs/agent-team/workspace-layout.md` | 三根目录 kit / workspace_docs / code_root |
| `.cursor/agents/` | 各 Agent 定义 |
