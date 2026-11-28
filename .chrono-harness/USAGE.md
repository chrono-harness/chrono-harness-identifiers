# chrono-harness-identifiers 使用说明

组件的用途、开发仓库和示例见 [Chrono Harness 用户与开发者入口](https://github.com/chrono-harness/chrono-harness-main)。

标识符校验的现役实现和证明已迁入 runner。这里保留迁移中的证明调用方所用的历史版本。

开发分支为 `dev`。日常 PR 合入开发分支，正式版从 `main` 发布。

首次检出运行 `mise trust` 和 `mise run harness-setup`。本仓默认安装策略为 `pinned`。固定配方读取 [.config/mise/conf.d/chrono-harness.toml](../.config/mise/conf.d/chrono-harness.toml)。模板答案 `tool_versions` 可以为每个工具选择 stable、preview 或精确标签。临时运行 `CHRONO_TOOL_CHANNEL=preview mise run harness-setup` 会为已选组织工具安装各自最新测试版，也可以把 `preview` 换成 `stable` 或精确的 `v` 标签。再次运行普通安装即可恢复本仓选择。本仓的 macOS 证明工作流按登记使用固定 Verus 工具链。各分支、标签和 detached HEAD 使用相同规则。 可变通道的选版写入 `.chrono-harness/state/tool-selection/versions.toml`，由 `.config/mise/conf.d/selected-chrono-harness.toml` 提供给 mise。安装状态目录出现额外条目时，安装会报告路径并保留上次成功的选版。

开始任务时运行 `mise run harness-setup` 刷新根指南，成功后重新阅读本仓的 `AGENTS.md` 或 `CLAUDE.md`。完整规则和本仓开发步骤见根 [CLAUDE.md](../CLAUDE.md)。

用 `mise exec -- chrono-pr pr-reminders` 查看本地提醒，再运行 `mise exec -- chrono-pr pr-status --pr NUMBER --head-sha SHA` 查询 GitHub。

## 本仓验证

现役实现、原生测试和 Verus 证明在 [runner](https://github.com/chrono-harness/chrono-harness-runner) 维护。本仓保留的源码和测试位于 `crates/identifiers` 和 `crates/identifiers-tests`。在本仓运行 `mise exec -- ./check.sh` 构建、测试并验证当前检出。
