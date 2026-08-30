# Agent 对话命名规范

> **适用范围**：所有使用 AgentTeam 工作流的 Project_pre 项目（及可参考本模板的其他 Cursor 项目）。  
> **目的**：新开 Agent 对话时，标题与提示词头一眼可辨 **阶段 · 角色 · 业务**，便于检索、回传教练、跨项目复用。

---

## 1. 命名格式（强制）

```
{feature}-{phase}-{role}-{task}
```

| 段 | 含义 | 规则 |
|----|------|------|
| **feature** | 功能短名 | kebab-case，≤20 字符；与 `docs/features/{feature}/` 一致或缩写（如 `demo-feature`） |
| **phase** | 阶段编号 | 见 §2 |
| **role** | 执行角色 | 见 §3，中文 2~4 字 |
| **task** | 本对话唯一任务 | 中文或英文短语，≤16 字符，动词开头为佳 |

**连接符**：段之间用 `-`（半角连字符），**不用空格**。  
**总长度**：建议整串 ≤ 40 字符（含连字符），过长则缩短 `task`。

### 示例

| 对话名 | 解读 |
|--------|------|
| `demo-feature-P1-需求-proposal编写` | demo-feature · Phase1 · 需求分析师 · 写 proposal |
| `demo-feature-P3A-开发-基础设施T1-T5` | demo-feature · Phase3 批次A · 开发 · T1-T5 |
| `demo-feature-P6-S4R-开发-10002修复` | demo-feature · Phase6 Step4R · 开发 · 修 10002 |
| `order-pay-P4-测试-AC冒烟` | 其他项目 · Phase4 测试 · AC 冒烟 |

---

## 2. 阶段编号（phase）

### 标准 Phase（0~7）

| 编号 | 含义 | 典型 Agent |
|------|------|------------|
| **P0** | 需求 input 整理 | `@requirement-input-prep` |
| **P1** | 需求分析 | `@requirements-analyst` |
| **P2** | 技术设计 | `@architect` |
| **P3** | 后端开发（可拆批） | `@backend-developer` |
| **P3A / P3B / P3C** | 开发分批 | `@backend-developer` |
| **P4** | 测试验证 | `@tester` |
| **P4A / P4B** | 审查前补测等 | `@tester` |
| **P6** | 代码审查 | `@code-reviewer` |
| **P7** | 提交 / PR（可选） | 用户 / `@backend-developer` |

### Phase 6 修复子步（S 前缀）

审查后修复、冒烟、联调可在 `P6` 下加 **Step**：

| 编号 | 含义 |
|------|------|
| **P6-S1** | 必须项修复（如 HIGH） |
| **P6-S2** | 建议项修复（如 MEDIUM） |
| **P6-S4** | 修复后冒烟 |
| **P6-S4R** | 冒烟失败回归修复 |
| **P6-S4p** | 复测（prime，区别于 S4R） |
| **P6-S5** | push 前 TOB/TOC 全接口联调 |

> 自定义 Step 用 `S` + 数字/字母，在功能 `test-report` 或教练对话中保持一致即可。

---

## 3. 角色（role）

与 AgentTeam 六角色对齐，提示词 `@` 谁，`role` 段就用谁：

| role 段 | @ Agent | 职责摘要 |
|---------|---------|----------|
| **整理** | `@requirement-input-prep` | 建 input/、场景识别、整理报告 |
| **需求** | `@requirements-analyst` | proposal、澄清需求 |
| **架构** | `@architect` | design、tasks |
| **开发** | `@backend-developer` | 代码、修复 |
| **测试** | `@tester` | 冒烟、联调、test-report |
| **审查** | `@code-reviewer` | 代码审查报告 |
| **教练** | `@agent-team-coach` | 流程、提示词（不写代码） |

---

## 4. 提示词标准头（每条 Agent 任务粘贴）

新开 Agent 对话时，**第一条消息**或对话标题使用下列结构：

```text
【对话名】{feature}-{phase}-{role}-{task}
【功能】{feature_full_name}
【阶段】{人类可读阶段说明}
【角色】@{agent_name}

（任务正文…）
```

### 示例

