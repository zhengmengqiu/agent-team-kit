# AgentTeam 教练操作手册（Playbook）

> **一句话**：教练对话 = 导航仪；执行对话 = 干活；**kickoff.md 派工 + 按对话名追加 handoff + checkpoint** 闭环（教练窗不贴执行长文，不从执行窗拷全文）。  
> 模板复制块见 [coach-kickoff-template.md](./coach-kickoff-template.md)；命名见 [agent-dialog-naming.md](./agent-dialog-naming.md)；持久化见 [session-persistence.md](./session-persistence.md)。

## 模板速查（点击跳转到可复制块）

| 模板 | 链接 |
|------|------|
| A 开场 | [打开](./coach-kickoff-template.md#template-a) |
| B 续接 | [打开](./coach-kickoff-template.md#template-b) |
| C 派工落盘 | [打开](./coach-kickoff-template.md#template-c) |
| C-人读 | [打开](./coach-kickoff-template.md#template-c-user) |
| D 回传包 | [打开](./coach-kickoff-template.md#template-d) |
| D-人读 | [打开](./coach-kickoff-template.md#template-d-user) |
| E 定制约定 | [打开](./coach-kickoff-template.md#template-e) |
| F Phase1 | [打开](./coach-kickoff-template.md#template-f) |
| G Phase4 | [打开](./coach-kickoff-template.md#template-g) |
| H 全接口联调 | [打开](./coach-kickoff-template.md#template-h) |
| I commit/PR | [打开](./coach-kickoff-template.md#template-i) |
| J checkpoint | [打开](./coach-kickoff-template.md#template-j) |
| K 恢复 | [打开](./coach-kickoff-template.md#template-k) |
| L 归档 | [打开](./coach-kickoff-template.md#template-l) |
| P0 需求整理 | [打开](./coach-kickoff-template.md#template-p0) |
| P3-Q 待办确认问卷 | [打开](./coach-kickoff-template.md#template-p3-q) |
| Meta 维护 | [maintainer-templates.md](./maintainer-templates.md) |
| 交付边界 | [打开](./delivery-boundary.md) |

---

## 0. 前置准备（每个项目做一次）

| # | 动作 | 路径 / 说明 |
|---|------|-------------|
| 0.1 | 确认 AgentTeam 已初始化 | `.cursor/agents/`、`docs/agent-team/` |
| 0.2 | 配置共享 API 认证 | `~/.cursor/skills/project_pre-dev-api-auth/env/dev.local.md` |
| 0.3 | 配置项目测试地址 | `docs/agent-team/test-env.override.md` |
| 0.4 | 熟悉命名格式 | `{feature}-{phase}-{role}-{task}` |
| 0.5 | **开一个长期教练对话** | 侧栏重命名：`{项目}-教练-{feature}`；开场用 **模板 E** 声明 server-only 交付边界 |

---

## 1.1 开放问题 OQ（全生命周期）

> **原则**：OQ 贯穿全项目，但 **P1/P2 负责发现与确认**；P3~P7 **只继承、不静默猜测**。

| Phase | OQ 职责 | 强度 |
|-------|---------|------|
| **P0** | prd 待确认原样保留；图稿冲突记入整理报告 | 发现 |
| **P1** | OQ 表 + AskQuestion 确认阻塞 P2 项 | **最高** |
| **P2** | `开放问题决议` + 未决分支 + tasks `[OQ-0N]` | **高** |
| **P3** | L1 即时确认；L2 默认分支 + 写入 `pending-todos.md`；依赖不全持续补全待办 | 执行 |
| **P4** | L1 仍开放 → Blocked；L2/依赖待办 → **Pending-待确认**（不算 Fail） | 执行 |
| **P6** | 扫未文档化假设（magic 默认未引 OQ） | 拦截 |
| **P7** | 阻塞上线的 OQ → Push Gate NOT READY | 拦截 |

### 阻塞级

| 级别 | 未确认时 |
|------|----------|
| **P2** | 教练不给 P2 提示词 |
| **P3** | P2 须写默认分支后可进 P3 |
| **P4** | 相关 AC Blocked |
| **上线** | 不可生产全开 |

### Gate 1-OQ / Gate 2-OQ（教练必问）

P1 回传后：

```text
【Gate 1-OQ】阻塞 P2 的 OQ 是否已在 P1 对话确认？
- 是 → 贴决议摘要 → 给 P2
- 否 → 给 P1 补确认提示词，不进 P2
```

P2 回传后同理 **Gate 2-OQ**（阻塞 P3）。

### 1.1.1 确认策略 L1 / L2 / L3（P3 执行态）

> **原则**：方案级（L1）执行中必问；非 PO 级（L2/L3）默认分支推进，**写入待办清单持续补全**；L2 **整段 P3 结束后、进 P4 前**统一确认（方法 B）。

| 级别 | 别名 | 典型例子 | P3 行为 | 确认时机 |
|------|------|----------|---------|----------|
| **L1 方案级** | PO 级 | 核心业务规则、状态机、表结构分叉、Must AC 解读 | **AskQuestion 即时**；未确认 → ❌ 阻塞当前 task | 执行中 |
| **L2 依赖级** | 非 PO | 可选字段默认、配置项、缓存 TTL、联调顺序 | 按 design **默认分支**实现；记入 `pending-todos.md` | **P3 全部完成后**统一确认 |
| **L3 实现级** | 琐事 | 规范已覆盖（日志、分页默认等） | 直接按规范做，**不建 OQ** | 无需 |

**L1 判据（满足任一）**：改 API 契约或表结构；改 Must AC 通过/失败语义；方案分叉回滚成本高。

**依赖不全**：不阻塞整批开发——在 `pending-todos.md` 登记 **类型=依赖**，写清「缺什么 / 临时方案 / 补全后验证项」，P3 各批**持续追加与更新状态**。

### 待办清单 `pending-todos.md`（P2 后创建，P3~P7 持续维护）

路径：`docs/features/{feature_name}/pending-todos.md`（P2 Gate 通过时由 architect 或首条 P3 对话初始化）。

| 类型 | 说明 | 能否带开放进 P4 |
|------|------|-----------------|
| **L2确认** | 非 PO 级歧义，已实现默认分支 | ✅ 可；进 P4 前请你统一确认 |
| **依赖** | 中间件/账号/联调方/文档未齐 | ✅ 可；临时方案 + 补全计划 |
| **联调** | 前端/第三方接口未就绪 | ✅ 可；Blocked/Pending 测项 |
| **L1阻塞** | 方案级未确认 | ❌ 不可进 P4 |

**维护规则**：

1. P3 **每批**回传后：新增 / 更新 `pending-todos.md`（禁止只写在对话里）
2. 解决项：`状态=已解决` + `确认决议` + 验证证据
3. checkpoint（模板 J）同步「待办开放数」与 Top3
4. Push Gate：L1 + **阻塞上线** 待办须已解决；其余开放项写入 `archive/handoff` 或下一迭代

### Gate P3-batch / Gate P3→P4（教练必问）

**P3 每批回传后（Gate P3-batch）**——不阻塞下一批：

```text
【Gate P3-batch】
- L1 仍开放数 = 0 → 可进下一 P3 批
- 本批新增待办 → 已写入 pending-todos.md？
- L2/依赖项 → 仅汇总，不要求批次间确认
```

**P3 全部完成后、进 P4 前（Gate P3→P4）**——方法 B + **待办确认问卷（L0）**：

教练动作（`@agent-team-coach` **必须 Read** `pending-todos.md`）：

```text
【Gate P3→P4】
1. Read pending-todos.md
2. L1阻塞 + 状态=开放 → 计数 N；N>0 → ❌ 不进 P4
3. N=0 → 输出【待办确认问卷】（模板 P3-Q），按类型分组：
   L2确认 → 依赖 → 联调
4. 逐条请用户选：接受默认 / 改为：… / 延后
5. 用户未逐条答复 → 不给 P4
6. 用户答复后 → 决议汇总表 → 提醒更新 pending-todos + checkpoint → 给 P4（模板 G）
7. 开放项=0 → 声明已清空 → 直接给 P4
```

问卷格式见 [coach-kickoff-template.md § 模板 P3-Q](./coach-kickoff-template.md#template-p3-q)。

---

## 1.2 交付边界（服务端 vs 前端）

> 全文：[delivery-boundary.md](./delivery-boundary.md) · 教练 **模板 E** 默认约定

| Phase | 要求 |
|-------|------|
| **开教练** | 模板 E 写入「server-only」；checkpoint「定制约定」保留 |
| **P1** | proposal 含 `## 交付边界`；AC 标 `[Must]` / `[UI-Ref]` / `[Out-of-Scope]` |
| **P2** | API 表含 **消费者**、**前端依赖**；tasks 不含 UI 页 |
| **P4** | `[Must]` 必测；`[UI-Ref]` → Blocked-待前端联调；Push Gate 看 Must |

**Gate 1 人工补查（有 UI 材料时）**：proposal 中 Must 级 AC 是否覆盖核心业务规则；UI-Ref 是否未误标为 Must。

---

## 1. 双对话模型（必守）

| 对话类型 | @ 谁 | 模式 | 新开？ | 做什么 | 不做什么 |
|----------|------|------|--------|--------|----------|
| **教练对话** | `@agent-team-coach` | 任意 | **只开一次，长期保留** | 阶段判断、提示词、解读报告、下一步 | 写代码、写 spec、跑测试 |
| **整理对话** | `@requirement-input-prep` | **Agent** | **每需求一次** | 建 input/、场景推荐、整理报告 | 写 proposal |
| **执行对话** | analyst/architect/developer/tester/reviewer | **Agent** | **每步新开** | 按提示词交付 | 自己猜全流程 |

```
原始材料 → P0整理(模板P0) → 整理报告 → 教练(模板A) → P1执行(模板C) → Write handoff(模板D) → …
                ↑__________________|              ↑__________________________|
                     用户完成手动项                  每步更新 checkpoint(模板J)
```

---

## 2. 标准全流程（逐步操作）

> 替换占位：`{项目}` `{feature_name}` `{feature}`（短名）

### Step 0 — Phase 0 需求材料整理（推荐，在教练之前）

| 项 | 内容 |
|----|------|
| **何时** | 收到飞书 MD / HTML / Figma / Word，尚未建 `input/` |
| **新开** | ✅ Agent 对话 |
| **对话名** | `{feature}-P0-整理-input材料` |
| **@** | `@requirement-input-prep` |
| **提示词** | **[模板 P0](./coach-kickoff-template.md#template-p0)** + @ 原始材料路径 |
| **产出** | `docs/features/{feature}/input/` + **[整理报告 P0-D](./coach-kickoff-template.md#template-p0-d)** |
| **你** | 完成报告里「用户手动清单」（如飞书 Word 抠图） |
| **然后** | 再开教练（Step 0b） |

---

### Step 0b — 开教练对话（整个需求一次）

| 项 | 内容 |
|----|------|
| **操作** | 新开对话 → `@agent-team-coach` → 粘贴 **[模板 A](./coach-kickoff-template.md#template-a)** |
| **填写** | 项目、功能名、短名、性质、起始 Phase、需求要点 3~10 条 |
| **教练输出** | 当前 Phase + **Write kickoff.md** + 教练窗 **C-人读**（含新窗种子；禁止贴执行长文） |
| **Git** | 创建 `docs/features/{feature_name}/session-checkpoint.md`（**[模板 J](./coach-kickoff-template.md#template-j)**） |

---

### Step 1 — Phase 1 需求（proposal）

| 项 | 内容 |
|----|------|
| **需求输入（先做）** | 按 **[requirement-input-guide.md](./requirement-input-guide.md)** 整理 `docs/features/{feature}/input/`（MD/图/HTML/Figma/变更） |
| **新开执行对话** | ✅ 是 |
| **模式** | Agent |
| **对话名** | `{feature}-P1-需求-proposal编写` |
| **@** | `@requirements-analyst` |
| **派工** | 教练 Write **[kickoff.md](./coach-kickoff-template.md#template-c)**（内含 F + OQ）；窗内只出 **[C-人读](./coach-kickoff-template.md#template-c-user)** |
| **产出** | `docs/features/{feature_name}/proposal.md`（含 `## 开放问题` 表） |
| **Gate 1** | **你**审 proposal + **Gate 1-OQ**（阻塞 P2 的 OQ 已在 P1 对话确认）→ 回复教练「Gate 1 通过」或「Gate 1-OQ 已确认」 |
| **收尾** | 执行 Agent 向 `handoff-to-coach.md` **追加** `## 回传 {对话名}`（模板 D；禁止整文件覆盖）→ 聊天只出 D-人读 → 用户回教练窗「读 handoff」→ 教练 Read **该节** → 更新 checkpoint |

---

### Step 2 — Phase 2 设计（design + tasks）

| 项 | 内容 |
|----|------|
| **新开** | ✅ |
| **对话名** | `{feature}-P2-架构-design与tasks` |
| **@** | `@architect` |
| **Read** | `proposal.md`（含开放问题表） |
| **产出** | `design.md`（含 `## 开放问题决议`）、`tasks.md`（未决 task 标 `[OQ-0N]`） |
| **Gate 2** | **你**确认 design/tasks + **Gate 2-OQ**（阻塞 P3 的 OQ 已决议或接受默认分支） |
| **收尾** | 追加 `## 回传 {对话名}` → 用户回教练窗「读 handoff」→ 教练 Read 该节 → 更新 checkpoint |

---

### Step 3 — Phase 3 开发（建议分 3 批）

| 批次 | 对话名示例 | @ | 范围 |
|------|------------|---|------|
| **P3A** | `{feature}-P3A-开发-基础设施T1-T5` | `@backend-developer` | DDL、枚举、Domain、Gateway |
| **P3B** | `{feature}-P3B-开发-核心业务T6-T10` | 同上 | C/Admin 主路径、消息、Speed |
| **P3C** | `{feature}-P3C-开发-收尾T11-T14` | 同上 | 列表、批量、配置、baseline |

每批：教练 Write `kickoff.md`（C-人读给种子）+ 本批 Task；执行结束 **追加** 模板 D 到 `handoff-to-coach.md`（禁止整文件覆盖）+ checkpoint J。**不要一个窗口 T1–T14。**  
**并行上限 2**：最多同时两个执行窗；两窗同时派工时 `kickoff.md` 写两节 `## 派工 {对话名}`。  
**OQ / 待办**：L1 即时确认；L2/依赖写入 `pending-todos.md` 并持续补全；L1 未决 ❌ 阻塞本批；L2 不阻塞下一批（见 §1.1.1）。

---

### Step 4 — Phase 4 测试

| 项 | 内容 |
|----|------|
| **前置 Gate** | 整段 P3 完成 → 教练 **Read** `pending-todos.md` → **[模板 P3-Q](./coach-kickoff-template.md#template-p3-q)** 确认问卷 → 用户逐条答复 → 更新待办 |
| **新开** | ✅ |
| **对话名** | `{feature}-P4-测试-AC冒烟与报告` |
| **@** | `@tester` |
| **提示词** | **[模板 G](./coach-kickoff-template.md#template-g)** |
| **认证** | `project_pre-dev-api-auth` + `test-env.override.md` |
| **产出** | `test-report-{YYYYMMDD}.md` |
| **Gate** | 报告 READY → 进 P6 或先补测 |

**可选补测（审查/Push 前）：**

| 批次 | 对话名 | 说明 |
|------|--------|------|
| P4A | `{feature}-P4A-测试-缺口补测` | demo-feature 式 Part A |
| P4B | `{feature}-P4B-测试-回归对照` | 如 D7 分页 |

---

### Step 5 — Phase 6 代码审查

| 项 | 内容 |
|----|------|
| **新开** | ✅ |
| **对话名** | `{feature}-P6-审查-代码审查报告` |
| **@** | `@code-reviewer` |
| **输入** | design + test-report + git diff |
| **Gate** | 无 CRITICAL/HIGH（或你接受的 deferred 项） |

---

### Step 6 — 审查后修复与冒烟（P6-S*）

| 顺序 | 对话名 | @ | 何时 |
|------|--------|---|------|
| **S1** | `{feature}-P6-S1-开发-必须项修复` | developer | 审查 HIGH 必须项 |
| **S2** | `{feature}-P6-S2-开发-建议项修复` | developer | MEDIUM 建议项 |
| **S4** | `{feature}-P6-S4-测试-修复后冒烟` | tester | S1/S2 后 |
| **S4R** | `{feature}-P6-S4R-开发-回归修复` | developer | S4 Fail 时 |
| **S4p** | `{feature}-P6-S4p-测试-复测` | tester | S4R 后 |
| **S5** | `{feature}-P6-S5-测试-TOB/TOC全接口联调` | tester | **[模板 H](./coach-kickoff-template.md#template-h)**；Push Gate |

**规则：** 审查窗口**不改代码**；Fail → S4R → S4p，不要跳步 push。

---

### Step 7 — commit / PR（P7）

| 项 | 内容 |
|----|------|
| **条件** | Push Gate **READY** |
| **教练** | 粘贴 **[模板 I](./coach-kickoff-template.md#template-i)** |
| **对话名** | `{feature}-P7-开发-commit与PR` |
| **@** | 你确认后 `@backend-developer` 或自行 git |

---

### Step 8 — 迭代归档

| 项 | 内容 |
|----|------|
| **时机** | PR 合并 / 功能暂停 / 开 v2 |
| **写入** | `docs/features/{feature_name}/archive/handoff-{YYYYMMDD}.md`（**[模板 L](./coach-kickoff-template.md#template-l)**） |
| **更新** | `session-checkpoint.md` 顶部标 **已归档 → handoff** |
| **v2** | 先 Read handoff → 新建 checkpoint → 教练 **[模板 A](./coach-kickoff-template.md#template-a)** |

---

## 3. 每一步固定动作清单（执行者勾选）

```
□ 1. 教练 Write `kickoff.md`，窗内只给人读 + 种子
□ 2. 新开 Agent 对话，侧栏重命名为【对话名】，只贴种子
□ 3. 执行 Agent Read `kickoff.md` 对应「## 派工」节
□ 4. 执行完成 → 向 `handoff-to-coach.md` 追加 `## 回传 {对话名}`；窗口只出 D-人读
□ 5. 回教练窗：「<对话名> 完成，读 handoff」（不拷执行窗正文）
□ 6. 更新 session-checkpoint.md（模板 J）
□ 7. Gate 需你确认时，回复教练后再要下一步
```

---

## 4. 教练对话 vs 执行对话 — 说什么

| 发给教练 ✅ | 发给执行 Agent ✅ | 不要搞混 ❌ |
|-------------|-------------------|-------------|
| 「Phase X 完成，下一步？」 | 完整需求/Jira/设计细节 | 需求 PDF 只给教练 |
| 「<对话名> 完成，读 handoff」（教练 Read 文件） | 代码修改、测试命令 | 把执行窗全文拷回教练 |
| 优化后的 3~10 条需求要点 | test-report 路径 | 让 coach 跑 mvn test |
| 「权限我自己控，提示词忽略」**[模板 E](./coach-kickoff-template.md#template-e)** | MCP 查库证据 | |

---

## 5. 异常分支

| 情况 | 操作 |
|------|------|
| 执行 **❌ 阻塞** | 先追加 `## 回传 {对话名}`（状态❌）→ 回教练窗「读 handoff」→ 给 **修复对话名**（如 P6-S4R），**不要**进下一阶段 |
| 执行 **⚠️ 部分完成** | 教练判断是否可并行（最多 2）或必须先补测 |
| **教练对话被删** | **[模板 K](./coach-kickoff-template.md#template-k)** + Read checkpoint |
| **执行对话被删** | 同上；按 checkpoint「下一对话名」重开，已完成的勿重跑 |
| 审查 HIGH 未修 | 禁止 P7；走 S1 → S4 → S5 |

---

## 6. 项目差异速查

| 项目 | admin_base | app_base | mysql | 备注 |
|------|------------|----------|-------|------|
| **code_root（以 L2 为准）** | 见 `test-env.override.md` | 见 `test-env.override.md` | 见 `test-env.override.md` | 单模块 / 多模块 |
| spring-ai-study（验证仓示例） | `:8080` | `:8080` | `spring_ai_study`（可选） | 单模块 |
| project_pre-customer-info | `:6054/customer-info-admin-server` | `:6053/customer-info-server` | `project_pre_customer` | 多模块 |
| project_pre-operations | `:6220/project_pre-operations-admin` | `:6221/project_pre-operations` | `project_pre_operations` | 多模块 |

认证：Project_pre 多模块项目用 `project_pre-dev-api-auth`；B 端 `access_token`；C 端 `Bearer` + `lang`。学习/demo 单模块可直接 api-tester。

---

## 7. 一天上手（最小路径）

| 时刻 | 你做 | 用模板 |
|------|------|--------|
| 上午 | 开教练对话 | **[A](./coach-kickoff-template.md#template-a)** |
| | 拿 P1：开执行窗，只贴 C-人读种子 | **[C-人读](./coach-kickoff-template.md#template-c-user)** |
| 下午 | proposal Gate 1 通过 → 要 P2 | **[B](./coach-kickoff-template.md#template-b)** |
| | design Gate 2 → 要 P3A | **[B](./coach-kickoff-template.md#template-b)** |
| 每天结束 | 更新 checkpoint | **[J](./coach-kickoff-template.md#template-j)** |

---

## 8. 维护规则（共享层 / 扩展层）

> **改 AgentTeam 规范**用 `@agent-team-maintainer` + [maintainer-templates.md](./maintainer-templates.md) + [evolution-checkpoint.md](./evolution-checkpoint.md)。  
> **跑 feature** 用 `@agent-team-coach`。同一对话禁止混用。

| 层级 | 内容 | 维护原则 |
|------|------|----------|
| **共享层** | §1 OQ/待办/P3-Q、§1.2 交付边界、§2 双对话、§3 Simple 全流程；模板 A～P3-Q；7 执行 Agent + coach | 优化 **默认改这里**；Simple + Complex 同受益 |
| **Complex 扩展** | §11；`track=complex` 时追加产物/Gate | **append-only**；写「在 §3 基础上额外…」 |
| **禁止** | 双 playbook、`*-simple.md` / `*-complex.md` Agent 分叉 | |

**优化三问**（maintainer META-C）：Simple 要不要？仅 Complex？Gate 语义变了吗？

---

## 9. Gate 0 · 复杂度分轨

> **何时**：开教练（模板 A）后、进 P1 前（或 P0 整理报告后）。**默认 Simple**。

### 判轨 Checklist（命中 **≥2 项** → `track: complex`）

| # | 条目 |
|---|------|
| 1 | 涉及 **3+ 模块** 或跨服务调用 |
| 2 | 明确 **QPS/热点/强一致** 组合（非默认 B 档能覆盖） |
| 3 | 预计 P3 **tasks >15** 或跨 **多周** |
| 4 | 外部依赖 **≥3** 且长期不齐（联调 >2 周） |
| 5 | **分阶段上线**（MVP + 升档 / v1→v2） |
| 6 | 核心 **资金/库存/合规** 类强一致 |
| 7 | 需 **场景推导表 + 观测清单** 才能闭环验证 |

### 教练动作

```text
【Gate 0】
1. 与用户过 checklist（或用户已在模板 A 声明）
2. 写入 docs/features/{feature}/session-checkpoint.md → track: simple | complex
3. simple → §3 标准流程 + §10
4. complex → §3 + §11 追加要求；P2 提示词注明 Read §11
```

Checklist 调教 → `@agent-team-maintainer` 模板 **META-D**。

---

## 10. Simple Track（默认）

> 小需求、边界清晰。**完整步骤 = 本文 §3 标准全流程**，不重复展开。

| 项 | Simple 默认 |
|----|-------------|
| 容量 | 默认 **B 档**；proposal 可简写 |
| P3 | 1～3 批 |
| pending-todos | 少量；P3-Q 问卷 |
| P2 追加 | 无 §11 强制章节 |
| 观测 | 可选最小集（Must API 冒烟即可） |

**适用**：1～3 API、OQ 少、无明确升档、单模块内闭环。

---

## 11. Complex Track（扩展 · 在 §3 基础上额外）

> **不替换** §3；checkpoint `track=complex` 时 **追加** 下列要求。

| 阶段 | 额外要求 |
|------|----------|
| **P1** | 容量画像 **已知/假设/待验证** 三列；默认 B 档 + **升档触发条件** |
| **P1** | 模板 **[11-P1](./coach-kickoff-template.md#template-11-p1)** → proposal `## 容量画像` + `## 容量档位` |
| **P2** | 模板 **[11-P2](./coach-kickoff-template.md#template-11-p2)** → design `## 场景与负载推导` + `## 核心观测清单` |
| **Gate** | 可选 **Gate 2.5 方案冻结**（TL/用户确认 design 不再改 L1 · EV-02 待试点） |
| **P3** | 多批 + 明确 MVP 范围；OBS 相关 task（埋点/日志） |
| **P3→P4** | P3-Q 可含「观测基线延后」；问卷项可分组 |
| **上线后** | OBS 回填 → 触发升档 → handoff / 补丁 P2 |

**试点状态**：11-P1/11-P2 骨架已预置（2026-07-17 B1～B6）；**首个 Complex feature 试跑**后 META-F 反馈 → 再细化 EV-01。

---

## 12. 文档索引

| 文档 | 用途 |
|------|------|
| **本文 playbook** | 逐步操作 SOP |
| [coach-kickoff-template.md](./coach-kickoff-template.md) | 可复制粘贴块 A–L |
| [maintainer-templates.md](./maintainer-templates.md) | Meta META-A～E |
| [evolution-checkpoint.md](./evolution-checkpoint.md) | AgentTeam 规范演进存档 |
| [agent-dialog-naming.md](./agent-dialog-naming.md) | 对话名规则 |
| [session-persistence.md](./session-persistence.md) | checkpoint / archive |
| [workspace-layout.md](./workspace-layout.md) | 三根目录 kit / workspace_docs / code_root |
| [README.md](./README.md) | 目录入口 |

旧版散落说明：`docs-to/agent-team-实战/提示词教练.md` → 已合并至本文，以 `docs/agent-team/` 为准。

---

## 修订记录

| 日期 | 说明 |
|------|------|
| 2026-08-24 | 回传落盘：Write `handoff-to-coach.md` + D-人读；教练 Read 文件，不拷执行窗全文 |
| 2026-07-17 | §11 链 11-P1/11-P2 模板；Complex 骨架预置（B1～B6） |
| 2026-07-17 | 增 §8～§11 维护规则·Gate 0·Simple/Complex；agent-team-maintainer |
| 2026-07-17 | 增 Gate P3→P4 待办确认问卷（模板 P3-Q · L0） |
| 2026-07-17 | 增 §1.1.1 L1/L2/L3；pending-todos.md；Gate P3-batch / P3→P4（方法 B） |
| 2026-07-16 | 增 §1.1 开放问题 OQ 全生命周期；Gate 1-OQ / Gate 2-OQ |
| 2026-07-14 | 合并「提示词教练」+ coach-kickoff-template，产出逐步 Playbook |
| 2026-07-14 | 模板链接改为 `#template-a`～`#template-l`，修复 Cursor 点击跳转 |
