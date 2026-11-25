# chrono-identifiers

标识符校验的现役实现、原生测试和 Verus 证明已迁入 runner。新变更在 runner 提交。本仓保留历史固定提交，供尚在迁移的证明脚本读取。

[runner 中的实现](https://github.com/chrono-harness/chrono-harness-runner/blob/1c17a7639ed81db63d34e088668b6930fe6a0b19/crates/runner/src/verified_identifiers.rs) · [迁移计划](https://github.com/chrono-harness/chrono-harness-runner/issues/1)

运行 `VERUS=/path/to/verus ./check.sh` 构建并测试此库，执行生产和测试中的全部 Verus 证明。工具版本见 `rust-toolchain.toml` 与检查脚本。检查正常结束或命令失败时均清理编译和验证产物。Git 关联工作树中的检查将临时目录放在该树的 `target/check.*` 下；进程被强制终止后，残留随任务工作树退役。长期主检出、源码归档和已有 target 符号链接的检出使用系统临时目录，其保留期限由系统或运行环境负责。历史版本可按原仓库 URL 和提交 SHA 获取。

源码和测试取自 [ChronoAIProject/chrono-harness 的固定提交](https://github.com/ChronoAIProject/chrono-harness/tree/7e99515590402f83c6b0931d8e37242dc32faf0d/crates/identifiers)。
