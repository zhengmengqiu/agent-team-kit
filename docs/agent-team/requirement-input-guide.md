# 需求输入操作指南（Agent 分析阶段）

> **用途**：P1 开 `@requirements-analyst` 之前，按本指南整理需求材料，让 Agent **稳定可读、可引用、可 Gate**。  
> **原则**：飞书/Figma/HTML 只是**来源**；进仓库的 **handoff 包**才是执行输入。  
> **关联**：[coach-playbook.md](./coach-playbook.md) Step 0 · [coach-kickoff-template.md](./coach-kickoff-template.md) 模板 P0/C/F/D  
> **Agent 自动整理**：`@requirement-input-prep`（Phase 0，见 §0.5）

---

## 0.5 Phase 0：让 Agent 建目录 + 推荐方案（推荐）

**目标**：你只需提供原始材料路径，Agent 创建标准 `input/`、识别场景、给出后续手动清单。

```
原始材料（飞书 MD / HTML / Figma PNG / Word…）
      ↓
新开执行对话 @requirement-input-prep（模板 P0）
      ↓
Agent：mkdir + 搬运 + 骨架 prd/guide + 【整理报告】
      ↓
你：完成报告里的「手动清单」（如飞书导出 Word 抠图）
      ↓
开教练 @agent-team-coach → P1
```

