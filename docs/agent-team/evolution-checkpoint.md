# AgentTeam Evolution Checkpoint

> **用途**：调教 AgentTeam 规范本身的会话存档（**不是** feature 的 `session-checkpoint.md`）。  
> **维护 Agent**：`@agent-team-maintainer` · 模板见 [maintainer-templates.md](./maintainer-templates.md)

**最后更新**：2026-08-27  
**状态**：进行中（**L1 标准源已稳定** · 本轮 **回传落盘 L0**）

---

## 当前焦点

| 项 | 内容 |
|----|------|
| 主题 | **回传落盘** `handoff-to-coach.md`（L0 · 2026-08-27） |
| 下一动作 | 试跑教练→执行→Write handoff→教练 Read；或 META-C 细化/关闭 EV-04 |
| 建议对话名 | `agentteam-meta-handoff-落盘` |

---

## Complex 业务 · AI 编程适用性（原则 · 2026-07-17）

> **背景**：复杂业务场景下常见「AI 不好用」——多数不是模型不能写代码，而是 **Complex 场景仍用 Simple 打法**（一次对话、静默猜规则、无验证闭环）。

### 核心判断

```
AI 编程好用程度 ≈ f(业务明确度, 上下文结构化, 验证反馈速度)
```

- **Simple 轨**：边界清晰 → 共享层 §3 + Gate + P3-Q 即可  
- **Complex 轨**：规则密度高 → **不能一次猜完**；须 §11 + 分批 + OQ/L1 + 观测清单  

### 四不（Complex 禁止）

1. 一个对话从 PRD 写到上线  
2. L1（表结构 / API 契约 / 状态机）未确认就进 P3  
3. 文档未写视为「可猜」  
4. 用「编译通过」代替业务验收  

### 四要（Complex 必须）

1. **切片**：史诗 PRD → 多个 feature（如 RBAC 切片）  
2. **先 spec 后 code**：P1/P2 Gate 是人审 AI 产物，不是形式主义  
3. **分批 + 待办**：P3 多批、pending-todos、P3-Q 逐条确认  
4. **场景 + 观测**：11-P1/11-P2 → P4 可验证  

### 机制对照（规范为何这样设计）

| 痛点 | AgentTeam 机制 |
|------|----------------|
| AI 猜业务规则 | OQ · L1 即时确认 · Gate 1-OQ / 2-OQ |
| 一次做太多 | Gate 0 分轨 · P3 分批 · MVP 范围 |
| 默认实现未确认 | pending-todos · P3-Q（方法 B） |
| 做完不知对不对 | Complex §11 观测清单 · test-report Must AC |
| 导航与执行混杂 | coach / 执行 Agent 分对话 |

### AI 替代不了（须人 Gate）

L1 业务拍板、合规/资金类规则、全新领域第一性定义 — **不是 AgentTeam bug**，Gate 必须人确认。

### 试跑反馈归类 → 改哪里

| 失败类型 | 含义 | 优先改 |
|----------|------|--------|
| **规则** | OQ/L1 未确认，AI 猜错业务 | analyst/coach · Gate 1-OQ · 11-P1 |
| **上下文** | 对话过长、漏 Read、前后矛盾 | 分批 · checkpoint · 模板 C 强制 Read |
| **验证** | 无观测/AC 映射，不知对不对 | §11 · 11-P2 · tester · P4 |

