# AgentTeam 标准源文档（agent-team-kit）

> **本仓库是 AgentTeam 的标准源（kit）。**  
> 业务/验证项目用 **本机工作目录的 `.code-workspace` 钉 tag** 接入；把文件拷进业务仓仅作兼容，不是默认。  
> 最新迭代：**2026-08-30**（kickoff 派工 + handoff 按对话名追加；工作区版本钉）。

---

## 文档索引

| 文档 | 用途 |
|------|------|
| **[bootstrap-new-project.md](./bootstrap-new-project.md)** | **接入新项目**（工作区钉版本 · 兼容 copy） |
| **[sync-prompts.md](./sync-prompts.md)** | **跨项目同步话术**（回流 kit / 横向） |
| **[workspace-version-pin.md](./workspace-version-pin.md)** | **工作区钉版本协议**（字段 + Sync 脚本） |
| **[workspace-layout.md](./workspace-layout.md)** | **三根目录** kit / workspace_docs / code_root |
| **[coach-playbook.md](./coach-playbook.md)** | 逐步 SOP |
| **[trial-run-guide.md](./trial-run-guide.md)** | 试跑 SOP |
| **[maintainer-templates.md](./maintainer-templates.md)** | Meta 维护 META-A～F |
| **[evolution-checkpoint.md](./evolution-checkpoint.md)** | 规范演进存档 |
| **[requirement-input-guide.md](./requirement-input-guide.md)** | 需求输入 |
| **[delivery-boundary.md](./delivery-boundary.md)** | 服务端 vs 前端 |
| [coach-kickoff-template.md](./coach-kickoff-template.md) | 可复制模板 |
| [test-env.override.example.md](./test-env.override.example.md) | L2 环境模板（复制到 code_root） |
| [l0-parity-checklist.md](./l0-parity-checklist.md) | L0 语义核对 |

根目录：[README.md](../../README.md) · [scripts/Sync-AgentTeamWorkspace.ps1](../../scripts/Sync-AgentTeamWorkspace.ps1)

---

## 相关路径

| 类型 | 路径 |
|------|------|
| 功能 spec | `{workspace_docs}/docs/features/{feature_name}/` |
| Agent 定义 | kit `.cursor/agents/` |
| 路径规则 | kit `.cursor/rules/agent-team-paths.mdc` |
| 架构（L2） | code_root `.cursor/rules/project-architecture.mdc` |

---

## 快速开始（验证 / 业务仓）

1. Clone `agent-team-kit` 与业务仓到同级目录  
2. 复制 `templates/project.code-workspace.template.json` → `{project}.code-workspace`  
3. 设置 `agentTeam.version`（如 `v0.1.0`）→ 跑 `Sync-AgentTeamWorkspace.ps1`  
4. Cursor 打开该工作区 → `@agent-team-coach`

**改 AgentTeam 规范**：在 kit 主仓 `@agent-team-maintainer` → 打新 tag。

---

## 阶段速查

| Phase | Agent | 产出 |
|-------|-------|------|
| **0** | `@requirement-input-prep` | `input/` + 整理报告 |
| 1 | `@requirements-analyst` | `proposal.md` |
| 2 | `@architect` | `design.md` + `tasks.md` |
| 3~5 | `@backend-developer` | 代码 |
| 4 | `@tester` | `test-report-{date}.md` |
| 6 | `@code-reviewer` | 审查报告 |