```text
【对话名】demo-feature-P6-S5-测试-TOB/TOC全接口联调
【功能】example-app-demo-feature
【阶段】Phase 6 Step 5 — push 前 Gate
【角色】@tester

@tester
…
```

---

## 5. 回传教练（执行 Agent 结束时必 Write 文件）

执行对话完成后，Agent **必须**向 `{workspace_docs}/docs/features/{feature}/handoff-to-coach.md` **追加** `## 回传 {对话名}`（模板 D）。禁止整文件覆盖其它回传节。聊天**只出模板 D-人读**。

任务正文在 `kickoff.md` 的 `## 派工 {对话名}`；新窗只贴 C-人读种子。

用户回教练窗：

```text
<对话名> 完成，读 handoff
```

不要拷执行窗正文。教练 **Read** 该文件后再给下一 Phase；无文件 = 本步未结束。

模板 D 字段骨架见 [coach-kickoff-template.md 模板 D](./coach-kickoff-template.md#template-d)；人读五行见 [模板 D-人读](./coach-kickoff-template.md#template-d-user)。

教练根据 **对话名 + 状态 + 开放问题表**（来自 handoff 文件）给出下一阶段提示词；**阻塞 P2 的 OQ 未决时不发 P2**。

---

## 6. Cursor 操作习惯

1. **新开 Agent 对话** → 在 Cursor 侧栏重命名对话为 `{对话名}`（与【对话名】一致）。
2. **一对话一任务**：Phase 3 多批、P6 多 Step 应 **分对话**，避免「一个窗口干全程」。
3. **教练对话独立**：`@agent-team-coach` 只 Read `handoff-to-coach.md`、发提示词，不跑测试、不改代码。
4. **模式**：写代码/跑测试/审查 → **Agent**；仅讨论方案 → Plan（可选）。

---

## 7. 跨项目复用

复制到新项目时：

| 项 | 做法 |
|----|------|
| `feature` | 换成该项目 `docs/features/{name}/` 短名 |
| `phase` / `role` | **不变**（AgentTeam 通用） |
| `task` | 按该功能 tasks.md 或教练提示填写 |
| 存放路径 | 建议 `docs/agent-team/agent-dialog-naming.md`（与本仓库相同） |
| 教练引用 | `.cursor/agents/agent-team-coach.md` 链到本文 |

其他技术栈（前端、Go 等）可增 role 段如 **前端**、**开发**，但保持 `{feature}-{phase}-{role}-{task}` 四段结构。

---

## 8. demo-feature 对话名速查（参考实例）

| 阶段 | 对话名 |
|------|--------|
| P0 | `{feature}-P0-整理-input材料` |
| P1 | `demo-feature-P1-需求-proposal编写` |
| P2 | `demo-feature-P2-架构-design与tasks` |
| P3A | `demo-feature-P3A-开发-基础设施T1-T5` |
| P3B | `demo-feature-P3B-开发-核心业务T6-T10` |
| P3C | `demo-feature-P3C-开发-收尾T11-T14` |
| P4 | `demo-feature-P4-测试-AC冒烟与报告` |
| P4A | `demo-feature-P4A-测试-demo-feature缺口补测` |
| P4B | `demo-feature-P4B-测试-D7分页回归` |
| P6 审查 | `demo-feature-P6-审查-代码审查报告` |
| P6-S1 | `demo-feature-P6-S1-开发-必须项H1-H2-H3` |
| P6-S2 | `demo-feature-P6-S2-开发-建议项M2-M5` |
| P6-S4 | `demo-feature-P6-S4-测试-修复后冒烟` |
| P6-S4R | `demo-feature-P6-S4R-开发-10002跨库修复` |
| P6-S4p | `demo-feature-P6-S4p-测试-B/E复测` |
| P6-S5 | `demo-feature-P6-S5-测试-TOB/TOC全接口联调` |
| P7 | `demo-feature-P7-开发-commit与PR` |

---

## 9. 修订记录

| 日期 | 说明 |
|------|------|
| 2026-08-24 | 执行必须 Write `handoff-to-coach.md`；聊天只出 D-人读；用户回教练「读 handoff」 |
| 2026-07-16 | 回传教练包增开放问题节；教练 Gate 1-OQ |
| 2026-07-14 | 初版：Phase/Step、四段命名、提示词头、回传教练包 |
