# L0 两边对齐核对清单（带回工作电脑用）

> **用途**：在工作电脑打开公司仓，对照本清单勾选。判断的是 **AgentTeam L0 流程语义**是否一致，不是两仓文件字节级相同。  
> **个人仓落地日**：2026-08-27。  
> **个人仓路径**：`D:\develop-project\agent-team-kit`（kit 标准源）。验证仓示例：`D:\develop-project\spring-ai-study`。  
> **对照源**：工作电脑带来的 `AgentTeam.md.txt`（回传落盘 + 三根目录）。

**怎么用（工作电脑）**

1. 把本文件拷到 U 盘 / 桌面（不必拷整个仓库）。
2. 在公司仓根目录跑 §1 搜索（PowerShell）。
3. 按 §2 打开文件，看「必须出现」片段是否在。
4. 用 §3 区分「该一样」和「本来就不该一样」。
5. 填 §5 结论。

判定标准：

| 结论 | 含义 |
|------|------|
| **L0 语义对齐** | §1 全绿 + §2 必现片段都在（措辞可略有出入） |
| **有缺口** | 仍在「粘贴【回传教练包】全文」或缺少 `handoff-to-coach.md` / `template-d-user` / 教练 3b |
| **字节不一致但允许** | 端口、JDK、包名、产品名、公司绝对路径、额外 Agent/HTML 看板 —— 见 §3 |

---

## 1. 全库搜索（先做，1 分钟）

在**公司仓根**用 PowerShell（有 `rg` 更好；没有就用 `Select-String`）。

### 1.1 必须为 0（旧闭环已清掉）

```powershell
# 旧：粘贴全文回教练 —— 必须 0
rg -n "粘贴下方【回传教练包】全文" --glob "*.md" --glob "*.mdc"

# 旧：执行结束必须在聊天里吐回传包 —— 必须 0（P0 整理报告除外）
rg -n "完成后必须输出【回传教练包】" --glob "*.md" --glob "*.mdc"
```

无 `rg` 时：

```powershell
Get-ChildItem -Recurse -Include *.md,*.mdc |
  Select-String -Pattern "粘贴下方【回传教练包】全文","完成后必须输出【回传教练包】"
```

**个人仓 2026-08-27 实测：两条都是 0。**

### 1.2 必须能搜到（新闭环已落地）

| 搜什么 | 个人仓落点（至少这些文件有） |
|--------|------------------------------|
| `handoff-to-coach.md` | `coach-kickoff-template.md`、`agent-team-paths.mdc`、各执行 Agent、使用手册 |
| `template-d-user` | `docs/agent-team/coach-kickoff-template.md` |
| `3b. 用户说「完成 / 读 handoff」` | `.cursor/agents/agent-team-coach.md` |
| `workspace-layout.md` | `docs/agent-team/workspace-layout.md` 文件存在 |
| `本步结果（人读）` | `coach-kickoff-template.md` 模板 D 与 E 之间 |

```powershell
rg -l "handoff-to-coach.md" --glob "*.md" --glob "*.mdc"
rg -l "template-d-user" --glob "*.md"
rg -n "3b. 用户说" .cursor/agents/agent-team-coach.md
Test-Path docs/agent-team/workspace-layout.md
```

### 1.3 允许残留（不是缺口）

下面这些**可以**还出现，不算没对齐：

| 文本 | 为什么允许 |
|------|------------|
| `## 【回传教练包】` | 模板 D **写入文件**的标题还叫这个，字段没删 |
| `回传教练包` 出现在修订记录 / 旧日期行 | 历史记录 |
| `完成后必须输出【整理报告】` | P0 专用，不是模板 D |
| 公司仓自己的产品名、端口、包名 | L2，禁止用个人仓覆盖 |

---

## 2. 逐文件必现片段

打开公司仓对应文件。**不必逐字相同**，但语义必须在。右侧是个人仓已写入的原文（可当「金样」）。

### 2.1 `docs/agent-team/coach-kickoff-template.md`（最重要）

| # | 核对点 | 个人仓金样（语义） |
|---|--------|-------------------|
| A | 速查表 B | 用途含「读 handoff，不要拷执行窗」 |
| B | 速查表 D | 用途含「写入 `handoff-to-coach.md`（勿贴进聊天）」 |
| C | 有 `template-d-user` | 锚点 + 「本步结果（人读）」五行 |
| D | 模板 B 不再写「粘贴下方【回传教练包】全文」 | 改为 `请 Read .../handoff-to-coach.md` |
| E | 模板 B 有更短块 | `<对话名> 完成，读 handoff` |
| F | 模板 C 结束约束 | Write handoff + 聊天只出 D-人读 + 禁止贴 D 全文 |
| G | 模板 D 标题 | 「写入文件 · 禁止只写在对话」 |
| H | 模板 F / G / H | 同样 Write + D-人读，不再「完成后输出【回传教练包】」 |
| I | 快速流程第 3～4 步 | 执行完 Write handoff；教练窗「读 handoff」 |
| J | 模板 J | 「Write `handoff-to-coach.md` 后更新」；关键文档第一行有 `handoff-to-coach.md` |
| K | 修订记录 | 有 `2026-08-24` 回传落盘一行 |

