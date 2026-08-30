# 接入 AgentTeam（agent-team-kit）

> **标准源**：本仓库 `agent-team-kit`。  
> **推荐**：本地并列 + `.code-workspace` 钉版本（可随时回调 tag）。  
> **兼容**：整目录复制进业务仓（易漂移，仅过渡）。

---

## 模式 A（推荐）：工作区版本钉

### 1. 目录

```text
<workspace>/
  agent-team-kit/              # clone 本仓
  .agent-team-worktrees/       # sync 脚本生成，按 tag 只读依赖
  your-project/                # 业务或验证仓
    your-project.code-workspace
```

### 2. 创建工作区

复制 [templates/project.code-workspace.template.json](../../templates/project.code-workspace.template.json) 为 `your-project.code-workspace`：

```json
{
  "folders": [
    { "name": "agent-team-kit@v0.1.0", "path": "../.agent-team-worktrees/v0.1.0" },
    { "name": "your-project", "path": "." }
  ],
  "settings": {
    "agentTeam.kitRepo": "../agent-team-kit",
    "agentTeam.worktreesRoot": "../.agent-team-worktrees",
    "agentTeam.version": "v0.1.0"
  }
}
```

### 3. 同步版本

```powershell
..\agent-team-kit\scripts\Sync-AgentTeamWorkspace.ps1 -WorkspaceFile .\your-project.code-workspace
```

用 Cursor **打开 `.code-workspace`**（多根：kit worktree + 项目）。

### 4. code_root 必改（L2）

| 文件 | 改什么 |
|------|--------|
| `.cursor/rules/project-architecture.mdc` | 目标项目架构（勿从验证仓照抄） |
| `docs/agent-team/test-env.override.md` | 从 kit 的 `test-env.override.example.md` 复制后改端口/库名 |
| （可选）`CLAUDE.md` / README | 写明：打开工作区 → sync → 教练 |

### 5. 换版本 / 回调

1. 改 `settings.agentTeam.version`（如 `v0.1.0` → `v0.2.0`）  
2. 再跑 Sync 脚本  
3. Cursor Reload Window  

---

## 模式 B（兼容）：复制进业务仓

```text
agent-team-kit/
  .cursor/agents/          → 目标 .cursor/agents/
  .cursor/rules/agent-team-paths.mdc
  docs/agent-team/         → 目标（test-env 用 example → 改名为 override 并改写）
```

PowerShell 示例：

```powershell
$src = "<workspace>\agent-team-kit"
$target = "<workspace>\your-new-service"

Copy-Item "$src\.cursor\agents\*" "$target\.cursor\agents\" -Force
Copy-Item "$src\docs\agent-team\*" "$target\docs\agent-team\" -Recurse -Force
Copy-Item "$src\.cursor\rules\agent-team-paths.mdc" "$target\.cursor\rules\" -Force
# 删除误拷的 example 真覆盖前：把 example 复制为 test-env.override.md
```

**回流**：优化后合并回 **agent-team-kit**（见 [sync-prompts.md](./sync-prompts.md) 场景 1），不要回流到 `spring-ai-study`。

---

## 验证

- [ ] 打开工作区后 `@agent-team-coach` 能 Read kit 内 `coach-playbook.md`
- [ ] code_root 有 `project-architecture.mdc` 与 `test-env.override.md`
- [ ] `agentTeam.version` 与 worktree 目录一致

---

## 已用本体系的项目

| 项目 | 角色 | 备注 |
|------|------|------|
| spring-ai-study | **验证仓** | 工作区钉版本；不再是标准源 |
| project_pre-customer-info | 业务 | 可逐步从 copy 迁到工作区 |
| project_pre-operations | 业务 | 同上 |
