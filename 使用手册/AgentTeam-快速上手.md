# AgentTeam 快速上手（5 分钟）

> 只想赶紧跑一个需求？照这份走。深入细节看 [`AgentTeam-使用说明-明细版.md`](./AgentTeam-使用说明-明细版.md)。

---

## 0. 一句话理解

| 角色 | @谁 | 干什么 | 在哪存档 |
|------|-----|--------|----------|
| **教练** | `@agent-team-coach` | 只导航：判阶段、给提示词、过 Gate | `docs/features/{功能}/session-checkpoint.md` |
| **执行** | analyst / architect / developer / tester / reviewer | 真正干活（写 spec、写代码、测试） | `docs/features/{功能}/` |
| **规范维护** | `@agent-team-maintainer` | 改 AgentTeam 本身（分轨、模板） | `docs/agent-team/evolution-checkpoint.md` |

**铁律**：教练对话只导航，不写代码；执行在你**另开的对话**里做；改规范用 maintainer，别和跑需求混在一起。

---

## 1. 标准流程（照抄）

```
① 开教练对话（整个需求只开一次）
      ↓  @agent-team-coach + 模板A → 教练做 Gate 0 判 simple/complex
② 教练给你【对话名】+ P1 提示词
      ↓  新开执行对话，粘贴 → @requirements-analyst 产出 proposal.md
③ Gate 1 你确认 → 回教练要 P2
      ↓  新开执行对话 → @architect 产出 design.md + tasks.md
④ Gate 2 你确认 → 回教练要 P3
      ↓  新开执行对话（分批）→ @backend-developer 写代码
⑤ P3 全部完成 → 教练出【P3-Q 待办确认问卷】→ 你逐条答
      ↓  → P4 @tester 测试 → P6 @code-reviewer 审查 → P7 提交
```

每完成一步：执行 Agent **Write** `docs/features/{功能}/handoff-to-coach.md`，窗口只出五行短报；回教练窗发「<对话名> 完成，读 handoff」（不要拷执行窗正文），再更新 checkpoint。

---

## 2. 第一条消息怎么发（复制改）

**新开对话 → 侧栏命名 `{项目名}-教练-{功能名}` → 粘贴：**

```text
@agent-team-coach

这是 AgentTeam 教练对话。只指导流程和提示词，不写代码、不产出 spec。

【项目】{code_root 项目名}
【功能】{功能名，如 admin-rbac-core}
【短名】{短名}
【性质】新功能 / bugfix / 迁移拓展
【当前】从 Phase 1 开始
【已有产出】docs/features/{功能名}/input/prd.md（若已有 input）

【需求要点】
1. <要点一>
2. <要点二>
3. <要点三>

【复杂度（可选）】小需求 → 请 Gate 0 checklist 判 simple|complex

【补充约定（模板 E）】
- 交付边界：仅后端 REST API，不交付前端页面与 UI E2E
- AC 分层：[Must] / [UI-Ref] / [Out-of-Scope]

请给我：
0. Gate 0 判轨 + 写入 session-checkpoint 的 track
1. 当前 Phase 判断
2. 是否新开执行对话
3. 带【对话名】的完整 P1 执行提示词（含 Write `handoff-to-coach.md` 要求）
```

之后每要下一步，用 **模板 B**：回教练窗发「<对话名> 完成，读 handoff」（不要拷执行窗正文）。

---

## 3. 两条分轨（教练用 Gate 0 自动判，你只需了解）

| | **Simple**（默认） | **Complex** |
|---|---|---|
| 何时 | 小需求、1～3 API、单模块 | Gate 0 checklist 命中 ≥2 项 |
| 额外产物 | 无 | P1 容量画像 / P2 场景推导 + 观测清单 |
| 你要做的 | 一样开教练，剩下教练带 | 一样，教练会多带 §11 章节 |

判轨结果写在 `docs/features/{功能}/session-checkpoint.md` 的 `track:` 字段。

---

## 4. 记住这几个 Gate（教练会主动问你）

| Gate | 时机 | 你做什么 |
|------|------|----------|
| **Gate 0** | 开需求时 | 确认 simple/complex |
| **Gate 1** | proposal 后 | 审 proposal，确认阻塞 P2 的开放问题 |
| **Gate 2** | design 后 | 审 design/tasks |
| **P3-Q** | P3 全部完成后 | 逐条答复待办清单（接受默认/改为/延后） |
| **Push Gate** | P7 前 | 测试 READY 才提交 |

---

## 5. 常见问题速答

- **执行对话被我删了？** → 教练用模板 K + Read checkpoint 恢复，按「下一对话名」重开。
- **我想自己控权限/边界？** → 开教练时用模板 E 声明一次，后续提示词自动省略。
- **要改 AgentTeam 规范本身？** → 别在教练对话改；开 `@agent-team-maintainer`。
- **完整模板在哪？** → `docs/agent-team/coach-kickoff-template.md`。
- **逐步 SOP 在哪？** → `docs/agent-team/coach-playbook.md`。

---

## 6. 现成可试跑的两个 mock 需求

| 需求 | 轨道 | input 路径 |
|------|------|-----------|
| Spring AI 单轮对话 | simple | `docs/features/spring-ai-single-chat/input/prd.md` |
| 后台 RBAC 核心 | complex | `docs/features/admin-rbac-core/input/prd.md` |

直接把上面第 2 节提示词的 `{功能名}` 换成对应名字即可开跑。
