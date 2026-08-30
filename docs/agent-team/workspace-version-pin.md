# 工作区版本钉（消费 kit 的推荐方式）

白话目标：业务项目和 `agent-team-kit` 放在同一层目录。打开项目时用一份 `xxxx.code-workspace`。在工作区里写上 AgentTeam 的版本号，跑一次脚本，就能用上对应 tag，需要回调就改版本号再跑一次。

`.code-workspace` **不会**自己执行 `git checkout`。真正换版本靠本仓的 `scripts/Sync-AgentTeamWorkspace.ps1`。

---

## 1. 目录约定

```text
<同一父目录>/
  agent-team-kit/                 # kit 主仓（clone，用来 fetch / 打 tag）
  .agent-team-worktrees/        # 本地缓存，每个 tag 一份只读副本，不要当开发目录
    v0.1.0/
    v0.1.1/
  your-project/
    your-project.code-workspace
```

`.agent-team-worktrees/` 不进任何 git。多个项目可以共用同一份 worktree（同一 tag 只占一份磁盘）。

**不要**让两个工作区把「kit 主仓工作副本」钉成不同版本再互相 checkout，那会打架。所以 `folders` 必须指向 **worktree**，不要指向 `agent-team-kit` 主目录。

---

## 2. `.code-workspace` 字段（冻结）

从 [templates/project.code-workspace.template.json](../../templates/project.code-workspace.template.json) 复制后改项目名。

| 字段 | 必填 | 含义 | 示例 |
|------|------|------|------|
| `settings.agentTeam.version` | 是 | 要锁定的 **git tag** | `v0.1.0` |
| `settings.agentTeam.kitRepo` | 是 | 相对工作区文件的 kit **主仓**路径 | `../agent-team-kit` |
| `settings.agentTeam.worktreesRoot` | 是 | worktree 缓存根 | `../.agent-team-worktrees` |
| `folders[]` 中 kit 那一项 | 是 | `name` 为 `agent-team-kit@<version>`，`path` 指向对应 worktree | `../.agent-team-worktrees/v0.1.0` |
| `folders[]` 中项目那一项 | 是 | `path` 为 `.` | 业务仓根 |

路径都相对 **`.code-workspace` 所在目录**。

---

## 3. 日常怎么用

**第一次**

1. Clone `agent-team-kit` 到与项目同级。
2. 复制模板为 `{项目名}.code-workspace`。
3. 确认 `agentTeam.version`（例如 `v0.1.0`）。
4. 在项目目录执行：

```powershell
..\agent-team-kit\scripts\Sync-AgentTeamWorkspace.ps1 -WorkspaceFile .\your-project.code-workspace
```

5. 用 Cursor **打开该 `.code-workspace`**（多根：kit@版本 + 项目）。不要只开业务单仓。

**换版本 / 回调**

1. 只改 `settings.agentTeam.version`（例如改成 `v0.1.0`）。
2. 再跑同一条 Sync 命令。
3. 若 Cursor 已打开该工作区：**Reload Window**。

---

## 4. 脚本做什么

`scripts/Sync-AgentTeamWorkspace.ps1`：

1. 读上述三个 `agentTeam.*` 字段。
2. 在 kit 主仓 `git fetch --tags`（失败则用本地已有 tag）。
3. 没有 `{worktreesRoot}/{version}` 则 `git worktree add` 到该 tag。
4. 把 kit 那个 folder 的 `name` / `path` 改成该版本。

改 kit **源码**只在 `agent-team-kit` 主仓进行，再打新 tag。worktree 当依赖，不要在里面长期改文件。

---

## 5. 验收（Phase 2）

- [ ] 模板含三个 `agentTeam.*` 字段
- [ ] 对 `v0.1.0` 跑 Sync 能生成 `.agent-team-worktrees/v0.1.0`
- [x] 2026-08-30 已在本机验证：worktree 存在且可读 `.cursor/agents/agent-team-coach.md`
- [ ] 该目录下能读到 `.cursor/agents/agent-team-coach.md`
- [ ] 工作区 `folders` 的 kit 项 `name` 为 `agent-team-kit@v0.1.0`
