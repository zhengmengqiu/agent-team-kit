# 功能 Spec 目录

按 **AgentTeam** 约定，每个功能一个子目录（写在 **workspace_docs / code_root**，**不要**写进纯 kit）：

```
docs/features/{feature_name}/
  input/                         # P0：prd.md、images/、prototype/ 等
  proposal.md
  design.md
  tasks.md
  session-checkpoint.md          # 进行中必维护
  pending-todos.md               # P2 后：L2/依赖/联调待办，P3 持续补全
  handoff-to-coach.md            # 执行结束回传教练（模板 D；覆盖写）
  test-report-YYYYMMDD.md
  archive/handoff-YYYYMMDD.md    # 迭代结束后
```

流程见 [`docs/agent-team/README.md`](../agent-team/README.md)。  
**不要**把正式 spec 写入 `.dev-flow/`。
