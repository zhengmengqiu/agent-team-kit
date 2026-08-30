# AgentTeam 试跑操作指南（EV-06 · trial-validation）

> **用途**：验证 AgentTeam **规范是否好用**（Simple / Complex），不是把 feature 做到上线。  
> **原则**：`run_mode=trial-validation` → 教练 **P3-Q 后硬停**；问题写入 `agentteam-trial-log.md`，汇总后 META-F 反馈 maintainer。  
> **关联**：[coach-kickoff-template.md § 模板 AUDIT](./coach-kickoff-template.md#template-audit) · [maintainer-templates.md META-F](./maintainer-templates.md#meta-f)

---

## 1. 四窗模型（试跑必守）

| 窗口 | 角色 | 做什么 | 不做什么 |
|------|------|--------|----------|
| **教练窗** | `@agent-team-coach` | Gate、给执行提示词；**trial 时 Gate 后附带 AUDIT 提示词**；P3-Q 后停 | 写代码、改 spec、执行 AUDIT |
| **执行窗** | analyst / architect / developer | 按 Phase 交付产物 | 改 AgentTeam 规范 |
| **审计窗** | 通用 Agent + [模板 AUDIT](./coach-kickoff-template.md#template-audit) | 只 Read，追加 **trial-log** | 写代码、改 spec |
| **meta 窗** | `@agent-team-maintainer` | META-F → 改 evolution-checkpoint | 跑 feature P1～P7 |

**禁止**：试跑反馈只记在脑子里、关窗后回 meta 回忆。

---

## 2. 试跑终点（什么叫「试跑完成」）

| 轨道 | 必跑 Phase | 终点 |
|------|------------|------|
| **Simple** | Gate 0 → P1 → P2 → P3 **一批** → **P3-Q** | P3-Q 用户答复完成 |
| **Complex** | 同上 + P1 有 **11-P1**、P2 有 **11-P2** | 同上 |

**trial-validation 禁止**：P4 / P6 / P7 / commit（除非另开 `full-delivery` 新试跑）。

---

## 3. 开跑前准备

| # | 项 |
|---|-----|
| 1 | 已有 `docs/features/{feature}/input/prd.md`（或 P0 整理完成） |
| 2 | 教练窗侧栏命名：`{项目}-教练-{feature}` |
| 3 | 模板 A 含 **`【运行模式】trial-validation · 试跑终点 P3-Q`** |
| 4 | 教练 Gate 0 后应给 **P1 执行提示词**（trial 时不强制预给 AUDIT；**Gate 1-OQ 通过后**附 AUDIT-P1） |

---

<a id="trial-coach-audit"></a>

## 4.1 教练附带 AUDIT（EV-06 P1 · 不必手改模板）

**仅 `run_mode=trial-validation`**。每个 Phase **Gate 通过后**，在教练窗要下一步时，教练应输出两块（已填好路径）：

1. **【执行提示词】**（若有下一 Phase）
2. **【AUDIT-&lt;Phase&gt;】** 完整审计提示词 → 你**新开审计窗**粘贴即可

**full-delivery 正常开发不会出现 AUDIT 提示词。**

模板 B 试跑时可加一行：

```text
（若 run_mode=trial-validation：请附带【AUDIT-<刚完成 Phase>】完整审计提示词，已填路径）
```

---

## 4. 标准操作流程（Complex 示例 · admin-rbac-core）

### Step 0 — 开教练窗（一次）

**对话名**：`{项目名}-教练-admin-rbac-core`

粘贴 [coach-kickoff-template § 模板 A](./coach-kickoff-template.md#template-a) 并填写，**必须含**：

```text
【运行模式】trial-validation · 试跑 AgentTeam Complex 规范 · 终点 P3-Q（禁止 P4+）
```

其余字段见 maintainer 提供的 Complex 开教练提示词，或 `input/prd.md` 要点。

**教练应产出**：

- Gate 0 → `track: complex`
- 初始化 `session-checkpoint.md`（含 `run_mode` / `trial_stop`）
- P1：Write `kickoff.md` + 教练窗 C-人读（禁止贴 P1 长文）

---

### Step 1 — P1 执行 + AUDIT

| 步 | 动作 |
|----|------|
| 1 | **新开执行窗**，名：`admin-rbac-core-P1-需求-proposal编写` |
| 2 | 粘贴教练 P1 提示词 → 产出 `proposal.md` |
| 3 | Write `handoff-to-coach.md` → 教练窗「<对话名> 完成，读 handoff」→ Gate 1-OQ → 教练给 P2 提示词 + **【AUDIT-P1】** |
| 4 | **新开审计窗**，名：`admin-rbac-core-AUDIT-P1-规范审计` |
| 5 | 粘贴 **教练给的 AUDIT-P1 提示词**（非手改模板）→ 追加 `agentteam-trial-log.md` |

**P1 AUDIT 重点（complex）**：是否有 `## 容量画像`、`## 容量档位`。

---

### Step 2 — P2 执行 + AUDIT

| 步 | 动作 |
|----|------|
| 1 | 新开 `admin-rbac-core-P2-架构-design与tasks` → 产出 design/tasks/pending-todos |
| 2 | Write `handoff-to-coach.md` → 教练窗「读 handoff」→ Gate 2-OQ → 教练给 P3 提示词 + **【AUDIT-P2】** |
| 3 | 审计窗粘贴教练 AUDIT-P2 |

---

### Step 3 — P3 一批 + AUDIT

| 步 | 动作 |
|----|------|
| 1 | 新开 `admin-rbac-core-P3A-开发-MVP一批`（范围以 tasks MVP 为准） |
| 2 | 每批结束更新 `pending-todos.md`；Write `handoff-to-coach.md` → 教练窗「读 handoff」→ 教练给 **【AUDIT-P3A】** |
| 3 | 审计窗粘贴教练 AUDIT 提示词 |

试跑 **一批即可**，不必 P3B/P3C 全跑。

---

### Step 4 — P3-Q（试跑终点）

| 步 | 动作 |
|----|------|
| 1 | 教练窗：声明 P3 试跑批完成 → **Gate P3→P4** → 输出 **P3-Q 问卷** |
| 2 | **逐条答复**问卷 |
| 3 | 确认教练 **未给 P4**；应给 **【AUDIT-P3Q】** |
| 4 | 审计窗粘贴 AUDIT-P3Q |

---

### Step 5 — 汇总 META-F（meta 窗）

**对话名**：`agentteam-meta-试跑反馈-admin-rbac-core-P3Q`

1. Read `docs/features/admin-rbac-core/agentteam-trial-log.md`
2. 粘贴 [META-F](./maintainer-templates.md#meta-f)，问题清单从 trial-log 汇总
3. 无问题可写「无阻塞」
4. `@agent-team-maintainer` 更新 `evolution-checkpoint.md`

---

## 5. Simple 试跑对照（spring-ai-single-chat）

流程相同，差异：

| 项 | Simple |
|----|--------|
| track | simple |
| P1/P2 AUDIT | 无 11-P1/11-P2 强制项 |
| 终点 | 仍 P3-Q |

---

## 6. checkpoint 必含字段（trial 模式）

教练 Gate 0 后 `session-checkpoint.md` 应含：

```markdown
| run_mode | trial-validation |
| trial_stop | P3-Q |
```

`full-delivery` 需求：另开教练或改 checkpoint 后再要 P4。

---

## 7. 试跑 vs 正式交付

| 项 | trial-validation | full-delivery |
|----|------------------|---------------|
| 目的 | 验证 AgentTeam 规范 | 功能上线 |
| 终点 | P3-Q | P7 / PR |
| 教练 P4+ | **禁止** | 允许 |
| trial-log | **必须** | 可选 |
| META-F | 试跑结束 **建议** | 仅规范问题时 |

---

## 8. 常见问题

| 现象 | 处理 |
|------|------|
| 教练给了 P4 提示词 | 提醒 Read checkpoint `run_mode`；拒绝执行，回 coach 要求 trial 硬停 |
| 执行 Agent 一路写到底 | 正常惯性；靠 **trial_stop** + 你不新开 P4 执行窗 |
| 忘记 AUDIT | 教练窗：「请补发 AUDIT-&lt;Phase&gt; 完整提示词」；或补开 AUDIT 对话 |
| 想继续做完 feature | checkpoint 改 `full-delivery`，教练窗声明续接 P4 |

---

## 9. 试跑检查清单（勾选）

```
□ 教练窗 run_mode=trial-validation
□ session-checkpoint 含 track + run_mode + trial_stop
□ P1 AUDIT → trial-log 有 AUDIT-P1 节
□ P2 AUDIT → complex 时 11-P2 已检查
□ P3 至少一批 + pending-todos 更新
□ P3-Q 完成且教练未给 P4
□ META-F 已贴 meta 窗（或 maintainer 已更新 checkpoint）
```

---

## 修订记录

| 日期 | 说明 |
|------|------|
| 2026-08-24 | 「回传包贴教练窗」改为 Write `handoff-to-coach.md` → 教练窗「读 handoff」 |
| 2026-07-20 | EV-06 P1：教练 trial 模式 Gate 后附带 AUDIT 提示词（full-delivery 不出现） |
| 2026-07-20 | EV-06 P0：试跑四窗、trial-validation、AUDIT、trial-log、META-F 衔接 |
