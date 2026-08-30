# AgentTeam 同步话术（复制即用）

> **标准源**：`<workspace>\agent-team-kit`  
> **原则**：流程文档以 kit 为准；`project-architecture.mdc` / `test-env.override.md` **各项目保留自有**，不覆盖。  
> **验证仓** `spring-ai-study` 只做试跑与适配样例，不再接收「标准文件」回流。

---

## 场景 1：业务/验证项目 → 回流 kit（最常用）

**何时用**：在业务仓或验证仓试跑中改进了 coach、Agent、delivery-boundary、P0 流程，要更新 `agent-team-kit`。

**新开 Agent 对话**，粘贴：

```text
【任务】AgentTeam 回流标准源（kit）
【源项目】<业务或验证项目路径>
【目标】<workspace>\agent-team-kit（标准源）

请把源项目中 AgentTeam 的优化同步到 kit，规则：

## 必须同步（覆盖目标）
- docs/agent-team/*.md（全文，含 scripts/；勿覆盖目标已删的项目专属 test-env.override.md）
- .cursor/agents/*.md

## 合并更新（不整文件覆盖）
- .cursor/rules/agent-team-paths.mdc → 合并通用项；保持「kit + code_root」表述

## 禁止覆盖（保留目标原有）
- docs/agent-team/test-env.override.example.md 可更新示例，但不要写入真实端口/库名
- 业务 pom / src
- VERSION（由维护者按发版规则改）

## 适配要求（写入 kit 时）
- Agent / 文档去项目化：包名、端口、模块名指向 code_root L2
- README / CHANGELOG 注明回流来源与日期
- 若有新增文档，更新 docs/agent-team/README 索引与 bootstrap-new-project

## 产出
1. 变更文件清单（源→目标）
2. 未同步项及原因
3. 建议 git commit message + 是否需要 bump tag（不自动 commit / tag）
```

---

## 场景 2：kit → 业务项目（新开或对齐）

**推荐**：改目标项目 `.code-workspace` 的 `agentTeam.version` → 跑 `Sync-AgentTeamWorkspace.ps1`（无需拷文件）。

**兼容 copy**（旧方式）时粘贴：

```text
【任务】AgentTeam 从 kit 部署到业务项目（兼容 copy）
【源】<workspace>\agent-team-kit
【目标】<目标项目绝对路径>

按 docs/agent-team/bootstrap-new-project.md 模式 B：

## 覆盖同步
- docs/agent-team/* → 目标（**test-env.override.md 不覆盖**）
- .cursor/agents/*
- agent-team-paths.mdc 合并

## 禁止覆盖
- project-architecture.mdc
- test-env.override.md 端口与库名

## 产出
1. 已同步列表
2. 验证：@agent-team-coach 可读 playbook
```

---

## 场景 3：业务项目 A → 业务项目 B（横向）

**优先**：两边都钉同一 kit tag，无需横向拷。  
若仍要横向 copy，只同步 AgentTeam 配置，不动业务代码；`test-env.override.md` 保留目标。

---

## 场景 4：验证仓试跑反馈 → kit（META-F）

`spring-ai-study` 等验证仓跑完 trial-validation 后，用 `@agent-team-maintainer` + META-F，把规范缺口合入 **kit 主仓**，再打 tag。