详见 [maintainer-templates.md META-F](./maintainer-templates.md#meta-f)。

---

## 长期维护与团队推广（L1 → L3）

| 档位 | 条件 | 动作 |
|------|------|------|
| **L1 标准源稳定** | Simple + Complex 各 ≥1 次试跑；META-F 无 CRITICAL 规范缺口 | ✅ **已达成（2026-07-20）** · 维护 evolution-checkpoint · META-E 每轮收尾 |
| **L2 业务项目复制** | L1 + [bootstrap-new-project.md](./bootstrap-new-project.md) 清单验证 | 新项目复制 `.cursor/agents/` + `docs/agent-team/` |
| **L3 团队推广** | L2 + ≥2 个项目 [sync-prompts 场景 1 回流](./sync-prompts.md) | 内部分享：教练窗 + 执行窗 + Gate；推广 **mock 试跑**（single-chat / rbac 切片） |

**推广勿跳过**：未试跑勿整包推广；先 **Simple mock → Complex 切片 → 真实需求** 三阶。

**迭代节奏建议**：每个 feature 试跑 → META-F（1 条即可）→ 攒 3～5 条 → maintainer META-C/E 一批改规范。

---

## 轨道定义（Gate 0）

| 轨道 | 说明 | checkpoint 字段 |
|------|------|-----------------|
| **simple** | 默认；小需求；走 playbook §3 标准全流程 | `track: simple` |
| **complex** | 命中 §9 checklist ≥2 项；追加 §11 + 11-P1/11-P2 | `track: complex` |

判轨 checklist 见 [coach-playbook.md §9](./coach-playbook.md#9-gate-0--复杂度分轨)。

---

## 维护规则（摘要 · 详情 playbook §8）

### 共享层（优化默认改这里）

- `coach-playbook.md` §1、§1.2、§2、§3（Simple 主干）
- `coach-kickoff-template.md`（A～L、P0、OQ、P3-Q）
- `.cursor/agents/`（feature 执行 7 个 + coach；**不含** maintainer 业务逻辑复制）
- `agent-team-paths.mdc`、`delivery-boundary.md`、`session-persistence.md`

### Complex-only 扩展（append-only）

- `coach-playbook.md` §11
- `coach-kickoff-template.md` **11-P1 / 11-P2**（2026-07-17 B1～B6 预置）
- Gate 2.5 方案冻结（可选 · EV-02 待试点）
- P3/P4 Complex 专用段（B7～B8 · 可 META-C 按需细化）

### 已决（勿重复讨论）

- [x] 不加 `frontend-developer`；server-only 标准源
- [x] pending-todos **不加** P0/P1/P2 优先级字段
- [x] Gate P3→P4 待办确认问卷（P3-Q · L0）
- [x] L1/L2/L3 + 方法 B（整段 P3 后统一确认 L2）
- [x] 全栈另建 Team；标准源保持服务端
- [x] 分轨 = 单 playbook 共享层 + §11 扩展，禁止双 playbook / 双 Agent 分叉
- [x] **EV-06 P0+P1**（2026-07-20）：trial 硬停 · AUDIT · trial-log · **教练 Gate 后附带 AUDIT 提示词**
- [x] Complex 业务 AI 适用性：Complex 须结构化，禁止 Simple 一把梭（见上节）
- [x] **推广 L1**（2026-07-20）：Simple + Complex 各 ≥1 次试跑通过；META-F 无 CRITICAL

---

## 进行中

- [x] Complex 轨试跑 `admin-rbac-core`（11-P1/11-P2 + P3 一批 + P3-Q）
- [ ] Gate 0 在真实需求上校准 checklist（本轮 META-F **无**误判反馈 → 保留观察，不改 §9）
- [ ] EV-04：可 META-C 细化 B7～B8（按需 append）；EV-01 / EV-02 继续搁置
- [ ] L2 推广就绪：对照 [bootstrap-new-project.md](./bootstrap-new-project.md) 清单验证（L1 已达成）

---

## 已完成（规范演进）

- [x] **回传落盘**（2026-08-27）：执行 Write `handoff-to-coach.md`；聊天只出 D-人读；教练 Read 文件；工作区三根目录
- [x] 2026-07-20 **Complex 轨试跑通过**（admin-rbac-core · trial-validation · P3-Q · META-F 无 CRITICAL · 本轮零改规范文件）
- [x] 2026-07-20 **推广 L1 标准源稳定**（Simple `spring-ai-single-chat` + Complex `admin-rbac-core`）
- [x] 2026-07-20 **EV-06 P0+P1**：trial-validation · 教练附带 AUDIT · trial-run-guide
- [x] 2026-07-17 **适用性原则 + 推广 L1～L3 + META-F 失败类型列**
- [x] 2026-07-17 **Simple 轨试跑通过**（spring-ai-single-chat · 用户确认）
- [x] 2026-07-17 **B1～B6**：11-P1/11-P2、analyst/architect/coach Complex 段、§11 链模板
- [x] 2026-07-17 Complex mock 种子 `docs/features/admin-rbac-core/input/prd.md`
- [x] 2026-07-17 `@agent-team-maintainer` + maintainer-templates + evolution-checkpoint
- [x] 2026-07-17 playbook §8～§11；P3-Q；L1/L2/L3；pending-todos
- [x] 2026-07-16 P0、OQ、delivery-boundary、AC 分层（自 project_pre-customer-info 回流）

---

## 变更 backlog（可选）

| ID | 想法 | 归类建议 | 状态 |
|----|------|----------|------|
| EV-01 | P1/P2 容量画像三列 + 默认 B 档 | Complex §11 · 试跑未暴露缺口 | 搁置 |
| EV-02 | Gate 2.5 TL 方案冻结 | Complex-only | 搁置（待试点） |
| EV-03 | coach Read 待办生成 P3-Q | 共享层 · 已落地 | 完成 |
| EV-04 | backend-developer / tester Complex 段 | Complex-only · B7～B8 | **可 META-C 细化（按需）** |
| EV-05 | 团队推广 onboarding 一页纸（coach 三窗图） | 共享层 · L3 前 | **可启动**（L1 已达成） |
| EV-06 | 试跑审计机制 | 共享层 | **P0+P1 完成**；P2 META-G 草稿 / `@agent-team-auditor` 待需 |

---

## 关键文档

- [README.md](./README.md)
- [coach-playbook.md](./coach-playbook.md)
- [workspace-layout.md](./workspace-layout.md)
- [maintainer-templates.md](./maintainer-templates.md)（含 **META-F 试跑反馈**）
- [sync-prompts.md](./sync-prompts.md)
- [trial-run-guide.md](./trial-run-guide.md)（**试跑 SOP · EV-06**）
- [bootstrap-new-project.md](./bootstrap-new-project.md)

---

## 给 maintainer 的一句话

维护 AgentTeam 规范：先 Read 本文件；试跑按 **trial-run-guide**；反馈 **META-F**（可 Read trial-log）。当前焦点 **回传落盘 handoff-to-coach.md**。
