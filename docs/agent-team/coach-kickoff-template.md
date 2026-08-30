# AgentTeam 教练对话 — 可复制模板

> **逐步操作 SOP**：见 [coach-playbook.md](./coach-playbook.md)（先看 Playbook，再复制本文件模板）。  
> 用法：新开 **教练对话** `@agent-team-coach` 或 **执行对话** 时，复制对应块粘贴即可。  
> 命名规范见 [agent-dialog-naming.md](./agent-dialog-naming.md)。

## 模板速查（点击跳转）

| 模板 | 用途 |
|------|------|
| [A 开场](#template-a) | 教练对话首条 |
| [B 续接](#template-b) | 教练窗收口：读 handoff，不要拷执行窗 |
| [C 执行头](#template-c) | 每条执行提示词顶部 |
| [D 回传包](#template-d) | 写入 `handoff-to-coach.md`（勿贴进聊天） |
| [D-人读](#template-d-user) | 执行窗结束短报 |
| [E 定制约定](#template-e) | 权限、**交付边界**等自控项 |
| [F Phase1](#template-f) | proposal 执行 |
| [OQ 开放问题](#template-oq) | P1/P2/P3 开放问题块（教练粘贴） |
| [G Phase4](#template-g) | AC 冒烟 |
| [H 全接口联调](#template-h) | push 前 TOB/TOC |
| [I commit/PR](#template-i) | 向教练要 P7 |
| [J checkpoint](#template-j) | 更新 session-checkpoint |
| [K 恢复](#template-k) | 对话删了从 checkpoint 恢复 |
| [L 归档](#template-l) | handoff archive |
| [P0 需求整理](#template-p0) | Agent 建目录 + 场景推荐 |
| [P3-Q 待办确认问卷](#template-p3-q) | Gate P3→P4：教练 Read 待办并结构化提问 |
| [11-P1 Complex P1](#template-11-p1) | proposal 容量画像 + 容量档位（`track=complex`） |
| [11-P2 Complex P2](#template-11-p2) | design 场景推导 + 核心观测清单（`track=complex`） |
| [AUDIT 试跑审计](#template-audit) | trial-validation：只 Read，写 agentteam-trial-log |
| [trial-log 骨架](#template-trial-log) | 试跑问题记录文件头 |
| 需求输入 SOP | [requirement-input-guide.md](./requirement-input-guide.md)（MD/图/HTML/Figma/变更） |

---

<a id="template-p0"></a>

## 模板 P0：Phase 0 需求材料整理（`@requirement-input-prep`）

> **何时用**：收到飞书 MD / HTML / Figma 导出 / Word，**尚未**建 `input/` 目录。  
> **模式**：Agent · **新开对话** · 在 P1 / 教练之前。

```text
【对话名】{feature}-P0-整理-input材料
【功能】{feature_name}
【短名】{feature}
【阶段】Phase 0 — 需求 input 整理（建目录 + 场景识别）
【角色】@requirement-input-prep

@requirement-input-prep

## 目标
根据我提供的原始需求材料：
1. 创建 docs/features/{feature}/input/ 标准目录
2. 识别场景（A~F 或混合），给出推荐整理方案
3. 搬运/复制文件、生成 prd.md / guide 骨架
4. 输出【整理报告】（模板 P0-D），标明能否开教练/P1

## 原始材料（@ 文件或写绝对路径）
- 飞书导出 MD：<路径，如 D:\Downloads\xxx.md>
- [若有] Word：<路径>
- [若有] HTML 原型：<文件夹或文件路径>
- [若有] Figma 导出 PNG：<文件夹路径>
- [若有] 口头变更说明：<粘贴>

## 约束
- Read：docs/agent-team/requirement-input-guide.md
- **禁止**写 proposal.md / design.md / 业务代码
- 飞书 larksuite 内链：**先**跑 `docs/agent-team/scripts/download-md-images.ps1` 自动下载；失败项再 Word/docx 兜底
- docx 若提供：尝试解压 word/media/ 提取图片
- 不确定的业务规则：prd 中写 [待产品确认]，勿猜测

## 完成后必须输出【整理报告】（模板 P0-D）
```

<a id="template-p0-d"></a>

### 模板 P0-D：【整理报告】（Phase 0 结束时必须输出）

```markdown
## 【整理报告】

### 对话名
{feature}-P0-整理-input材料

### 场景判定
A / B / C / D / E / F / 混合（如 B+C+D）

### 推荐方案摘要
- …

### 已创建/已移动的文件
- docs/features/{feature}/input/…

### 图片下载（若有 MD 内链）
- 成功：N 张 → input/images/
- 失败：M 张 → 见 image-url-map.json
- 映射：input/images/image-url-map.json

### 用户手动清单（未完成则不可开 P1）
- [ ] …

### 就绪度
- 可开教练：是 / 否
- 可开 P1：是 / 否（否则说明缺什么）

### 建议下一步
1. 完成手动清单
2. 开教练对话，粘贴整理报告 + input 路径
3. 对话名：{feature}-P1-需求-proposal编写

### 给教练的一句话
≤30 字
```

**用户动作**：完成手动清单 → 开 `@agent-team-coach`（模板 A，附上本报告）→ 再开 P1。

---

<a id="template-a"></a>

## 模板 A：教练对话「开场」（整个需求只发一次）

```text
@agent-team-coach

这是 AgentTeam 教练对话。只指导流程和提示词，不写代码、不产出 spec。
执行在别的对话用 @requirements-analyst 等完成。

【项目】<项目名，如 project_pre-customer-info>
【功能】<feature_name，如 example-app-demo-feature>
【短名】<feature 缩写，如 demo-feature>
【性质】新功能 / 迁移后拓展 / bugfix
【当前】从 Phase <1~6> 开始（或续接 Phase <X>）
【已有产出】<无 / proposal 已有 / design 已有，附路径>

【需求要点】
1. <要点一>
2. <要点二>
3. <要点三>

【复杂度（可选）】小需求 / 不确定（请 Gate 0 checklist 判 simple|complex）

【运行模式（可选）】
- full-delivery（默认）：正常 P1～P7
- trial-validation：试跑 AgentTeam 规范 · 终点 P3-Q · 教练禁止给 P4/P6/P7（见 trial-run-guide.md）

请给我：
0. Gate 0 判轨 + 写入 session-checkpoint 的 track、run_mode、trial_stop 字段
1. 当前 Phase 判断
2. 是否新开执行对话
3. 带【对话名】的完整执行提示词（含 Write `handoff-to-coach.md` 要求）
```

---

<a id="template-b"></a>

## 模板 B：教练对话「续接 / 要下一步」

```text
@agent-team-coach

【功能】<feature_name>
【短名】<feature>
【刚完成】<对话名，如 demo-feature-P6-S4p-测试-B/E复测>
【状态】✅ / ⚠️ / ❌

请 Read `{workspace_docs}/docs/features/<feature>/handoff-to-coach.md`（无文件 = 本步未结束，不要给下一 Phase）。
不要等我粘贴执行窗正文或模板 D 全文。

请给下一步：是否新开对话、带【对话名】的完整执行提示词。
（可选）若 session-checkpoint 为 trial-validation：请附带【AUDIT-<刚完成 Phase>】完整审计提示词（已填 feature 路径；你不要执行审计）。
```

更短块（推荐日常用）：

```text
@agent-team-coach
【功能】<feature_name>
<对话名> 完成，读 handoff
```

---

<a id="template-c"></a>

## 模板 C：执行对话「标准头」（每条任务最上方）

```text
【对话名】<feature>-<phase>-<role>-<task>
【功能】<feature_name>
【阶段】<人类可读，如 Phase 6 Step 5 — push 前 Gate>
【角色】@<agent_name>

@<agent_name>

<任务正文…>

---
## 约束（按需删改）
- 先 Read：docs/features/<feature>/design.md、tasks.md
- 本对话仅做：<本步范围>
- 完成后：**Write** `{workspace_docs}/docs/features/<feature>/handoff-to-coach.md`（模板 D，覆盖写）；聊天只出 **模板 D-人读**；禁止把 D 全文贴进对话
- 提醒用户回教练窗：「<对话名> 完成，读 handoff」（不要拷执行窗正文）
```

### 常用对话名示例（替换 `<feature>`）

| 阶段 | 【对话名】 |
|------|------------|
| Phase 1 | `<feature>-P1-需求-proposal编写` |
| Phase 2 | `<feature>-P2-架构-design与tasks` |
| Phase 3 批 A | `<feature>-P3A-开发-基础设施T1-T5` |
| Phase 4 | `<feature>-P4-测试-AC冒烟与报告` |
| Phase 6 审查 | `<feature>-P6-审查-代码审查报告` |
| 修复必须项 | `<feature>-P6-S1-开发-必须项修复` |
| push 前联调 | `<feature>-P6-S5-测试-TOB/TOC全接口联调` |
| commit/PR | `<feature>-P7-开发-commit与PR` |

---

<a id="template-d"></a>

## 模板 D：【回传教练包】（写入文件 · 禁止只写在对话）

> **落盘强制**：`{workspace_docs}/docs/features/<feature_name>/handoff-to-coach.md`（覆盖写；本仓 `{workspace_docs}` = 仓库根）。  
> **聊天不要贴 D 全文**，改用 [模板 D-人读](#template-d-user)。  
> **旧式粘贴仅兼容**：用户若仍把本模板贴进教练窗，教练可接受；执行 Agent 不得以此代替写文件。

```markdown
## 【回传教练包】

### 对话名
<feature>-<phase>-<role>-<task>

### 步骤
<一步摘要，如 Step 4' — B/E 复测>

### 状态
✅ 完成 / ⚠️ 部分完成 / ❌ 阻塞

### 开放问题（P1/P2 必填；P3+ 有变更时填）
| OQ | 问题 | 级别 | 阻塞 | 状态 | 决议 |
|----|------|------|------|------|------|
| OQ-01 | … | L1/L2 | P2 | 已确认/仍开放 | … |

**L1 仍开放数**：0 → P3 批次可继续 / 可进 P4  
**待办开放数**：见 `pending-todos.md`（P3 每批须同步更新）

### 待办清单变更（P3+ 必填）
| ID | 类型 | 本步变更 | 临时方案 |
|----|------|----------|----------|
| TD-01 | 依赖 | 新增 | mock Redis |

**pending-todos.md 路径**：docs/features/{feature}/pending-todos.md

### 改动文件（开发类必填）
- <path/to/File.java>
- …

### 验证结果（测试类必填）
- 单测：<命令> → <PASS/FAIL 数>
- 冒烟/API：<Pass/Fail 列表>
- MCP/DB：<关键证据>

### 审查项 / 用例对照（按需）
| 编号 | 结果 | 备注 |
|------|------|------|
| | | |

### 风险/遗留
- …
- 待办开放：N 项（见 pending-todos.md）

### 建议下一步
<feature>-<下一 phase>-<role>-<task>

### 给教练的一句话
<≤30 字>
```

---

<a id="template-d-user"></a>

## 本步结果（人读）

> 执行窗结束时**只输出本五行**；完整模板 D 已 Write 到 `handoff-to-coach.md`。

```markdown
## 本步结果（人读）

1. **结果**：✅ / ⚠️ / ❌ · 【对话名】· <一句做了什么>
2. **你现在**：回教练窗发送「<对话名> 完成，读 handoff」（不要拷本窗正文）
3. **改动**：<文件数或 3～7 个关键路径>
4. **验证**：<测过什么 → 过/没过；未跑写「未跑」>
5. **要你拍板**：<最多 3 条；没有写「无」>

handoff：`{workspace_docs}/docs/features/<feature>/handoff-to-coach.md`
```

---

<a id="template-e"></a>

## 模板 E：教练对话「定制约束」

执行前若有个别项要自己控制，在教练对话说明一次，后续提示词会省略。  
**新功能默认**须含「交付边界」块（见 [delivery-boundary.md](./delivery-boundary.md)），并写入 checkpoint「定制约定」。

```text
@agent-team-coach

【功能】<feature_name>
【补充约定】
- **交付边界（默认）**：本 AgentTeam 仅交付 code_root 的后端 REST API；不交付前端页面与 UI E2E
- P1 AC 分层：[Must] API 可验证 / [UI-Ref] 待前端联调 / [Out-of-Scope] 非本团队
- P4：UI-Ref 标 Blocked-待前端联调，不算 Fail；Push Gate 以 Must 级 AC 为准
- 接口权限 / @AccessRequire：我自己控制，后续提示词忽略权限校验
- 测试环境：已配置 test-env.override.md + project_pre-dev-api-auth
- 其他：<…>

请按此约定更新后续 Step 提示词，并在 session-checkpoint「定制约定」中保留上述条目。
```

---

<a id="template-f"></a>

## 模板 F：Phase 1 执行提示词（教练生成时可对照）

```text
【对话名】<feature>-P1-需求-proposal编写
【功能】<feature_name>
【阶段】Phase 1
【角色】@requirements-analyst

@requirements-analyst

功能名：<feature_name>
产出：docs/features/<feature_name>/proposal.md

## 需求要点
<paste>

## 任务
1. Read `docs/agent-team/delivery-boundary.md`
2. 搜索现有实现，写迁移 baseline（若有）
3. in/out scope + **`## 交付边界`** + Given/When/Then 验收标准（每条标 [Must]/[UI-Ref]/[Out-of-Scope]）
4. **开放问题（见模板 OQ · P1 段）** — 优先于细化 AC
5. 遵循 spec-author，Gate 1 自检（有阻塞 P2 的仍开放 OQ → ⚠️ 或 ❌，禁止 silent ✅）
6. 先不要写代码

完成后：**Write** `{workspace_docs}/docs/features/<feature_name>/handoff-to-coach.md`（模板 D，含开放问题全文表，覆盖写）；聊天只出 **模板 D-人读**；禁止把 D 全文贴进对话。
提醒用户回教练窗：「<对话名> 完成，读 handoff」。
```

---

<a id="template-oq"></a>

## 模板 OQ：开放问题（P1 / P2 粘贴块）

### P1 段 — 粘贴到 `@requirements-analyst` 提示词

```text
## 开放问题（P1 强制，优先于写 AC）

1. 读 prd「待产品确认」+ 图稿与文字冲突 → 合并为 OQ-01… 表写入 proposal
2. 表列：ID | 问题 | 选项 | 影响 AC | 阻塞(P2/P3/P4/上线) | 默认推荐 | 状态 | 决议
3. **阻塞 P2** 的 OQ：完成 proposal 前必须用 AskQuestion 问我确认
4. 我确认后更新「状态=已确认」和「决议」列；AC 只引用 OQ-0N
5. Gate 1：无阻塞 P2 的仍开放 → ✅；有 → ⚠️（仅不阻塞 P2 时）或 ❌
6. Write `handoff-to-coach.md` 附开放问题**全文表**，禁止只报个数
```

### P2 段 — 粘贴到 `@architect` 提示词

```text
## 开放问题继承（P2 强制）

1. Read proposal「## 交付边界」与 `docs/agent-team/delivery-boundary.md`
2. Read proposal「## 开放问题」表
3. design.md 增「## 开放问题决议」：OQ | 状态 | 决议 | design 落点
4. API 表含列：消费者（admin-fe/app/h5/internal）、前端依赖（是/否）
5. tasks 仅覆盖 [Must] 后端项；[UI-Ref]/[Out-of-Scope] 不生成开发 task
6. 仍开放项：设计分支 + 默认推荐；tasks 标 [OQ-0N]
7. 阻塞 P3 的 OQ：AskQuestion 或等我显式接受默认分支
8. Gate 2：无阻塞 P3 的仍开放 → ✅；否则 ⚠️
9. Write `handoff-to-coach.md` 附 OQ 决议摘要
```

### proposal 内 OQ 表骨架（analyst 写入 md）

```markdown
## 交付边界

| 模块 | 本 AgentTeam | 负责方 |
|------|--------------|--------|
| Admin API | ✅ | backend |
| C 端 API | ✅ | backend |
| 前端页面 / UI E2E | ❌ | [待确认] |

## 开放问题（待产品确认）

| ID | 问题 | 选项 | 影响 AC | 阻塞 | 默认推荐 | 状态 | 决议 |
|----|------|------|---------|------|----------|------|------|
| OQ-01 | … | A … / B … | AC-E02 | P2 | A | 仍开放 | |
```

### P3 段 — 粘贴到 `@backend-developer` 提示词

```text
## 开放问题与待办（P3 执行态 · 方法 B）

Read：docs/features/{feature}/pending-todos.md（若无则本对话创建）

### 分级处理
| 级别 | 行为 |
|------|------|
| **L1 方案级** | AskQuestion 即时确认；未确认 → ❌ 阻塞当前 task |
| **L2 依赖级** | 按 design 默认分支实现；写入 pending-todos.md（类型=L2确认） |
| **L3 实现级** | 按项目规范，不建 OQ |
| **依赖不全** | 写入 pending-todos.md（类型=依赖/联调）；写临时方案 + 补全计划；**不阻塞下一批** |

### 待办清单（持续补全，强制）
1. 每批结束：更新 pending-todos.md（新增 / 改状态 / 填决议）
2. Write `handoff-to-coach.md` 附「待办清单变更」节（模板 D）
3. L2 项 **不在批次间** AskQuestion；整段 P3 结束后用户统一确认（Gate P3→P4）
4. 禁止只口头列待办而不落盘

### pending-todos.md 表列
ID | 类型(L2确认/依赖/联调/L1阻塞) | 描述 | 来源Phase | 临时/默认方案 | 补全/验证项 | 状态(开放/进行中/已解决/延后) | 确认决议 | 更新日
```

### pending-todos.md 骨架（P2 后或首条 P3 创建）

```markdown
# 待办清单: {feature_name}

> 持续补全；P3 每批更新；L2/依赖项在 **P3 全部完成后、进 P4 前** 统一确认。

| ID | 类型 | 描述 | 来源 | 临时/默认方案 | 补全/验证项 | 状态 | 确认决议 | 更新日 |
|----|------|------|------|---------------|-------------|------|----------|--------|
| TD-01 | 依赖 | 示例：Redis 未 provision | P3A | 本地 mock | 联调环境就绪后跑缓存用例 | 开放 | | YYYY-MM-DD |
```

---

<a id="template-g"></a>

## 模板 G：Phase 4 测试执行头（@tester）

```text
【对话名】<feature>-P4-测试-AC冒烟与报告
【功能】<feature_name>
【阶段】Phase 4
【角色】@tester

@tester

## 环境
- Read project_pre-dev-api-auth + docs/agent-team/test-env.override.md
- B 端 access_token；C 端 Bearer + lang

## 产出
docs/features/<feature_name>/test-report-<YYYYMMDD>.md

## AC
对照 proposal.md AC 逐条验证；Read `docs/agent-team/delivery-boundary.md`
- `[Must]`：API 冒烟 + 落库，Pass/Fail
- `[UI-Ref]`：Blocked-待前端联调（不算 Fail）
- **pending-todos 开放（L2/依赖）**：Pending-待确认（不算 Fail）
- `[Out-of-Scope]`：Skip

完成后：**Write** `{workspace_docs}/docs/features/<feature_name>/handoff-to-coach.md`（模板 D，覆盖写）；聊天只出 **模板 D-人读**；禁止把 D 全文贴进对话。
提醒用户回教练窗：「<对话名> 完成，读 handoff」。
```

---

<a id="template-h"></a>

## 模板 H：push 前全接口联调（@tester）

```text
【对话名】<feature>-P6-S5-测试-TOB/TOC全接口联调
【功能】<feature_name>
【阶段】Phase 6 Step 5 — push 前 Gate
【角色】@tester

@tester

## TOC（C 端）
- GetStatus / Apply / Cancel + AD-12 等

## TOB（Admin）
- applyManual / page / downloadExcel / applyAudit / cancelAudit / update / batchUpdate

## 产出
test-report 追加 § Step 5；Push Gate：READY / NOT READY

完成后：**Write** `{workspace_docs}/docs/features/<feature_name>/handoff-to-coach.md`（模板 D，覆盖写）；聊天只出 **模板 D-人读**；禁止把 D 全文贴进对话。
提醒用户回教练窗：「<对话名> 完成，读 handoff」。
```

---

<a id="template-i"></a>

## 模板 I：commit / PR 前（教练要提示词时）

```text
@agent-team-coach

【功能】<feature_name>
【刚完成】<feature>-P6-S5-测试-TOB/TOC全接口联调
【Push Gate】READY

请给 P7 commit + PR 提示词（含【对话名】），我不自动 push 除非你写明。
```

---

## 快速流程卡片

```
1. 模板 A  → 开教练对话（长期保留）
2. 教练给  → 模板 C + 任务正文
3. 执行完  → Write `handoff-to-coach.md`（模板 D）+ 窗口只出 D-人读
4. 教练窗   → 「<对话名> 完成，读 handoff」（模板 B；不拷执行窗）
5. Gate 你确认 → 再下一阶段
6. 模板 I  → push 前
7. 模板 J  → 更新 session-checkpoint（防对话误删）
8. 模板 K  → 从 checkpoint 恢复教练对话
9. 功能交付 → 写 archive/handoff（Case 2，见 session-persistence.md）
```

---

<a id="template-j"></a>

## 模板 J：session-checkpoint 更新

> 路径：`docs/features/<feature_name>/session-checkpoint.md`  
> 详见 [session-persistence.md](./session-persistence.md) Case 1。

每完成一步 Gate 或 Write `handoff-to-coach.md` 后更新：

```markdown
# Session Checkpoint: <feature_name>

> 最后更新：YYYY-MM-DD  
> 状态：进行中 | **已归档 → archive/handoff-YYYYMMDD.md**

## 当前状态
| 功能短名 | <feature> |
| 复杂度轨道 | simple（默认） / complex |
| 运行模式 | full-delivery（默认） / **trial-validation** |
| 试跑终点 | trial_stop: P3-Q（仅 trial-validation） |
| 当前 Phase | <如 P3A> |
| 下一对话名 | <feature>-P3A-开发-…> |
| Gate | <…> |

## 已完成（勿重跑）
- [x] …

## 最后一包回传
- 对话名 / 状态 / 一句话

## 风险/遗留
- …
- **待办开放**：N 项 → `pending-todos.md`

## 定制约定

- **交付边界（默认）**：server-only — 仅 Admin/C 端 API + 落库；UI E2E 不在 P4 范围（见 delivery-boundary.md）
- …（功能级例外在此追加）

## 关键文档
- docs/features/<feature>/handoff-to-coach.md
- docs/features/<feature>/session-checkpoint.md
- docs/features/<feature>/pending-todos.md
- docs/features/<feature>/agentteam-trial-log.md（trial-validation 时）
- …
```

---

<a id="template-trial-log"></a>

## 模板 trial-log：试跑问题记录（文件头）

> 路径：`docs/features/<feature_name>/agentteam-trial-log.md`  
> **trial-validation** 时由 [模板 AUDIT](#template-audit) 追加各 Phase 节。

```markdown
# AgentTeam Trial Log: <feature_name>

> run_mode: trial-validation · trial_stop: P3-Q  
> 轨道：simple | complex · 开始：YYYY-MM-DD

## 汇总（P3-Q 后填）

| 失败类型 | 条数 |
|----------|------|
| 规则 | 0 |
| 上下文 | 0 |
| 验证 | 0 |
| 其他 | 0 |

**试跑结论**：通过 / 有待改进（→ META-F）

---

（以下由 AUDIT 各 Phase 追加 AUDIT-P1、AUDIT-P2… 节）
```

---

<a id="template-audit"></a>

## 模板 AUDIT：试跑规范审计（只读 · 不写代码）

> **何时用**：`run_mode=trial-validation`；每个 Phase Gate 通过后 **新开审计对话**。  
> **模式**：Agent · **禁止**改 spec/代码 · 只追加 `agentteam-trial-log.md`。  
> SOP：[trial-run-guide.md](./trial-run-guide.md)  
> **教练生成（EV-06 P1）**：`run_mode=trial-validation` 时，Gate 通过后由 `@agent-team-coach` 输出**已填路径**的完整 AUDIT 块；用户新开审计窗粘贴。**full-delivery 不出现。**

```text
【对话名】<feature>-AUDIT-<Phase>-规范审计
【功能】<feature_name>
【阶段】AUDIT · 试跑规范检查 · <P1|P2|P3A|P3-Q>
【角色】通用 Agent（只读审计，非 coach/maintainer）

## 任务
1. Read docs/features/<feature_name>/session-checkpoint.md（确认 run_mode=trial-validation）
2. Read 本 Phase 产出（见下）+ docs/agent-team/coach-playbook.md（complex 时 §11）
3. 若 agentteam-trial-log.md 不存在 → 用 coach-kickoff-template § trial-log 骨架创建
4. **追加一节** `## AUDIT-<Phase> · YYYY-MM-DD`（表格：检查项 | 结果 ✅/❌ | 失败类型 | 证据）
5. **不要**写代码、不要改 proposal/design/tasks

### 本 Phase 产出路径
<P1: proposal.md / P2: design+tasks+pending-todos / P3: pending-todos / P3-Q: 教练 P3-Q 行为>

## 检查清单

**共享**：checkpoint 含 track/run_mode/trial_stop · OQ/handoff · pending-todos（P2 后）  
**Complex**：P1 容量两节 · P2 场景+观测两节  
**P3-Q**：教练 Read 待办 · **未给 P4 提示词**

## 输出
- 已追加 trial-log 的路径
- 本节 ❌ 项摘要（供 META-F 复制）
```

---

<a id="template-k"></a>

## 模板 K：从 checkpoint 恢复（教练对话）

```text
@agent-team-coach

从 checkpoint 恢复，不写代码。

【项目】<项目名，如 project_pre-operations / project_pre-customer-info>
【功能】<feature_name>

请先 Read：docs/features/<feature_name>/session-checkpoint.md

根据 checkpoint 给：当前步骤、下一【对话名】+ 完整提示词、是否更新 checkpoint。
```

---

<a id="template-p3-q"></a>

## 模板 P3-Q：Gate P3→P4 待办确认问卷（教练输出 · L0）

> **何时用**：整段 P3（末批）回传后，用户要进 P4；教练 **Read** `docs/features/{feature}/pending-todos.md` 后输出。  
> **谁产出**：`@agent-team-coach`（不是执行 Agent）。  
> **未收到用户逐条答复前**：不给 P4 提示词。

### 教练生成问卷（结构固定）

```markdown
## 【待办确认问卷】Gate P3→P4

**功能**：{feature_name}  
**来源**：docs/features/{feature}/pending-todos.md（已 Read · YYYY-MM-DD）

### 前置检查
| 检查项 | 结果 |
|--------|------|
| L1阻塞 · 状态=开放 | **0** ✅ 可继续 / **N** ❌ 不进 P4 |
| L2确认 · 开放 | n 条 |
| 依赖 · 开放 | n 条 |
| 联调 · 开放 | n 条 |

---

### 一、L2确认（请逐条答复）

| ID | 问题 | 已实现默认方案 | 请选择 |
|----|------|----------------|--------|
| TD-02 | 缓存 TTL 取多少？ | 24h（design §3.2） | 接受默认 / 改为：___ / 延后 |

---

### 二、依赖（请逐条答复）

| ID | 缺什么 | 临时方案 | 补全后验证 | 请选择 |
|----|--------|----------|------------|--------|
| TD-01 | Redis 未 provision | 本地 mock | 联调环境就绪后跑缓存用例 | 接受默认 / 改为：___ / 延后 |

---

### 三、联调（请逐条答复）

| ID | 项 | 当前状态 | 请选择 |
|----|-----|----------|--------|
| TD-03 | Admin 列表字段对齐 | 后端已就绪，前端未联调 | 接受默认 / 改为：___ / 延后 |

---

### 答复格式（请复制填空）

```text
TD-01: 接受默认
TD-02: 改为 12h
TD-03: 延后
```

确认后我将给出 **决议汇总** 与 **P4 提示词**。请同步更新 pending-todos.md 的「确认决议」「状态」列。
```

### 开放项 = 0 时（教练简版）

```markdown
## 【待办确认问卷】Gate P3→P4

pending-todos.md 无开放项（或文件不存在且 P3 未登记待办）。  
**L1阻塞 = 0** ✅ → 可直接进 P4。
```

### 用户答复后 · 教练决议汇总（再发 P4 前）

```markdown
## 【待办决议汇总】

| ID | 你的答复 | 写入 pending-todos |
|----|----------|-------------------|
| TD-01 | 接受默认 | 状态=已解决；决议=维持 mock 至联调 |
| TD-02 | 改为 12h | 状态=已解决；决议=TTL=12h（需 P3 补丁或记 handoff） |
| TD-03 | 延后 | 状态=延后；P4 相关 AC → Pending-待确认 |

请更新 pending-todos.md + checkpoint，然后执行 P4。
```

---

<a id="template-11-p1"></a>

## 模板 11-P1：Complex Track · P1 容量章节（`track=complex`）

> **何时用**：checkpoint `track=complex`；粘贴到 `@requirements-analyst` 提示词（教练生成 P1 时追加）。Simple 轨 **跳过**。

```text
## Complex Track · P1 追加（Read playbook §11 + 本模板）

proposal.md 须追加以下两节（Gate 1 自检项）：

### ## 容量画像

| 维度 | 已知 | 假设 | 待验证 |
|------|------|------|--------|
| 峰值 QPS / 并发 | | 默认 B 档：≤50 QPS | |
| 核心实体数据量（如用户/订单） | | | |
| 一致性要求（最终一致/强一致） | | | |
| 读写的 P95 延迟目标 | | API ≤500ms | |

### ## 容量档位

- **当前档位**：B 档（默认）
- **B 档假设摘要**：<1 句>
- **升档触发条件**（满足任一考虑升 C 档）：
  1. <量化条件，如 P95>500ms 持续 1 周>
  2. <量化条件，如 注册用户>10 万>
- **升档动作摘要**：<如加缓存/读写分离/异步化 — 仅写方向，细节在 P2>
```

---

<a id="template-11-p2"></a>

## 模板 11-P2：Complex Track · P2 场景与观测（`track=complex`）

> **何时用**：checkpoint `track=complex`；粘贴到 `@architect` 提示词（教练生成 P2 时追加）。Simple 轨 **跳过**。

```text
## Complex Track · P2 追加（Read playbook §11 + 本模板）

design.md 须追加以下两节（P2 Gate 自检 · 缺则 ❌）：

### ## 场景与负载推导

| 场景 ID | 名称 | 触发条件 | 负载假设（QPS/数据量） | 推导结论（架构/限流/缓存） |
|---------|------|----------|------------------------|---------------------------|
| SC-01 | 常态运维 | 工作日白天 | B 档 | |
| SC-02 | 峰值 | <活动/批量导入> | | |
| SC-03 | 异常 | 依赖超时/DB 慢 | | |

### ## 核心观测清单

| OBS ID | 指标 | 采集点（日志/Metrics） | 告警阈值 | P4 验证方式 |
|--------|------|------------------------|----------|-------------|
| OBS-01 | API P95 延迟 | access log / Micrometer | >500ms | 冒烟 + 压测抽样 |
| OBS-02 | 错误率 | 5xx 计数 | >1% | test-report |
| OBS-03 | <业务指标> | | | |

tasks.md：标注 **MVP 范围**（本迭代必做 task）与 **OBS 相关 task**（如有埋点/结构化日志 task）。
长期外部依赖 → 同步写入 pending-todos.md（类型=依赖）。
```

---

<a id="template-l"></a>

## 模板 L：迭代归档 handoff（Case 2）

> `docs/features/<feature_name>/archive/handoff-<YYYYMMDD>.md`

```markdown
# Handoff Archive: <feature_name> — YYYY-MM-DD

## 交付（PR/commit/环境）
## Spec 锚点
## Baseline（下轮勿重做）
## 遗留 / 技术债
## 踩坑
## 下一迭代 in scope
```

---

## 修订记录

| 日期 | 说明 |
|------|------|
| 2026-08-24 | 回传落盘 handoff-to-coach.md；执行窗只出 D-人读；教练 Read 文件 |
| 2026-07-20 | EV-06 P1：模板 B trial 可选句；AUDIT 注明教练生成 |
| 2026-07-20 | EV-06 P0：模板 A/J 增 run_mode；AUDIT + trial-log 骨架 |
| 2026-07-17 | 增模板 11-P1/11-P2（Complex P1/P2 骨架） |
| 2026-07-17 | 模板 A 增 Gate 0；模板 J 增 track 字段 |
| 2026-07-17 | 增模板 P3-Q Gate P3→P4 待办确认问卷（L0） |
| 2026-07-17 | 增 OQ P3 段、pending-todos 骨架；模板 D/J 待办节 |
| 2026-07-16 | 增模板 OQ；模板 D/F 开放问题 Gate |
| 2026-07-14 | 初版：教练开场、执行头、回传包、常用 Phase 片段 |
| 2026-07-14 | 增模板 J/K/L；会话恢复与归档（与 project_pre-customer-info 对齐） |
| 2026-07-14 | 模板加英文锚点 `#template-a`～`#template-l`，修复点击跳转 |
