# Changelog

## v0.1.1 — 2026-08-30

- 冻结工作区版本钉协议：`docs/agent-team/workspace-version-pin.md`
- 加固 `Sync-AgentTeamWorkspace.ps1`（按 name 识别 kit folder、fetch 失败回退本地 tag）

## v0.1.0 — 2026-08-30

- 从 `spring-ai-study` 抽离为独立 **agent-team-kit** 干净仓
- 确立消费方式：本地并列目录 + `.code-workspace` 版本钉 + git worktree
- 提供 `scripts/Sync-AgentTeamWorkspace.ps1`
- agents / 文档去项目化：L2（包名、端口、架构）由 code_root 提供
