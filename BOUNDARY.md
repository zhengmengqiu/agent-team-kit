# AgentTeam Kit · Phase 0 边界冻结

> **本文件是 Phase 0 的唯一验收物。** 只冻结「拆什么、不拆什么、仓库叫什么」。  
> 不包含：git init、推远程、打 tag、改 `spring-ai-study` 叙事、去项目化改写（那些是 Phase 1+）。

冻结日期：**2026-08-30**  
源仓：`D:\develop-project\spring-ai-study`（分支 `feature/agent-team-for-cursor`）

---

## 1. 仓库身份（已冻结）

| 项 | 取值 |
|----|------|
| 本地目录名 | `agent-team-kit` |
| 本地路径 | `D:\develop-project\agent-team-kit`（与验证仓同级） |
| GitHub owner | `zhengmengqiu`（与 `spring-ai-study` 同源） |
| GitHub 仓库全名 | `zhengmengqiu/agent-team-kit` |
| 可见性 | **private**（个人 kit，未对外发布；Phase 1 建仓时按此创建） |
| 历史策略 | **干净仓**，不迁 `spring-ai-study` 的 git 历史 |
| 首发 tag（Phase 1 打，此处只预告） | `v0.1.0` |
| 验证仓 | `spring-ai-study`（Phase 3 才改叙事；本阶段不改） |

远程 URL 预告：`git@github.com:zhengmengqiu/agent-team-kit.git`

---

## 2. 三根目录归属（已冻结）

| 根 | 拆分后落在哪 |
|----|----------------|
| **kit** | `agent-team-kit` |
| **workspace_docs** | 验证/业务仓（如 `spring-ai-study/docs/features/`） |
| **code_root** | 验证/业务仓（业务代码 + L2） |

kit **禁止**写入功能 spec（proposal / design / tasks / handoff / trial-log）。

---

## 3. 从源仓迁入 kit（文件级）

### 3.1 Agents（整目录）

| 源路径 | 进 kit |
|--------|--------|
| `.cursor/agents/agent-team-coach.md` | 是 |
| `.cursor/agents/agent-team-maintainer.md` | 是 |
| `.cursor/agents/requirement-input-prep.md` | 是 |
| `.cursor/agents/requirements-analyst.md` | 是 |
| `.cursor/agents/architect.md` | 是 |
| `.cursor/agents/backend-developer.md` | 是 |
| `.cursor/agents/tester.md` | 是 |
| `.cursor/agents/code-reviewer.md` | 是 |
| `.cursor/agents/frontend-developer.md` | **不存在，不创建**（server-only） |

### 3.2 通用规则

| 源路径 | 进 kit |
|--------|--------|
| `.cursor/rules/agent-team-paths.mdc` | 是 |

### 3.3 `docs/agent-team/` 流程文档

| 源路径 | 进 kit |
|--------|--------|
| `README.md` | 是 |
| `bootstrap-new-project.md` | 是 |
| `sync-prompts.md` | 是 |
| `coach-playbook.md` | 是 |
| `coach-kickoff-template.md` | 是 |
| `trial-run-guide.md` | 是 |
| `maintainer-templates.md` | 是 |
| `evolution-checkpoint.md` | 是 |
| `requirement-input-guide.md` | 是 |
| `delivery-boundary.md` | 是 |
| `workspace-layout.md` | 是 |
| `session-persistence.md` | 是 |
| `agent-dialog-naming.md` | 是 |
| `l0-parity-checklist.md` | 是 |
| `snippets/workspace-docs-paths.mdc` | 是 |
| `scripts/download-md-images.ps1` | 是 |

### 3.4 用户手册

| 源路径 | 进 kit |
|--------|--------|
| `使用手册/AgentTeam-快速上手.md` | 是 |
| `使用手册/AgentTeam-使用说明-明细版.md` | 是 |

### 3.5 骨架模板（源仓有、kit 只保留通用骨架）

| 源路径 | 进 kit 的形态 |
|--------|-------------|
| `docs/features/README.md` | **是**（仅目录约定骨架，不含任何 feature 子目录） |
| `docs/agent-team/test-env.override.md` | **否**（真实端口/库名留验证仓） |
| 同上 → kit 新文件 | Phase 1 新增 `docs/agent-team/test-env.override.example.md`（无真实环境） |

