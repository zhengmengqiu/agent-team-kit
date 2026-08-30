# 测试环境覆盖（示例 · 复制到 code_root）

> **用法**：复制本文件到 **code_root** 的 `docs/agent-team/test-env.override.md`，再改端口 / 库名 / MCP 名。  
> **本文件在 kit 仓仅作模板**；真实覆盖不进 kit。  
> **不含账号密码。** 本地密钥：`test-env.override.local.md`（建议 gitignore）或 `~/.cursor/skills/project_pre-dev-api-auth/env/dev.local.md`

```yaml
# 单模块 Spring Boot 示例
app_base: http://localhost:8080

# 若拆出 Admin 模块，再填；当前可与 app_base 相同
admin_base: http://localhost:8080

# MySQL（按需；未接库可留空）
mysql_default_db: <your_db>
mysql_mcp_server: <按本机 Cursor MCP 名填写，无则忽略>

# 多模块 Project_pre 项目示例：
# admin_base: http://localhost:6054/customer-info-admin-server
# app_base: http://localhost:6053/customer-info-server
# mysql_default_db: project_pre_customer
# mysql_mcp_server: user-MySQL_project_pre
```

## 本地微调（可选）

复制为 `test-env.override.local.md`，只写需覆盖的字段。

## API 认证

| 场景 | 做法 |
|------|------|
| 学习/demo 单模块 | **api-tester MCP** 直接打 `app_base` |
| Project_pre 多模块 | Read **project_pre-dev-api-auth** Skill + 共享 `dev.local.md` |

## 数据源

按 `mysql_mcp_server` / design.md 标注；未配置 MCP 时 **AskUserQuestion 一次**，禁止猜库名。