D-人读五行金样：

```markdown
1. **结果**：✅ / ⚠️ / ❌ · 【对话名】· <一句做了什么>
2. **你现在**：回教练窗发送「<对话名> 完成，读 handoff」（不要拷本窗正文）
3. **改动**：<文件数或 3～7 个关键路径>
4. **验证**：<测过什么 → 过/没过；未跑写「未跑」>
5. **要你拍板**：<最多 3 条；没有写「无」>
```

### 2.2 `docs/agent-team/coach-playbook.md`

- 开篇一句话含 **`handoff-to-coach.md`**，且写明不要从执行窗拷全文
- Step 1 / Step 2「收尾」：Write handoff → 用户「读 handoff」→ 教练 Read
- 每一步固定动作 4～5：Write `handoff-to-coach.md` + 回教练窗「读 handoff」
- 「发给教练」表：**没有**「【回传教练包】全文」；❌ 列有「把执行窗全文拷回教练」
- 异常「执行 ❌ 阻塞」：先 Write handoff（状态❌）

### 2.3 `.cursor/rules/agent-team-paths.mdc`

产出表必须有一行：

```text
handoff-to-coach.md
```

并有 **Spec 根 workspace_docs（命中即停）** 三步：

1. 模板 A / `session-checkpoint.md` 已写 `workspace_docs`
2. 工作区存在名为 `*-docs` 的 folder
3. 否则：当前仓库根（单仓退化）

### 2.4 `.cursor/agents/`（语义补丁，项目约束可不同）

| 文件 | 必须有 |
|------|--------|
| `agent-team-coach.md` | **3b**：用户说「完成 / 读 handoff」且未贴模板 D → **Read** `handoff-to-coach.md`；无文件不给下一 Phase；旧式 D 全文兼容 |
| `backend-developer.md` | Write handoff + 只出 D-人读；禁止把 D 贴进对话 |
| `requirements-analyst.md` | Write handoff（含开放问题全文表）+ D-人读 |
| `architect.md` | Write handoff（含 OQ 决议摘要）+ D-人读 |
| `tester.md` | Write handoff + D-人读 |
| `code-reviewer.md` | Write handoff（含分级结论）+ D-人读 |
| `frontend-developer.md` | **个人仓没有此文件**（标准源 server-only）。公司仓若有，只核结束句是否 Write handoff，**不要**拷回个人仓 |

教练 3b 金样：

```text
3b. 用户说「完成 / 读 handoff」且未贴模板 D：**Read** `{workspace_docs}/docs/features/{feature}/handoff-to-coach.md`（多产品带 `{product}`）。无文件 → 本步未结束，不给下一 Phase。仍贴旧式 D 全文则兼容接受。
```

### 2.5 其它交叉引用

| 文件 | 必须变成 |
|------|----------|
| `docs/agent-team/agent-dialog-naming.md` §5 | 执行必须 Write 文件；聊天只出 D-人读；用户回教练「读 handoff」 |
| `docs/agent-team/session-persistence.md` | 更新时机：Write handoff **之后**（不再写「把回传包贴给教练」） |
| `docs/agent-team/requirement-input-guide.md` | P1 结束句 Write handoff + D-人读 |
| `docs/agent-team/trial-run-guide.md` | 「回传包贴教练窗」改为 Write handoff → 「读 handoff」 |
| `docs/features/README.md` | 目录树有 `handoff-to-coach.md` |
| `docs/agent-team/evolution-checkpoint.md` | 当前焦点含回传落盘 / handoff |
| 使用手册（若公司仓有） | 闭环改为 Write handoff，不要拷执行窗 |

### 2.6 三根目录

| 文件 | 必须 |
|------|------|
| `docs/agent-team/workspace-layout.md` | **存在**；讲清 kit / workspace_docs / code_root；文件名列表含 `handoff-to-coach.md` |
| `docs/agent-team/README.md` 或 `bootstrap-new-project.md` | 有指向 `workspace-layout.md` 的入口 |
| `docs/agent-team/snippets/workspace-docs-paths.mdc` | 个人仓有（给将来 `*-docs`）。公司仓可有可无，缺了不算 L0 失败 |

---

## 3. 本来就不该一样（不要当成缺口）

个人仓 **kit** 是 AgentTeam 标准源。公司仓是业务仓。L2 差异是设计如此：

