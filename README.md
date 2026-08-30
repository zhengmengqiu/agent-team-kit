# AgentTeam Kit

独立的 **AgentTeam** 标准源仓库（playbook / agents / Gate）。  
业务项目与验证项目（如 `spring-ai-study`）通过本地并列目录 + `.code-workspace` **钉版本**消费本仓，不再把本流程绑在某个业务模板仓里。

## 快速使用

1. Clone 本仓到本机工作目录（与业务仓同级），例如 `D:\develop-project\agent-team-kit`。
2. 把 [templates/project.code-workspace.template.json](templates/project.code-workspace.template.json) 复制到**工作目录**，改名为工作目录名（如 `develop-project.code-workspace`），补上要打开的仓。
3. 同步：
   ```powershell
   .\agent-team-kit\scripts\Sync-AgentTeamWorkspace.ps1 -WorkspaceFile .\develop-project.code-workspace
   ```
4. 用 Cursor **打开该 `.code-workspace`**，再 `@agent-team-coach`。

换版本：改 `settings.agentTeam.version` → 再跑 sync → Reload Window。

## 目录要点

| 路径 | 说明 |
|------|------|
| `.cursor/agents/` | 教练 / 分阶段 Agent |
| `docs/agent-team/` | playbook、bootstrap、试跑、维护模板 |
| `scripts/Sync-AgentTeamWorkspace.ps1` | 版本钉 → git worktree |
| `BOUNDARY.md` | 迁入/不迁入边界 |
| `VERSION` | 当前发布版本号 |

L2（`project-architecture.mdc`、真实 `test-env.override.md`、业务代码）留在 **code_root**，见 `docs/agent-team/test-env.override.example.md`。

## 改规范

在 **本仓主工作副本**上改，勿在 `.agent-team-worktrees/*` 长期开发。  
用 `@agent-team-maintainer` → 更新 CHANGELOG → `git tag vX.Y.Z` → push。

## 文档入口

- [docs/agent-team/README.md](docs/agent-team/README.md)
- [docs/agent-team/bootstrap-new-project.md](docs/agent-team/bootstrap-new-project.md)
- [使用手册/AgentTeam-快速上手.md](使用手册/AgentTeam-快速上手.md)