---

## 4. 明确不进 kit（留在 `spring-ai-study`）

| 源路径 | 原因 |
|--------|--------|
| `src/`、`pom.xml`、`mvnw*`、`.mvn/`、`target/` | 业务 / 构建 |
| `HELP.md` | Spring Initializr 项目说明 |
| `.gitignore` / `.gitattributes` | 验证仓自己的 git 配置 |
| `.idea/`、`.vscode/` | IDE |
| `.cursor/rules/project-architecture.mdc` | L2 架构 |
| `.cursor/rules/spring-boot.mdc` | 技术栈 |
| `.cursor/rules/java-standards.mdc` | 技术栈 |
| `.cursor/hooks/post-write-review.kiro.hook` | Java 写后走查，绑 code_root |
| `docs/features/admin-rbac-core/**` | 试跑产物 |
| `docs/features/spring-ai-single-chat/**` | 试跑产物 |
| `docs/干就完事/**`、`docs/原型设计/**` | 验证仓历史材料 |
| `docs/agent-team/test-env.override.md` | L2 真实环境 |
| `CLAUDE.md` | 验证仓入口；kit 在 Phase 1 自写一份，不拷这份 |

---

## 5. 灰区决议（已拍板，不再悬空）

| 项 | 决议 |
|----|------|
| GitHub 可见性 | **private** |
| `frontend-developer` | kit **不包含** |
| Cursor hooks | **不进 kit** |
| `docs/features/{feature}/` | **不进 kit** |
| `docs/features/README.md` | **进 kit**（骨架） |
| `使用手册/` | **进 kit** |
| 去项目化（去掉文案里的 `spring-ai-study` / `com.spring.study`） | **Phase 1**，不是 Phase 0 |
| `.code-workspace` + sync 脚本 | **Phase 2** 定协议；Phase 1 可先放空文件/脚本草稿，但不验收 |
| 改 `spring-ai-study` 自称「标准源」 | **Phase 3** |
| 业务仓 `project_pre-*` | 本拆分 **不改** 那些仓库 |

---

## 6. Phase 1 将新建（源仓没有，不算迁入）

这些不在源仓拷贝清单里，Phase 1 创建：

- `README.md`（kit 入口）
- `VERSION` / `CHANGELOG.md`
- `.gitignore`（kit 自己的）
- `docs/agent-team/test-env.override.example.md`

Phase 2 才验收：

- `scripts/Sync-AgentTeamWorkspace.ps1`
- `templates/project.code-workspace.template.json`

---

## 7. 本地目标形态（拆完后，供后续 Phase 对照）

```text
D:\develop-project\
  agent-team-kit\                 # kit 主仓（可写、打 tag）
  .agent-team-worktrees\        # 本地缓存，不进任何 git
    v0.1.0\
  spring-ai-study\              # 验证仓（code_root + workspace_docs）
```

`.agent-team-worktrees/` **不进** kit 仓、也不进验证仓 git。

---

## 8. Phase 0 验收清单

| # | 项 | 状态 |
|---|-----|------|
| 1 | 仓库名 `agent-team-kit` | 已冻结 |
| 2 | GitHub owner + 全名 | 已冻结 |
| 3 | 可见性 private | 已冻结 |
| 4 | 干净仓、不迁历史 | 已冻结 |
| 5 | 迁入：agents 8 个文件（无 frontend） | 已冻结 |
| 6 | 迁入：`agent-team-paths.mdc` | 已冻结 |
| 7 | 迁入：`docs/agent-team/` 流程文档（含 scripts/snippets） | 已冻结 |
| 8 | 迁入：使用手册 2 份 | 已冻结 |
| 9 | 迁入：`docs/features/README.md` 骨架 | 已冻结 |
| 10 | 不迁：业务代码、L2 rules、hooks、features 试跑、真实 test-env | 已冻结 |
| 11 | 灰区全部有决议 | 已冻结 |
| 12 | 后续 Phase 边界写清（1=建仓发版，2=工作区脚本，3=验证仓，4=叙事） | 已冻结 |

**符合率：12/12 → 进入下一阶段的门槛（≥90%）已满足。**

Phase 1 仍须你明确说「继续 Phase 1」后再做。