| 项 | 个人仓（kit） | 公司仓（预期） | 处理 |
|----|------------------|----------------|------|
| 技术栈 | kit 不含业务栈；验证仓示例 Spring Boot / Java 21 | 公司 JDK、包名、模块名 | **禁止**互相覆盖 `project-architecture.mdc` |
| 端口 | `http://localhost:8080` | 公司 admin/app 端口 | **禁止**互相覆盖 `test-env.override.md` |
| 绝对路径 | 无公司盘符 | 可以有公司路径 | 回流个人仓前必须剥掉 |
| `frontend-developer` | **没有**（已决 server-only） | 可能有 | 不要拷进个人仓 |
| 会话看板 HTML / 新 Gate / 新 Agent | **没有**（L0 明确不做） | 可能有 | 不要拷进个人仓 |
| 产品目录 `{product}` | 默认不加；`trade`/`research` 仅作抽象例子 | 可能有真实产品名 | 个人仓保持抽象 |
| mock 需求 | 未建 `mock-handoff-echo`（§4 仅试跑时才建） | 可能另有 mock | 不算 L0 缺口 |
| `overview.md` / `kit-layers.md` | 个人仓原先没有，只加了 `workspace-layout.md` 入口 | 公司仓可能有长文 | 不要求字节对齐 |

**回流规则（公司 → 个人，以后）**：只带 L0 通用 diff（playbook / 模板 / agents 结束句 / paths）。禁止覆盖个人仓 `test-env.override.md`、`project-architecture.mdc`。

**回流规则（个人 → 公司，若要把这次改动带回去）**：同样只合 L0 通用语义；禁止覆盖公司 `test-env.override.md`、`project-architecture.mdc`；剥掉个人机绝对路径。

---

## 4. 个人仓本轮已改文件清单（2026-08-27）

带回公司时，只核这些路径的 **L0 语义**。

**改**

- `docs/agent-team/coach-kickoff-template.md`
- `docs/agent-team/coach-playbook.md`
- `docs/agent-team/agent-dialog-naming.md`
- `docs/agent-team/session-persistence.md`
- `docs/agent-team/requirement-input-guide.md`
- `docs/agent-team/trial-run-guide.md`
- `docs/agent-team/README.md`
- `docs/agent-team/bootstrap-new-project.md`
- `docs/agent-team/evolution-checkpoint.md`
- `docs/features/README.md`
- `.cursor/rules/agent-team-paths.mdc`
- `.cursor/agents/agent-team-coach.md`
- `.cursor/agents/backend-developer.md`
- `.cursor/agents/requirements-analyst.md`
- `.cursor/agents/architect.md`
- `.cursor/agents/tester.md`
- `.cursor/agents/code-reviewer.md`
- `使用手册/AgentTeam-快速上手.md`
- `使用手册/AgentTeam-使用说明-明细版.md`

**新建**

- `docs/agent-team/workspace-layout.md`
- `docs/agent-team/snippets/workspace-docs-paths.mdc`

**故意没改**

- `.cursor/rules/project-architecture.mdc`
- `docs/agent-team/test-env.override.md`
- 业务 Java 代码
- 未建 `docs/features/mock-handoff-echo/`

---

## 5. 工作电脑勾选表（抄到笔记即可）

把公司仓搜到的结果打勾。

```text
□ §1.1 旧句「粘贴下方【回传教练包】全文」= 0
□ §1.1 旧句「完成后必须输出【回传教练包】」= 0
□ 存在 template-d-user / 「本步结果（人读）」
□ 教练 agent 有 3b（完成 / 读 handoff → Read 文件）
□ agent-team-paths.mdc 产出表含 handoff-to-coach.md
□ 存在 workspace-layout.md（或公司仓等价长文，语义含三根目录）
□ 模板 B 是 Read handoff，不是粘贴全文
□ 执行 Agent 结束句是 Write + D-人读

L2 差异（预期，不算失败）：
□ 端口 / JDK / 包名 与个人仓不同（正常）
□ 公司仓多了 HTML 看板 / 额外 Agent / 产品路径（正常，不要带回个人仓）

结论（三选一）：
□ L0 语义对齐
□ 有缺口（把缺失文件名写下面）
□ 只差措辞，语义已对齐（可忽略）

缺口记录：
-
-
```

---

## 6. 若发现缺口，怎么补

- **公司仓缺 L0**：把本清单 + 个人仓对应 md 片段（不要整仓）带回公司，让 Agent 只补缺口；再次禁止覆盖 `test-env.override.md` / `project-architecture.mdc`。
- **个人仓缺、公司仓有**：只摘 **L0 通用句**（Write handoff、D-人读、3b、三根目录）回流个人仓；剥掉公司路径/端口/产品名后再合。
- **两边都有、措辞不同**：只要搜索 §1.1 = 0 且 3b / D-人读 / 产出表有 handoff，即视为对齐，不必为同义改写再改一轮。

建议 commit message（哪边补完用哪边）：

```text
docs(agent-team): 回传落盘 handoff-to-coach + 工作区三根目录（L0）
```
