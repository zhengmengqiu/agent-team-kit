# AgentTeam 工作区三根目录

> **本仓是纯 kit。** `workspace_docs` 与 `code_root` 在业务/验证仓。  
> 路径规则：`.cursor/rules/agent-team-paths.mdc`。

---

## 1. 三根定义

| 根 | 放什么 |
|----|--------|
| **kit** | playbook、agents、Gate（`.cursor/agents/`、`docs/agent-team/`、`.cursor/rules/agent-team-paths.mdc`） |
| **workspace_docs** | proposal / design / tasks / todos / checkpoint / **handoff**（`docs/features/{feature}/`） |
| **code_root** | 业务代码 + L2（`project-architecture.mdc`、`test-env.override.md`） |

本 kit 仓只有 kit 根。spec 与业务代码不写进本仓。

---

## 2. spec 路径

```text
{workspace_docs}/docs/features/{feature}/
```

多产品工作区才加 `{product}`：

```text
{workspace_docs}/docs/features/{product}/{feature}/
```

本模板仓默认不加 `{product}`。`{product}` 仅作「多产品时加一层目录」的抽象例子（如 `trade` / `research`），不是本仓业务名。

`workspace_docs` 解析（命中即停，见 `agent-team-paths.mdc`）：

1. 模板 A / `session-checkpoint.md` 已写 `workspace_docs`（可选 `target_product`）
2. 工作区存在名为 `*-docs` 的 folder
3. 否则：当前仓库根（单仓退化）

---

## 3. 禁止

- spec **禁止**写入纯 kit（不要把 proposal/design/handoff 写进只含 playbook/agents 的目录）
- spec **禁止** `.dev-flow/`
- 以后若做多仓，spec 写 `{工作区名}-docs`，不写进纯 kit

---

## 4. feature 文件名

| 文件 | 用途 |
|------|------|
| `proposal.md` | P1 需求 |
| `design.md` | P2 设计 |
| `tasks.md` | P2 任务拆分 |
| `pending-todos.md` | P2 后待办 |
| `session-checkpoint.md` | 会话存档 |
| `handoff-to-coach.md` | 执行结束回传教练（模板 D；覆盖写；聊天只出 D-人读） |

---

## 5. bootstrap 模式

| 模式 | 说明 |
|------|------|
| **工作区版本钉（推荐）** | 并列目录 + `.code-workspace` 钉 tag。见 [workspace-version-pin.md](./workspace-version-pin.md)。 |
| **A 兼容 copy** | 把 agents / docs 复制进业务仓。易漂移，仅过渡。 |
| **B 货架 kit + 工作区 docs** | 一份 kit + 独立 `{名}-docs`。spec 写在 `*-docs`。 |

模式 B 给将来多仓用。复制到 `*-docs` 的路径规则片段见 [snippets/workspace-docs-paths.mdc](./snippets/workspace-docs-paths.mdc)。**不要**在 L0 写入任何公司磁盘路径。

---

## 修订记录

| 日期 | 说明 |
|------|------|
| 2026-08-30 | 推荐消费方式改为工作区版本钉 |
| 2026-08-24 | 初版：三根目录 + 单仓退化 + `handoff-to-coach.md` |
