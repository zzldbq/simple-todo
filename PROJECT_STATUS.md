# Simple Todo 项目状态

最后更新：2026-07-08（Asia/Shanghai）

## 项目目标

这是一个用于学习完整软件开发流程的项目。用户不打算手写代码，而是希望在指导下亲自完成环境配置、运行、测试、打包和发布。

最终目标：

- Windows 电脑端管理待办任务。
- Android 手机端管理同一批任务。
- 使用账号登录和云端数据库，实现电脑与手机同步。
- iPhone 版本以后再考虑；当前优先完成 Android。

## 已完成：v1.0.0

Windows 版使用 Python 3.12 和 Tkinter 开发，已实现：

- 添加任务。
- 编辑和删除任务。
- 标记完成/未完成。
- 可选日期、时间和提醒。
- 提醒时间格式与未来时间校验。
- 到点弹窗和提示音，约每秒检查一次。
- JSON 本地自动保存。
- 搜索任务。
- 按全部、今天、已完成筛选。
- 使用 PyInstaller 打包为单文件 EXE。

打包版任务数据位置：

`%LOCALAPPDATA%\SimpleTodo\tasks.json`

## 发布状态

- GitHub 仓库：https://github.com/zzldbq/simple-todo
- 正式版本：`v1.0.0`
- Release 已创建并附带 `SimpleTodo.exe`。
- 默认分支：`main`
- v1.0.0 标签已推送。

## 当前开发状态

- 当前本地开发分支：`develop-v2`
- `main` 和 `v1.0.0` 应保持稳定，不直接用于未完成的 2.0 开发。
- 2.0 尚未开始修改客户端业务代码。
- 已完成 v2.0 系统设计：`docs/V2_DESIGN.md`。
- 已准备 Supabase 数据库与 RLS 安全策略：`supabase/schema.sql`。
- 已创建 Windows 登录/注册界面原型：`login_preview.py`；目前仅做本地输入校验，尚未连接 Supabase。
- 当前使用流量网络，因此暂不下载 Flutter、Android Studio 或其他大型依赖。

## v2.0.0 计划

建议架构：

- 云端：Supabase
- 用户系统：Supabase Auth（邮箱和密码）
- 云数据库：Supabase PostgreSQL，启用 Row Level Security
- Android 客户端：Flutter
- Windows 客户端：保留现有 Python/Tkinter，再接入 Supabase

计划顺序：

1. 安装 Flutter SDK。
2. 安装 Android Studio 和 Android SDK；不安装模拟器，优先使用小米真机测试。
3. 在小米手机启用开发者选项和 USB 调试，并用 ADB 验证连接。
4. 创建 Flutter Android 项目。
5. 创建 Supabase 项目。
6. 在 Supabase 执行已准备的 `supabase/schema.sql`，检查任务表与安全策略。
7. 实现注册、登录和退出。
8. 实现 Android 端任务增删改查与云同步。
9. 让 Windows 版接入同一云端数据。
10. 测试电脑与手机双向同步。
11. 生成 APK 并发布 `v2.0.0`。

## 环境与路径

- 工作区：`C:\Users\zzl\Desktop\learning`
- 项目：`C:\Users\zzl\Desktop\learning\simple-todo`
- Python：`C:\Users\zzl\AppData\Local\Programs\Python\Python312\python.exe`
- PyCharm：`D:\PyCharm\PyCharm 2023.2.5`
- Python 虚拟环境：`C:\Users\zzl\Desktop\learning\simple-todo\venv`
- Windows EXE：`C:\Users\zzl\Desktop\learning\simple-todo\dist\SimpleTodo.exe`
- 计划将 Android 工具安装到：`D:\AndroidDev`

## 尚未安装

- Flutter SDK
- Dart（会随 Flutter 提供）
- Android Studio
- Android SDK / ADB

此前检查确认这些命令均不可用。曾准备下载 Flutter 3.44.4 稳定版，但用户当时使用流量网络并取消授权，因此下载和安装没有完成。等用户有 Wi-Fi 后再继续；预计下载数 GB。

## 重要约定

- 用户是初学者，说明应简单、清晰，不一次展开太多。
- 用户希望逐步体验完整流程，但不想手写代码；由 Codex 修改代码，用户负责运行和测试。
- 每完成一个功能，让用户亲自测试并反馈截图或结果。
- 从 2026-07-08 起，每完成一个实质步骤，都必须同步更新本文件，包括完成内容、当前状态、遇到的问题和下一步；在合适的节点将更新提交到 Git。
- 不在聊天中索取密码、验证码、GitHub Token 或 Supabase 密钥。
- 发布前先测试，再打包、打标签和创建 Release。
- 未来必须实现 Windows 与 Android 同步，这是核心目标，不要遗漏。

## 下次继续方式

新对话开始时先读取本文件，并检查 Git 当前分支和工作区状态。用户说“继续开发 2.0”后，从 Flutter 和 Android 开发环境安装开始。下载前确认用户已连接 Wi-Fi。

## 最近完成

- 2026-07-08：在不下载依赖的情况下完成 v2.0 架构、账号方案、同步规则、本地迁移策略与数据库安全设计。
- 2026-07-08：完成 Windows 登录/注册静态原型，可在登录与注册模式间切换，并检查必填项和两次密码是否一致。
- 2026-07-08：测试发现登录窗口缩小时会裁掉输入框和按钮；已将最小尺寸修正为 `920×620`，避免控件不可见。
- 2026-07-08：复测发现注册模式多一组确认密码输入框，`920×620` 仍会裁掉提交按钮；已按注册模式的实际高度调整为 `920×720`。

下一步：在 PyCharm 中运行并确认 `login_preview.py` 的布局；有 Wi-Fi 后安装 Flutter 和 Android 开发环境，并在创建 Supabase 项目后接入真实登录。
