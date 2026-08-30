# Agent 会话持久化与归档规范

> **问题**：Cursor Agent 对话可能被误删，聊天记录不是可靠真相源。  
> **原则**：**Git 可提交文档 = 真相**；Cursor Memory = 轻量索引；教练对话 = 流程枢纽（可重建）。  
> 命名规范见 [agent-dialog-naming.md](./agent-dialog-naming.md)；模板见 [coach-kickoff-template.md](./coach-kickoff-template.md)。

---

## 两种场景对照

| 场景 | 目的 | 存什么 | 放哪 | Cursor Memory |
|------|------|--------|------|---------------|
| **Case 1 会话恢复** | 对话删了也能续接**当前** Phase/Step | 进度、最后对话名、Gate、遗留项 | `docs/features/{feature}/session-checkpoint.md` | 可选：一行指针 |
| **Case 2 迭代归档** | **下一版需求**或换人接手 | 交付结论、baseline、坑、未做项 | `docs/features/{feature}/archive/` | 不建议（细节进 Git） |

---

## Case 1：会话恢复（当前需求进行中）

### 是否应该「保存记忆」？

| 方式 | 建议 | 说明 |
|------|------|------|
| **仅 Cursor Memory** | ⚠️ 不够 | 无版本、无团队共享、易与别项目混淆 |
| **仅保留教练对话** | ⚠️ 不够 | 教练对话也会删；且不含单测/DB 证据 |
| **Git checkpoint 文件** | ✅ **主方案** | 每 Gate / 每步回传后更新，可 diff、可 PR |
| **Memory + checkpoint** | ✅ 最佳 | Memory 只记「feature + 当前 Phase + checkpoint 路径」 |

### 文件路径（强制）

```
docs/features/{feature_name}/session-checkpoint.md
```

与 `proposal.md` / `test-report-*.md` 同目录，**随功能走**，不放在 `.cursor/`。

### 何时更新

- 每个 **Gate 通过**（Gate 1 / Gate 2 / Phase 4 Ready / Push Gate）
- 每次执行结束 **追加** `handoff-to-coach.md` 中 `## 回传 {对话名}` 之后
- **P3 每批**完成后：同步 `pending-todos.md` 开放数到 checkpoint
- **trial-validation**：每 Phase AUDIT 后可在 checkpoint 记「最近 AUDIT 对话名」
- **长对话结束前**（关 IDE 前）

### checkpoint 必含字段

见 [coach-kickoff-template.md § 模板 J](./coach-kickoff-template.md#模板-j-session-checkpoint-更新)。

### 恢复流程（对话被删后）

1. Read `docs/features/{feature}/session-checkpoint.md`
2. 新开 **教练对话** `@agent-team-coach`，用 [模板 K 续接](./coach-kickoff-template.md#模板-k-从-checkpoint-恢复)
3. 教练根据 checkpoint 生成**下一对话名 + 提示词**，无需重跑已完成 Phase

---

## Case 2：迭代归档（下一版需求 / 功能交付后）

### 何时归档

- PR **已合并**主干，或
- 功能 **暂停**超过一个迭代，或
- 明确开启 **v2 拓展**（如 demo-feature 第二轮优化）

### 文件路径

```
docs/features/{feature_name}/archive/handoff-{YYYYMMDD}.md
```

同一功能多次迭代：`handoff-20260714.md`、`handoff-20260801-v2.md`。

### 归档必含（给下一轮 P1/P2 用）

| 章节 | 内容 |
|------|------|
| 交付摘要 | 合并 PR、commit range、上线环境 |
| Spec 锚点 | proposal/design/tasks/test-report 路径与 Gate 日期 |
| **Baseline** | 已实现能力清单（勿当新需求重做） |
| 已知遗留 | AC Blocked/Pending、`pending-todos.md` 未关闭项、联调未验、M6–L 级技术债 |
| 环境与数据 | test-env 要点、测试 CID、DDL 脚本路径 |
| 踩坑记录 | 如 D7 跨库事务、10002、Speed status=7 |
| 下一迭代建议 | in scope 草稿、勿动模块 |

### checkpoint vs archive

| | session-checkpoint.md | archive/handoff-*.md |
|---|----------------------|----------------------|
| 生命周期 | **进行中**，频繁改 | **阶段结束**，只追加新文件 |
| 读者 | 自己 + 教练续接 | 下一轮 @requirements-analyst / @architect |
| 是否删 | 归档后可删或改标题为「已归档，见 archive/」 | **永久保留** |

归档时：写 `handoff-{date}.md` → 将 checkpoint 顶部加一行 `已归档 → archive/handoff-{date}.md` → 可选删 checkpoint 或留最后一帧快照。

---

## Cursor Memory 使用边界（可选）

**适合写入 Memory（≤5 条/功能）：**

- `{project} 功能 {feature} 进度见 docs/features/{feature}/session-checkpoint.md`
- `{feature} 教练约定：权限校验用户自控，提示词忽略 @AccessRequire`
- `{feature} 当前 Phase：P6-S5，下一对话名 demo-feature-P6-S5-测试-TOB/TOC联调`

**不要写入 Memory：**

- 单测输出、traceId、applyInfoId、密码 token
- 完整提示词正文（放 checkpoint / coach-kickoff-template）
- 审查报告全文（放 test-report 或 PR）

---

## 跨项目复用

| 项目 | `docs/agent-team/` | 示例 feature |
|------|-------------------|--------------|
| project_pre-customer-info | 本文 + naming + coach-kickoff + delivery-boundary | example-app-demo-feature（v1 已归档） |
| **agent-team-kit** | **AgentTeam 标准源** | 本仓 |
| spring-ai-study | 验证仓（消费 kit） | 试跑产物在 `docs/features/` |
| project_pre-operations | 同名文件已同步 | task-center |

复制到新仓库：本文 + 模板 J/K/L + 每功能 `session-checkpoint.md`。

---

## 修订记录

| 日期 | 说明 |
|------|------|
| 2026-08-24 | 更新时机：Write `handoff-to-coach.md` 之后（不再写「把回传包贴给教练」） |
| 2026-07-17 | 增 pending-todos.md 与 P3 批次同步 checkpoint |
| 2026-07-14 | 初版：Case1 恢复 + Case2 归档 + Memory 边界 |
