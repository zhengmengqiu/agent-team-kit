# AgentTeam 维护操作模板（Meta · META-A～F）

> **用途**：调教 AgentTeam 规范、分轨、playbook——**不是**跑某个 feature 的 P1～P7。  
> **Agent**：`@agent-team-maintainer`（长期可保留一个 **meta 对话**，与 feature 教练对话分开）  
> **存档**：每轮结束更新 [evolution-checkpoint.md](./evolution-checkpoint.md)（模板 META-E）

---

## 模板速查

| 模板 | 用途 |
|------|------|
| [META-A 续接](#meta-a) | 关窗口后继续优化 AgentTeam |
| [META-B 新分轨提案](#meta-b) | 新增或调整 Simple/Complex/第三轨 |
| [META-C 变更归类](#meta-c) | 新想法 → 共享层 or Complex-only |
| [META-D Gate 0 调教](#meta-d) | 改复杂度 checklist |
| [META-E 收尾](#meta-e) | 更新 evolution-checkpoint + 修订记录 |
| [META-F 试跑反馈](#meta-f) | Simple/Complex 试跑问题结构化反馈 |

**对话命名**：`agentteam-meta-{动作}-{主题}`，例：`agentteam-meta-续接-Gate0`

---

<a id="meta-a"></a>

## META-A：续接 AgentTeam 优化（关窗口后）

```text
【对话名】agentteam-meta-续接-<主题>
【角色】@agent-team-maintainer

@agent-team-maintainer

## 任务
从 evolution-checkpoint 续接，不改业务 feature。

请先 Read：
1. docs/agent-team/evolution-checkpoint.md
2. docs/agent-team/coach-playbook.md §8～§11

然后给我：
1. 当前进度与「进行中 / 已决」摘要
2. 建议的下一步（含要改的文件路径 + 章节）
3. 变更属于共享层还是 Complex-only
4. 若我确认，再执行具体修改

## 约束
- 禁止写 docs/features/{feature}/ 业务 spec
- 禁止替 @agent-team-coach 生成某个功能的 P3/P4 提示词
- 大改前先输出变更决议表，等我确认
```

---

<a id="meta-b"></a>

## META-B：新分轨 / 轨道调整提案

```text
【对话名】agentteam-meta-新分轨-<名称>
【角色】@agent-team-maintainer

@agent-team-maintainer

## 提案
【新轨名称】<如 integration / performance>
【触发场景】<什么需求应该走这条轨>
【与 simple/complex 关系】<complex 子集 / 独立第三轨 / 合并进 complex §11>
【希望多出来的 Gate/产物】<例：Gate 2.5、观测清单、分阶段 P3>

## 请输出
1. 是否值得独立轨（vs 扩展现有 complex §11）— 客观利弊
2. Gate 0 checklist 增补草案（条目 + 判据）
3. 共享层是否改动（应尽量少；列出若改则影响面）
4. 建议写入的文件清单（playbook §x、evolution-checkpoint、agent 提示词）
5. 【变更决议表】待我拍板

## 约束
Read evolution-checkpoint.md「已决」— 勿推翻已决项除非我显式要求
```

---

<a id="meta-c"></a>

## META-C：单次优化 · 变更归类

```text
【对话名】agentteam-meta-归类-<简短主题>
【角色】@agent-team-maintainer

@agent-team-maintainer

## 优化想法
<粘贴你的改进描述，如：P1 加容量默认 B 档、问卷加假设确认…>

## 请按维护规则三问
1. Simple 是否也需要？→ 共享层 / 否
2. 仅 Complex？→ §11 扩展 / 否
3. 是否改变 Gate 语义？→ 是则列出需同步的模板与 coach 话术

## 产出
【变更决议表】
| 项 | 归类 | 目标文件 | 改动要点 |
|----|------|----------|----------|

等我确认后再改文件。改完提醒 META-E 收尾。
```

---

<a id="meta-d"></a>

## META-D：Gate 0 复杂度 checklist 调教

```text
【对话名】agentteam-meta-Gate0-<主题>
【角色】@agent-team-maintainer

@agent-team-maintainer

## 目标
调整 Gate 0 判轨 checklist（simple vs complex）。

## 变更意图
- [ ] 新增条目：<描述>
- [ ] 删除/合并条目：<ID 或原文>
- [ ] 调整阈值：<原 ≥2 项 → 新 …>

请先 Read coach-playbook.md §9 与 evolution-checkpoint.md「轨道定义」。

## 产出
1. 修订后 checklist 全文（表格）
2. @agent-team-coach 需同步的一行话术（若有）
3. session-checkpoint 模板 J 是否加 `track` 字段 — 建议
4. 更新 evolution-checkpoint + playbook 修订记录

我确认后再写入文件。
```

---

<a id="meta-e"></a>

## META-E：一轮优化收尾

```text
【对话名】agentteam-meta-收尾-<YYYYMMDD>
【角色】@agent-team-maintainer

@agent-team-maintainer

## 刚完成
<本轮改了什么：文件列表 + 一句话摘要>

请更新 docs/agent-team/evolution-checkpoint.md：
- 最后更新日期
- 「进行中」勾选/新增
- 「已完成」追加
- 「变更 backlog」关闭或迁移
- 「当前焦点 / 下一动作 / 建议对话名」

并列出 playbook / README 修订记录建议行。

## 产出
1. evolution-checkpoint 更新片段（可直接覆盖对应章节）
2. 建议 git commit message（不自动 commit）
3. 若需回流业务项目 → 指向 sync-prompts 场景 2
```

---

<a id="meta-f"></a>

## META-F：试跑反馈（Simple / Complex 验证）

> **何时用**：完成某 Phase 或整条试跑链路后，向 `@agent-team-maintainer` 反馈规范问题。  
> **不要**在本模板里问「下一步 P3 提示词」— 那属于 `@agent-team-coach`。  
> **原则依据**：[evolution-checkpoint.md · AI 适用性原则](./evolution-checkpoint.md#complex-业务--ai-编程适用性原则--2026-07-17)

### 失败类型（必填 · 每条问题 1 个）

| 失败类型 | 含义 | maintainer 常改方向 |
|----------|------|---------------------|
| **规则** | L1/OQ 未确认，AI 猜错业务、AC、表结构、状态机 | analyst/coach、Gate 1-OQ/2-OQ、11-P1 |
| **上下文** | 对话过长、漏 Read design/checkpoint、前后矛盾 | 分批 P3、模板 C、session-checkpoint |
| **验证** | 做完无法证明业务正确；缺观测/冒烟映射 | §11、11-P2、tester、P4/P3-Q |
| **其他** | 工具/MCP/环境/非上述 | test-env、sync-prompts、个案 |

```text
【对话名】agentteam-meta-试跑反馈-<feature>-<Phase>
【角色】@agent-team-maintainer

@agent-team-maintainer

## 试跑上下文
【feature】<如 spring-ai-single-chat / admin-rbac-core>
【轨道】simple / complex
【run_mode】trial-validation
【trial-log】docs/features/<feature>/agentteam-trial-log.md（已 Read / 未建）
【刚完成 Phase】<如 P2 / P3 一批 / P3-Q>
【对话名（可选）】<执行对话侧栏名>

## 结果摘要
【Gate】<Gate 0 / Gate 1-OQ / P3-Q 等 · 通过/卡点>
【产出路径】<proposal/design/pending-todos 等路径>

## 问题清单（逐条填；无问题写一行「无阻塞」）

| # | 阶段 | 失败类型 | 类型 | 现象 | 期望 | 相关文件/模板 |
|---|------|----------|------|------|------|---------------|
| 1 | P2 | 验证 | 模板 | design 无「核心观测清单」 | 应 Read 11-P2 填表 | coach-kickoff-template |
| 2 | P3→P4 | 规则 | Gate | 教练未 Read pending-todos 直接给 P4 | 先 Read 再 P3-Q | agent-team-coach |
| 3 | P3B | 上下文 | Agent | 与 P3A 接口契约不一致 | 每批 Read design API 节 | backend-developer |

- **失败类型**：规则 / 上下文 / 验证 / 其他（见上表）
- **类型**（细类）：Gate / 模板 / Agent / OQ / pending-todos / 分轨 / MCP / 其他

## 证据（尽量贴）
- **优先**：`agentteam-trial-log.md` 中 ❌ 行（AUDIT 产出）
- 教练或执行 Agent 的**原文片段**（10～30 行）
- 或产出 md **章节标题** + 缺什么
- 或 checkpoint / pending-todos 相关段落

## 请 maintainer
1. 按失败类型统计倾向（规则/上下文/验证各几条）
2. 归类：共享层 vs Complex-only
3. 是否需改文件（路径 + 章节）→ 变更决议表
4. 是否写入 evolution-checkpoint / backlog（EV-xx）
5. **等我确认再改**（若改动 >1 文件）
```

**反馈质量提示**：

| 好反馈 | 差反馈 |
|--------|--------|
| 「失败类型=验证，P2 无核心观测清单，track=complex」 | 「Complex 不太行」 |
| 「失败类型=规则，OQ-03 未确认就写了权限表」 | 「AI 猜错了」 |
| 「失败类型=上下文，P3C 未 Read design §API」 | 「前后不一致」 |

---

## 与 feature 教练对话对照

| 目的 | 用谁 | 存档 |
|------|------|------|
| 做 hk-xxx 功能 P1～P7 | `@agent-team-coach` | `docs/features/{feature}/session-checkpoint.md` |
| 改 AgentTeam 规范 / 分轨 | `@agent-team-maintainer` | `docs/agent-team/evolution-checkpoint.md` |

---

## 修订记录

| 日期 | 说明 |
|------|------|
| 2026-07-20 | META-F 增 trial-log 来源；链 trial-run-guide |
| 2026-07-17 | META-F 增失败类型列（规则/上下文/验证） |
| 2026-07-17 | 增 META-F 试跑反馈模板 |
| 2026-07-17 | 初版 META-A～E；配合 agent-team-maintainer |
