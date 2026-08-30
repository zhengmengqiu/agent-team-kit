# 交付边界：服务端 AgentTeam 与前端

> **用途**：明确 AgentTeam **交付什么 / 不交付什么**；前端材料作输入，不作本流程实现范围。  
> **标准源**：`agent-team-kit`。§2 模块表由 **code_root** 填写（见该项目 `project-architecture.mdc`）。  
> **关联**：[coach-kickoff-template.md § 模板 E](./coach-kickoff-template.md#template-e) · [requirement-input-guide.md](./requirement-input-guide.md)

---

## 1. 默认边界（所有项目通用）

| 交付物 | 本 AgentTeam | 说明 |
|--------|--------------|------|
| REST API | ✅ | 见 §2 本项目模块（code_root） |
| Domain / 数据模型 / 落库 | ✅ | 按项目分层 |
| proposal / design / tasks / test-report | ✅ | `docs/features/{feature}/` |
| Admin / App / H5 **前端页面** | ❌ | 独立前端团队或另开流程 |
| UI E2E / 浏览器自动化 | ❌ | P4 默认不做；见 §6 |

**原则**：考虑前端的**规则与可验收性**，不承担前端的**实现与视觉**。

---

## 2. code_root 模块（由目标项目填写）

默认占位（接入时按 L2 改成真实模块）：

| 模块 | 路径 / 说明 |
|------|-------------|
| Web API | 见 code_root `project-architecture.mdc` |
| 分层 | 见 code_root `project-architecture.mdc` |

**验证仓示例**（`spring-ai-study`，单模块）：Web API = `com.spring.study`；分层 adapter/web → application → domain → infrastructure。

教练 **模板 E** 默认写入 checkpoint「定制约定」。功能级例外在教练对话声明。

### 复制到多模块 Project_pre 项目时（参考）

| 模块 | 示例（project_pre-customer-info） |
|------|----------------------------|
| C 端 API | `project_pre-customer-info-server` |
| Admin API | `project_pre-customer-info-admin-server` |
| Domain | `project_pre-customer-info-domain` |

详见 [bootstrap-new-project.md](./bootstrap-new-project.md)。

---

## 3. AC 分层（P1 强制）

| 层级 | 标签 | 含义 | P4 验证 |
|------|------|------|---------|
| **Must** | `[Must]` | API / 规则 / 落库可验证 | `@tester` 必须测 |
| **UI-Ref** | `[UI-Ref]` | 来自截图/原型，服务端仅提供数据或开关 | **Blocked-待前端联调** |
| **Out-of-Scope** | `[Out-of-Scope]` | 非本团队交付 | 不写入 P3 tasks |

---

## 4. proposal 固定章节

```markdown
## 交付边界

| 模块 | 本 AgentTeam | 负责方 |
|------|--------------|--------|
| REST API | ✅ | backend（code_root） |
| 前端页面 / UI E2E | ❌ | [待确认：前端团队] |

**前端联调入口**：`design.md` API 契约 + `proposal.md` Must 级 AC。
```

---

## 5. design API 表扩展列（P2 强制）

| 列 | 说明 |
|----|------|
| **消费者** | `admin-fe` / `app` / `h5` / `internal` |
| **前端依赖** | 是 / 否 |

---

## 6. P4 测试边界

| 类型 | 报告写法 |
|------|----------|
| `[Must]` | Pass / Fail + 证据 |
| `[UI-Ref]` | **Blocked-待前端联调**（不算 Fail） |
| `[Out-of-Scope]` | Skip |
| **pending-todos 开放（L2/依赖）** | **Pending-待确认**（不算 Fail） |

Push Gate：**Must 级 AC 全 Pass** + **L1 / 阻塞上线待办已解决**；L2/依赖开放项可带 **Pending** 进 PR，须写入 test-report 与 `archive/handoff`。

---

## 7. 修订记录

| 日期 | 说明 |
|------|------|
| 2026-07-17 | Push Gate 对齐 L1/待办清单；L2/依赖可 Pending |
| 2026-07-16 | 从 project_pre-customer-info 迭代迁入；适配标准源仓库单模块 |
