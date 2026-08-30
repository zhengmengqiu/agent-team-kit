# 工作区版本钉（消费 kit 的推荐方式）

白话：clone 都放在**本机工作目录**（例如 `D:\develop-project`）。在这个目录放一份 `.code-workspace`，写上 kit 版本号，跑一次 Sync，用 Cursor 打开这份文件。

**团队只认这一种放法**，避免有人放项目里、有人放父目录。

`.code-workspace` **不会**自己 `git checkout`。换版本靠 `scripts/Sync-AgentTeamWorkspace.ps1`。

---

## 放哪（唯一默认）

放在 **本机工作目录**（所有 git 仓的父目录），**不要**放进某个业务仓再提交。

```text
<工作目录>/                          # 例如 D:\develop-project
  develop-project.code-workspace    # 工作集（本机文件，不进业务 git）
  agent-team-kit/
  .agent-team-worktrees/
    v0.1.1/
  spring-ai-study/
  其他业务仓/
```

文件按工作目录命名（如 `develop-project.code-workspace`），不要用单个仓名。  
`folders` 里：第一项永远是 kit worktree；后面按这次要一起开的仓追加（一个或多个）。

一份工作区 **只钉一个** `agentTeam.version`。多仓协作共用这一版 kit。

### 补充（非团队默认）

只有「整台机器只开一个仓、旁边没有工作目录」时，可以把同一份模板拷进该仓根目录，并把相对路径改成 `../agent-team-kit`。团队协作不要用这种放法。

---

## 字段（冻结）

从 [templates/project.code-workspace.template.json](../../templates/project.code-workspace.template.json) 复制到**工作目录**。

| 字段 | 含义 | 工作目录下的示例 |
|------|------|------------------|
| `settings.agentTeam.version` | 锁定的 git tag | `v0.1.1` |
| `settings.agentTeam.kitRepo` | kit **主仓**（相对工作区文件） | `./agent-team-kit` |
| `settings.agentTeam.worktreesRoot` | worktree 缓存根 | `./.agent-team-worktrees` |
| kit 的 folder | `name` = `agent-team-kit@<version>` | `.agent-team-worktrees/v0.1.1` |
| 项目的 folder | 相对工作目录的仓路径 | `spring-ai-study` |

路径都相对 **`.code-workspace` 所在目录**。

---

## 日常

```powershell
# 在工作目录执行
.\agent-team-kit\scripts\Sync-AgentTeamWorkspace.ps1 -WorkspaceFile .\develop-project.code-workspace
```

然后用 Cursor 打开该 `.code-workspace`。换版本：改 `agentTeam.version` → 再 Sync → Reload Window。

改 kit 源码只在 `agent-team-kit` 主仓，再打 tag。worktree 当只读依赖。

---

## 验收

- [x] 模板按工作目录相对路径
- [x] 本机 `D:\develop-project\develop-project.code-workspace` 钉 `v0.1.1`