| 步骤 | 操作 |
|------|------|
| 1 | 把原始文件放到任意临时路径，或下载到本机（不必先建目录） |
| 2 | 新开 **Agent** 对话，命名 `{feature}-P0-整理-input材料` |
| 3 | `@requirement-input-prep` + 粘贴 **[coach-kickoff-template 模板 P0](./coach-kickoff-template.md#template-p0)** |
| 4 | 在提示词里 **@ 或写明** 材料绝对路径 |
| 5 | 执行结束 → 收 **【整理报告】** → 完成手动项 → 再开教练 |

**Agent 定义**：`.cursor/agents/requirement-input-prep.md`

---

## 0. 5 分钟速查（开 P1 前必做）

```
收到需求
  │
  ├─ 主要是文字规则/接口？ ──→ 场景 A：纯 MD
  ├─ 有截图/流程图？       ──→ 场景 B：MD + 本地 png（飞书 MD 内链不可用）
  ├─ 有可点击静态 HTML？   ──→ 场景 C：HTML + prototype-guide.md
  ├─ 有 Figma/设计稿？     ──→ 场景 D：导出 png + design-handoff.md
  ├─ 只有 Word/PDF？       ──→ 场景 E：文字进 MD，Word 只用来抠图
  └─ 口头/变更增量？       ──→ 场景 F：delta-requirements.md + 旧 spec

整理到 docs/features/{feature}/input/ → 开 P1（见 §6 提示词模板）
```

| 检查项 | 通过标准 |
|--------|----------|
| 目录已建 | `docs/features/{feature}/input/` 存在 |
| 文字真相 | 有 `prd.md`（或等价主文档） |
| 图片本地化 | **无** `larksuite.com` / 飞书内链；图为 `./images/*.png` |
| 索引文件 | HTML/Figma 场景有 `prototype-guide.md` 或 `design-handoff.md` |
| 冲突优先级 | 已在 MD 写明：定稿 > handoff > 原型 > 旧 spec |
| 教练知晓 | 教练对话或 checkpoint 记录了 input 路径 |

---

## 1. 标准目录（所有场景统一）

新建功能时，先建目录（`{feature}` = 短名，如 `join_community`）：

```
docs/features/{feature}/
  input/
    prd.md                    # 【必填】文字真相：背景、范围、规则、异常
    prototype-guide.md        # 【C 有 HTML 时】页面索引 + 过时项标注
    design-handoff.md         # 【D 有 Figma 时】页面清单 + 字段 + 交互
    delta-requirements.md     # 【F 变更时】相对旧版的增量
    prototype/                # 【C】HTML 原型文件
      index.html
      ...
    images/                   # 【B/C/D/E】全部本地图片
      01-admin-list.png
      02-edit-form.png
      figma/                  # 可选：设计稿导出单独子目录
  session-checkpoint.md       # AgentTeam 进度（见 session-persistence.md）
  proposal.md                 # P1 产出（执行 Agent 写）
```

**命名建议**：图片用 `序号-页面-状态.png`，如 `01-admin-list.png`、`02-edit-empty.png`。

---

## 2. 场景对照表

| 场景 | 你手里有什么 | Agent 友好度 | 核心动作 |
|------|--------------|--------------|----------|
| **A** 纯文字 MD | 飞书/Jira 文字 PRD | ⭐⭐⭐ | 整理成 `input/prd.md` |
| **B** MD + 图片 | 飞书 MD（含内链图） | ⭐⭐⭐（本地化后） | MD 取字 + Word 抠图 → `images/` |
| **C** HTML 原型 | 静态页 / Axure 导出 | ⭐⭐⭐ | HTML 入 `prototype/` + 写 guide |
| **D** Figma 设计 | 设计稿链接 | ⭐⭐（需导出） | 导出 png + `design-handoff.md` |
| **E** Word/PDF | 产品只给文档 | ⭐⭐ | 正文 → MD；图 → png |
| **F** 口头/变更 | 会议结论、改需求 | ⭐ | 写 `delta-requirements.md` |

### Agent **不能**稳定依赖的输入

| 输入 | 原因 |
|------|------|
| 飞书 `internal-api-drive-stream...` 内链 | 鉴权 + 过期 |
| Figma 在线链接（无 MCP） | 需登录、节点过大 |
| 聊天里临时粘贴的截图 | 新开 P1 对话会丢失 |
| 仅 `.docx` / `.pdf` 无整理 | Agent 结构化解析不稳定 |

---

## 3. 分场景操作 SOP

### 场景 A：纯文字 MD / PRD

**适用**：接口规则、状态机、字段表、业务逻辑为主，UI 简单。

| 步骤 | 操作 |
|------|------|
| A1 | 复制 PRD 到 `input/prd.md` |
| A2 | 补章节：背景、In/Out Scope、名词表、规则、异常、待确认 |
| A3 | UI/菜单若未写清，在文末加「待产品补充」清单 |
| A4 | 开 P1 → 用 [§6.1 纯 MD 提示词](#61-场景-a纯-md) |

---

### 场景 B：MD + 图片（含飞书导出）

**适用**：有界面截图、流程图、表格图。  
**飞书特性**：导出 **MD** → 图多为 URL；**可访问的 URL 由 Phase 0 Agent 自动下载**，无需手改文件名。

| 步骤 | 操作 | 谁做 |
|------|------|------|
| B1 | 飞书 → **导出 MD** | 你 |
| B2 | 新开 **P0** `@requirement-input-prep`，@ MD 路径 | Agent |
| B3 | Agent 跑 `scripts/download-md-images.ps1`（或等效 curl） | Agent |
| B4 | 成功：图片 → `input/images/`，`prd.md` 内链已替换；映射 → `image-url-map.json` | Agent |
| B5 | **仅失败项**：飞书内链 → 导出 **Word** 抠图，或本机浏览器已登录时重跑脚本 | 你（仅失败部分） |
| B6 | 每张图下补 2~3 行说明（Agent 可写骨架 `[待补充]`） | Agent + 你 |
| B7 | 开 P1 → §6.2 | 教练 → P1 |

<a id="31-md-image-auto-download"></a>

### 3.1 MD 图片自动下载（细节）

**脚本**：[`docs/agent-team/scripts/download-md-images.ps1`](./scripts/download-md-images.ps1)

```powershell
# 在项目根执行；路径按功能改
.\docs\agent-team\scripts\download-md-images.ps1 `
  -MarkdownFile "docs\features\join_community\input\prd-from-feishu.md" `
  -OutputDir "docs\features\join_community\input\images" `
  -RewriteMarkdown "docs\features\join_community\input\prd.md"
```

**命名规则**：`01-{alt转slug}.png`、`02-...` —— 与 MD 中图片顺序一致，避免手改错配。

**退出码**：`0` 全成功；`2` 部分失败（看 `image-url-map.json` 里 `status=failed`）。

| URL 能否自动下 | 说明 |
|----------------|------|
| ✅ 公网 / curl 200 | Agent 或脚本直接下 |
| ✅ 浏览器能开、本机有 Cookie | 在你电脑跑脚本有时可成功 |
| ❌ 飞书 internal-api 401/403 | 用 Word 抠图兜底 |

---

### 场景 C：HTML 原型

**适用**：产品给可打开静态页（参考：`docs/features/example-app-demo-feature` 同类项目的 HTML 原型做法）。

| 步骤 | 操作 |
|------|------|
| C1 | HTML 放入 `input/prototype/`（整包或单文件） |
| C2 | **必写** `input/prototype-guide.md`（见 [§4.1 模板](#41-prototype-guidemd)） |
| C3 | 指定 Agent **只读** guide 里列出的页面（避免扫全站） |
| C4 | 关键页再截 3~5 张 png 到 `images/`（强烈推荐） |
| C5 | `prd.md` 写规则；与 HTML 冲突时 **以 prd/产品定稿为准** |
| C6 | 开 P1 → 用 [§6.3 HTML 提示词](#63-场景-chtml-原型) |

---

### 场景 D：Figma / 专业设计稿

**适用**：正式 UI、多状态（空态/错误态/禁用态）。

| 步骤 | 操作 |
|------|------|
| D1 | Figma → 导出关键 Frame 为 **PNG** → `input/images/figma/` |
| D2 | **必写** `input/design-handoff.md`（见 [§4.2 模板](#42-design-handoffmd)） |
| D3 | Figma 链接可写在 handoff 里作**人工索引**，Agent 以 PNG + handoff 为准 |
| D4 | 若有 Figma MCP，可在 P1 提示词额外注明 frame 名；仍保留 PNG 备份 |
| D5 | 开 P1 → 用 [§6.4 Figma 提示词](#64-场景-dfigma--设计稿) |

---

### 场景 E：Word / PDF

| 步骤 | 操作 |
|------|------|
| E1 | Word：正文整理进 `input/prd.md`（不必保留 docx 作唯一输入） |
| E2 | Word：图片按场景 B 抠到 `images/` |
| E3 | PDF：优先让人/export 成 MD；或关键页截图 → png |
| E4 | 开 P1 → 用 [§6.2 MD+图片提示词](#62-场景-bmd--本地图片) |

---

### 场景 F：口头变更 / 多源混杂

**适用**：「在原来基础上改」、会议结论、微信补需求。

| 步骤 | 操作 |
|------|------|
| F1 | 写 `input/delta-requirements.md`（见 [§4.3 模板](#43-delta-requirementsmd)） |
| F2 | 标明 baseline：`docs/features/{feature}/proposal.md`（或旧版路径） |
| F3 | 列出：变更点、废弃项、产品原话（可选） |
| F4 | 教练对话说明「从 P1 增量重做」或「P2 增量 design」 |
| F5 | 开 P1 → 用 [§6.5 变更增量提示词](#65-场景-f变更增量) |

---

## 4. 索引文件模板（复制即用）

<a id="41-prototype-guidemd"></a>

### 4.1 `prototype-guide.md`

```markdown
# 原型阅读指南 — {功能名}

> 原型路径：`input/prototype/`  
> **冲突优先级**：`input/prd.md` / 产品定稿 > 本 HTML 原型

## 必读页面（按顺序）

| 序号 | 文件 | 页面说明 | 对应 AC 主题 |
|------|------|----------|--------------|
| 1 | `admin-list.html` | 社群配置列表 | Admin 列表/筛选 |
| 2 | `admin-edit.html` | 新增/编辑弹窗 | Admin CRUD |
| 3 | `app-redirect.html` | C 端跳转示意 | TOC 返回结构 |

## 关键字段（从原型提取）

| 字段 | 位置 | 必填 | 说明 |
|------|------|------|------|
| … | … | … | … |

## 原型过时项（勿写入 AC）

- [ ] 页面 X 的 XX 按钮 — 产品已取消
- [ ] …

## 补充截图

- `./images/01-admin-list.png` — 列表最终态
```

<a id="42-design-handoffmd"></a>

### 4.2 `design-handoff.md`

```markdown
# 设计交接 — {功能名}

> Figma：[链接，仅人工索引]  
> **Agent 分析以本地 PNG + 本文为准**

## 页面清单

| 页面 | PNG 路径 | 状态覆盖 |
|------|----------|----------|
| 配置列表 | `./images/figma/admin-list.png` | 默认 / 空态 |
| 编辑弹窗 | `./images/figma/admin-edit.png` | 新建 / 编辑 / 校验失败 |

## 字段与校验

| 字段 | 类型 | 必填 | 校验 | 说明 |
|------|------|------|------|------|
| … | … | … | … | … |

## 交互说明

- 禁用后：C 端不可命中该社群规则
- 删除：二次确认；有关联数据时不可删（若适用）

## 与 PRD 差异

- …
```

<a id="43-delta-requirementsmd"></a>

### 4.3 `delta-requirements.md`

```markdown
# 需求变更增量 — {功能名}

> 日期：YYYY-MM-DD  
> Baseline：`docs/features/{feature}/proposal.md`（vX）

## 变更摘要

- …

## 变更点（相对 baseline）

| # | 类型 | 说明 | 影响 |
|---|------|------|------|
| 1 | 新增 | … | Admin API |
| 2 | 修改 | … | TOC 路由规则 |
| 3 | 废弃 | … | 不再实现 XX |

## 产品定稿（原文可选）

> …

## 待 P2 设计

- …
```

---

## 5. 冲突优先级（写入 prd.md 开头）

所有多源输入的功能，在 `prd.md` 顶部固定写：

```markdown
## 输入源与优先级

1. **产品定稿 / 本文 prd.md** — 最高
2. **design-handoff.md** — UI 字段与交互
3. **prototype-guide.md + HTML** — 页面结构参考
4. **旧 spec（proposal/design）** — 仅作 baseline，变更以 delta 为准

冲突时：在 proposal「待确认」列出，不得静默猜测。
```

---

## 6. P1 执行提示词模板（粘贴到执行对话）

将 `{feature}`、`{feature_name}` 替换为实际值。标准头见 [coach-kickoff-template.md 模板 C](./coach-kickoff-template.md#template-c)。

<a id="61-场景-a纯-md"></a>

### 6.1 场景 A（纯 MD）

```text
【对话名】{feature}-P1-需求-proposal编写
【功能】{feature_name}
【短名】{feature}
【阶段】Phase 1 — 需求分析（纯文字 PRD）
【角色】@requirements-analyst

@requirements-analyst

## 必读输入
- docs/features/{feature}/input/prd.md

## 任务
1. 搜索代码库复用点，写 Migration Baseline
2. In/Out Scope + Given/When/Then AC + 测试策略
3. UI/菜单未写清处 → proposal「待确认」，勿猜测
4. 产出：docs/features/{feature}/proposal.md
5. Gate 1 自检

## 约束
- 禁止依赖外链图片；本场景无 images/
- **开放问题**：见 coach-kickoff-template [模板 OQ · P1 段](./coach-kickoff-template.md#template-oq)
- 完成后：**Write** `docs/features/{feature}/handoff-to-coach.md`（coach-kickoff-template 模板 D，含开放问题全文表，覆盖写）；聊天只出 **模板 D-人读**
```

<a id="62-场景-bmd--本地图片"></a>

### 6.2 场景 B（MD + 本地图片）

```text
【对话名】{feature}-P1-需求-proposal编写
【功能】{feature_name}
【短名】{feature}
【阶段】Phase 1 — 需求分析（MD + 本地图片）
【角色】@requirements-analyst

@requirements-analyst

## 必读输入（按顺序）
1. docs/features/{feature}/input/prd.md
2. docs/features/{feature}/input/images/ 下全部 png/jpg（须 Read 每张图）

## 硬性约束
- **禁止**依赖 prd 中的 larksuite.com / 飞书内链
- 图中有、文字无的规则 → 写入 AC 或「待确认」
- **开放问题**：见 [模板 OQ · P1 段](./coach-kickoff-template.md#template-oq)（PRD 待确认 + 图稿冲突合并 OQ-01…）

## 任务
（同 6.1）+ 结合图片补充 UI/流程 AC

**AC 分层（强制）**：Read `docs/agent-team/delivery-boundary.md`
- 可 API/规则验证 → `[Must]`
- 纯 UI/交互 → `[UI-Ref]`（P4 可 Blocked-待前端联调）
- 非本团队 → `[Out-of-Scope]`

## handoff 额外字段（写入 `handoff-to-coach.md`）
- 输入类型：MD+本地图
- 已读图片：N 张（列文件名）
- **开放问题全文表**（必填）
```

<a id="63-场景-chtml-原型"></a>

### 6.3 场景 C（HTML 原型）

```text
【对话名】{feature}-P1-需求-proposal编写
【功能】{feature_name}
【短名】{feature}
【阶段】Phase 1 — 需求分析（HTML 原型 + PRD）
【角色】@requirements-analyst

@requirements-analyst

## 必读输入（按顺序）
1. docs/features/{feature}/input/prd.md
2. docs/features/{feature}/input/prototype-guide.md（页面索引，优先）
3. guide 中列出的 HTML 文件（勿扫 prototype/ 全目录）
4. [若有] input/images/*.png

## 硬性约束
- 冲突优先级见 prd.md「输入源与优先级」
- prototype-guide「过时项」不得写入 AC
- HTML 仅 UI 参考，路由/权限规则以 prd 为准

## handoff 额外字段（写入 `handoff-to-coach.md`）
- 输入类型：HTML+guide
- 已读 HTML：列出文件名
- 原型过时项：已标注 N 条
```

<a id="64-场景-dfigma--设计稿"></a>

### 6.4 场景 D（Figma / 设计稿）

```text
【对话名】{feature}-P1-需求-proposal编写
【功能】{feature_name}
【短名】{feature}
【阶段】Phase 1 — 需求分析（设计稿 handoff）
【角色】@requirements-analyst

@requirements-analyst

## 必读输入
1. docs/features/{feature}/input/prd.md
2. docs/features/{feature}/input/design-handoff.md
3. handoff 中列出的全部 PNG（images/figma/）

## 硬性约束
- 不以 Figma 在线链接为分析依据
- 字段/状态以 design-handoff + PNG 为准

## handoff 额外字段（写入 `handoff-to-coach.md`）
- 输入类型：Figma-handoff
- 已读 PNG：N 张
```

<a id="65-场景-f变更增量"></a>

### 6.5 场景 F（变更增量）

```text
【对话名】{feature}-P1-需求-v{版本}-变更proposal
【功能】{feature_name}
【短名】{feature}
【阶段】Phase 1 — 需求变更增量
【角色】@requirements-analyst

@requirements-analyst

## 必读输入
1. docs/features/{feature}/proposal.md（baseline，只读对照）
2. docs/features/{feature}/input/delta-requirements.md
3. [若有] input/prd.md、images/、prototype-guide.md

## 任务
- **仅修订** proposal.md（标注 v 版本与变更摘要）
- 写 Migration Baseline：已实现 / 需改 / 可删
- 新 AC + 废弃 AC 分开列
- **不改** design.md / tasks.md / 代码

## handoff 额外字段（写入 `handoff-to-coach.md`）
- 输入类型：delta
- AC 统计：新增 N / 修订 M / 废弃 K
```

---

## 7. 混合场景（常见组合）

| 组合 | 目录 | P1 提示词 |
|------|------|-----------|
| PRD + 截图 | `prd.md` + `images/` | §6.2 |
| PRD + HTML | 加 `prototype/` + `prototype-guide.md` | §6.3 |
| PRD + Figma | 加 `design-handoff.md` + `images/figma/` | §6.4 |
| 全都有 | 全部文件 + prd 写优先级 | §6.3 为主，合并 6.2/6.4 的必读清单 |

**混合提示词写法**：在「必读输入」按顺序列全部路径，并写：

```text
冲突优先级：prd.md > design-handoff.md > prototype-guide.md > HTML
```

---

## 8. 与教练对话的配合

### 8.1 教练开场（模板 A）补充一行

在 [coach-kickoff-template 模板 A](./coach-kickoff-template.md#template-a) 的「已有产出」后加：

```text
【需求输入】已按 requirement-input-guide 整理：
- docs/features/{feature}/input/prd.md
- docs/features/{feature}/input/images/ （N 张）
- [可选] prototype-guide.md / design-handoff.md
【输入场景】A/B/C/D/E/F 或混合
```

教练会根据场景给出带「必读附件」的 P1 提示词。

### 8.2 Gate 1 人工检查（有 UI 时）

- [ ] proposal 含 `## 交付边界`（见 [delivery-boundary.md](./delivery-boundary.md)）
- [ ] AC 已分 `[Must]` / `[UI-Ref]` / `[Out-of-Scope]`；Must 覆盖核心业务规则
- [ ] proposal 有 `## 开放问题` 表，OQ 统一编号
- [ ] **阻塞 P2** 的 OQ 已在 P1 对话确认（Gate 1-OQ）
- [ ] `handoff-to-coach.md` 含开放问题**全文表**，非只报个数
- [ ] Agent 回传包写了「已读图片 N 张」且 N 正确
- [ ] proposal 中菜单/字段与截图一致（Must 级字段）
- [ ] AC 引用 OQ-0N，无飞书内链依赖

### 8.3 Gate 2-OQ（P2 后）

- [ ] design.md 有 `## 开放问题决议`
- [ ] 阻塞 P3 的 OQ 已决议或已接受默认分支
- [ ] tasks 中未决项标 `[OQ-0N]`

---

## 9. 飞书导出备忘卡

```
┌──────────────────────────────────────────────────────────┐
│  飞书 → 导出 MD → prd-from-feishu.md                      │
│  P0 Agent / download-md-images.ps1 → 自动下载可访问 URL    │
│       → images/01-{alt}.png + 回写 prd.md + map.json     │
│  仅失败的内链 → 再导出 Word 抠图（不必全量手改文件名）     │
└──────────────────────────────────────────────────────────┘
```

---

## 10. 修订记录

| 日期 | 说明 |
|------|------|
| 2026-08-24 | P1 结束句改为 Write `handoff-to-coach.md` + D-人读 |
| 2026-07-16 | §6.2/§8 增开放问题 OQ 与 Gate 1-OQ / Gate 2-OQ |
| 2026-07-16 | 补充 delivery-boundary 引用；§6.2 AC 分层；Gate 1 交付边界检查 |
| 2026-07-16 | 首版：A~F 场景 SOP、目录规范、P1 提示词、索引模板 |
