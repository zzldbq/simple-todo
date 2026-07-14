# Simple Todo 项目状态

最后更新：2026-07-14（Asia/Shanghai）

## 新对话快速接续摘要

- 先读取本文件和 `docs/TOOLS.md`，再执行 `git status`。
- 当前发布分支是 `main`；`v2.0.0` 已发布。
- `v1.0.0` 和 `v2.0.0` 均已发布：https://github.com/zzldbq/simple-todo/releases
- 2.0 核心目标已完成：邮箱账号、Supabase 云端任务、Windows 与 Android 同步。
- v3.0 新定位：做 Web 版，让 Windows / Android / Web 三端互联，并让 iPhone 先通过浏览器使用。
- 已完成：架构文档、Supabase SQL/RLS、Windows 登录注册原型、云配置骨架、工具说明、Android 登录注册、Android 云同步、Android 日期时间保存、Windows/Android 双向同步、v2.0.0 发布。
- `login_preview.py` 已把最小尺寸调整为 `920×720`；Windows 登录注册原型尚未接入 Supabase。
- Flutter、Dart、Android Studio、Android SDK、ADB 已安装到 `D:\AndroidDev`，并通过 `flutter doctor` 的 Android toolchain 检查。
- 当前阶段状态：`v3.0.0` Web 版基础工程已创建，登录、注册、任务增删改查、完成/删除、手动刷新等首版代码已完成；用户已确认 Web 与 Android 同步测试成功。
- 用户不手写代码，希望亲自运行和测试；每个实质步骤更新本文件，并简要解释新工具及 2～4 个同类工具。
- 当前最合理的下一步：配置 GitHub Pages 与 GitHub Actions 变量，触发 Web 部署，获得可在 iPhone/Mac/Windows/Android 浏览器访问的网址。

## 项目目标

这是一个用于学习完整软件开发流程的项目。用户不打算手写代码，而是希望在指导下亲自完成环境配置、运行、测试、打包和发布。

最终目标：

- Windows 电脑端管理待办任务。
- Android 手机端管理同一批任务。
- 使用账号登录和云端数据库，实现电脑与手机同步。
- iPhone 原生版以后再考虑；v3.0 先做 Web 版，让 iPhone 可通过 Safari 使用。

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
- 正式版本：`v2.0.0`
- v1.0.0 Release 已创建并附带 `SimpleTodo.exe`。
- v2.0.0 Release 已创建并附带 `SimpleTodo-v2.0.0-windows.exe` 与 `SimpleTodo-v2.0.0-android-debug.apk`。
- 默认分支：`main`
- v1.0.0 与 v2.0.0 标签已推送。

## 当前开发状态

- 当前发布分支：`main`
- `v2.0.0` 已完成 Windows 与 Android 双向同步并发布。
- 2.0 已创建 Android 手机端 Flutter 项目，已完成登录/注册、任务增删改查、Supabase 云同步、日期时间与提醒开关保存、手机端手动刷新按钮；Windows 端已加入 Supabase 登录与任务同步入口，并已通过双向同步测试。
- v3.0 规划为 Web 版：`docs/V3_WEB_PLAN.md`，目标是 Windows / Android / Web 三端互联；基础工程已创建在 `web_app`。
- v3.0 Web 部署准备已开始，新增 GitHub Pages 工作流 `.github/workflows/deploy-web.yml` 和部署说明 `docs/WEB_DEPLOYMENT.md`。
- 已完成 v2.0 系统设计：`docs/V2_DESIGN.md`。
- 已准备 Supabase 数据库与 RLS 安全策略：`supabase/schema.sql`；另有开发期重建脚本 `supabase/reset_schema.sql`。
- 已创建 Windows 登录/注册界面原型：`login_preview.py`；目前仅做本地输入校验，尚未连接 Supabase。
- 已加入云端配置模板 `.env.example`、配置读取模块 `cloud_config.py`，并通过 `.gitignore` 排除真实 `.env`。
- 已整理项目从开始至今的工具与技术说明：`docs/TOOLS.md`，包含用途、项目角色和同类替代工具。
- Android 开发环境已完成：Flutter、Dart、Android Studio、Android SDK、ADB 均位于 D 盘。
- 已新增多端一致性与测试策略文档：`docs/MULTI_CLIENT_CONSISTENCY.md`。
- 已新增 Python 环境故障记录：`docs/PYTHON_ENVIRONMENT_NOTES.md`。旧 `venv` 中的 PyInstaller 仍存在，但旧环境绑定的 C 盘 Python 3.12 目录出现 `Access is denied`，后续 Windows 打包建议使用新建的 `venv311`。
- 当前用户已临时恢复网络并允许下载较大的依赖；如果之后又回到流量环境，超过约 100 MB 的下载仍应先提醒。

## v3.0.0 计划

定位：Web 版 Simple Todo，让 iPhone、Mac、Windows、Android 都能通过浏览器访问同一套 Supabase 云端任务。

建议顺序：

1. 确认 Web 技术方案，优先考虑 React + Vite + TypeScript。
2. 创建 Web 项目目录，例如 `web_app`。（已完成）
3. 接入 Supabase Auth。（已完成基础代码）
4. 实现任务列表、添加、完成、删除、手动刷新。（已完成基础代码）
5. 在 Windows 浏览器和 iPhone Safari 中测试。（下一步）
6. 部署到 Web 托管平台。
7. 验证 Windows / Android / Web 三端互联。

详细规划见：`docs/V3_WEB_PLAN.md`。

## v2.0.0 计划

建议架构：

- 云端：Supabase
- 用户系统：Supabase Auth（邮箱和密码）
- 云数据库：Supabase PostgreSQL，启用 Row Level Security
- Android 客户端：Flutter
- Windows 客户端：保留现有 Python/Tkinter，再接入 Supabase

计划顺序：

1. 安装 Flutter SDK。（已完成）
2. 安装 Android Studio 和 Android SDK；不安装模拟器，优先使用小米真机测试。（已完成）
3. 在小米手机启用开发者选项和 USB 调试，并用 ADB 验证连接。（手机暂不可连接，后续补做）
4. 创建 Flutter Android 项目。（已完成）
5. 创建 Supabase 项目。（已完成）
6. 在 Supabase 执行已准备的 `supabase/schema.sql`，检查任务表与安全策略。（已完成；必要时可用 `supabase/reset_schema.sql` 开发期重建表）
7. 实现注册、登录和退出。（Android 端已完成并测试成功）
8. 实现 Android 端任务增删改查与云同步。（已完成并测试成功；日期时间与提醒开关也能保存）
9. 让 Windows 版接入同一云端数据。（代码已完成，待用户用账号实测）
10. 测试电脑与手机双向同步。（待用户实测）
11. 生成 APK 并发布 `v2.0.0`。（已完成）

## 环境与路径

- 工作区：`C:\Users\zzl\Desktop\learning`
- 项目：`C:\Users\zzl\Desktop\learning\simple-todo`
- Python：`C:\Users\zzl\AppData\Local\Programs\Python\Python312\python.exe`
- PyCharm：`D:\PyCharm\PyCharm 2023.2.5`
- Python 虚拟环境：`C:\Users\zzl\Desktop\learning\simple-todo\venv`
- Windows EXE：`C:\Users\zzl\Desktop\learning\simple-todo\dist\SimpleTodo.exe`
- Android 工具根目录：`D:\AndroidDev`
- Flutter SDK：`D:\AndroidDev\flutter`
- Android Studio：`D:\AndroidDev\AndroidStudio`
- Android SDK：`D:\AndroidDev\AndroidSdk`
- Android NDK：`D:\AndroidDev\AndroidSdk\ndk\28.2.13676358`
- ADB：`D:\AndroidDev\AndroidSdk\platform-tools\adb.exe`
- Java / JDK：`D:\AndroidDev\AndroidStudio\jbr`
- Android 手机端项目：`C:\Users\zzl\Desktop\learning\simple-todo\mobile_app`
- Android 手机端入口：`C:\Users\zzl\Desktop\learning\simple-todo\mobile_app\lib\main.dart`
- Android debug APK：`C:\Users\zzl\Desktop\learning\simple-todo\mobile_app\build\app\outputs\flutter-apk\app-debug.apk`
- Web 端项目：`C:\Users\zzl\Desktop\learning\simple-todo\web_app`
- Web 端入口：`C:\Users\zzl\Desktop\learning\simple-todo\web_app\src\App.tsx`
- Web 端本地配置：`C:\Users\zzl\Desktop\learning\simple-todo\web_app\.env`（不提交）
- Web 端打包产物：`C:\Users\zzl\Desktop\learning\simple-todo\web_app\dist`

## Android 开发环境状态

Flutter 3.44.4 与 Dart 3.12.2 已安装到 `D:\AndroidDev\flutter`，并为当前用户配置 PATH、`PUB_HOSTED_URL=https://pub.flutter-io.cn` 和 `FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn`。安装时原始 Google 下载源过慢，切换到 Flutter 官方文档列出的 CFUG 镜像；一次并发残留导致压缩包校验失败，已删除损坏文件、完整重下，并通过官方 SHA-256 校验。首次运行时 GitHub 标签更新发生一次 SSL 超时，但 Flutter 与 Dart 版本验证成功。

Android Studio Quail 1（2026.1.1 Patch 2）安装包已完整下载到 `D:\AndroidDev\downloads\android-studio-quail1-patch2-windows.exe`，并通过 Google 公布的 SHA-256 校验。静默安装未成功，后由图形安装向导安装到 `D:\AndroidDev\AndroidStudio`。

Android SDK command line tools、`platform-tools`、`platforms;android-36`、`build-tools;36.0.0` 已安装到 `D:\AndroidDev\AndroidSdk`。已接受 Android SDK License。当前用户环境变量已配置 `ANDROID_HOME`、`ANDROID_SDK_ROOT`、`JAVA_HOME` 和相关 PATH。`flutter doctor -v` 显示 Android toolchain 通过；剩余的 Visual Studio 缺失只影响 Flutter Windows 桌面开发，当前 Android 阶段暂不处理。

Android APK 构建阶段已将 Gradle Wrapper 从 `gradle-9.1.0-all.zip` 改为更小的 `gradle-9.1.0-bin.zip`，并使用腾讯云 Gradle 镜像；Android Maven/Gradle 插件仓库优先使用阿里云镜像，官方源作为回退。构建时发现残缺 NDK 目录 `D:\AndroidDev\AndroidSdk\ndk\28.2.13676358`，已删除并用 `sdkmanager` 安装完整 NDK。构建还自动安装了 CMake 3.22.1。

## 重要约定

- 用户是初学者，说明应简单、清晰，不一次展开太多。
- 用户希望逐步体验完整流程，但不想手写代码；由 Codex 修改代码，用户负责运行和测试。
- 每当项目首次使用一个软件、框架、平台或开发工具时，先用初学者能理解的方式解释它是什么、在本项目中负责什么，并举出 2～4 个具有类似功能的替代工具；说明保持简短，不展开无关细节。
- 每完成一个功能，让用户亲自测试并反馈截图或结果。
- 从 2026-07-08 起，每完成一个实质步骤，都必须同步更新本文件，包括完成内容、当前状态、遇到的问题和下一步；在合适的节点将更新提交到 Git。
- 不在聊天中索取密码、验证码、GitHub Token 或 Supabase 密钥。
- 发布前先测试，再打包、打标签和创建 Release。
- 未来必须实现 Windows 与 Android 同步，这是核心目标，不要遗漏。
- 多端功能容易出现不一致，后续应参考 `docs/MULTI_CLIENT_CONSISTENCY.md` 维护功能对照表和自动化测试。
- Python/PyInstaller 相关环境问题参考 `docs/PYTHON_ENVIRONMENT_NOTES.md`；后续不要继续依赖旧 `venv` 打包。

## 下次继续方式

新对话开始时先读取本文件，并检查 Git 当前分支和工作区状态。`v2.0.0` 已发布：https://github.com/zzldbq/simple-todo/releases/tag/v2.0.0 。后续优先事项：Android 到点系统通知、正式签名 APK、自动化测试、Windows/Android 功能一致性。

## 最近完成

- 2026-07-14：准备 v3.0 Web 部署配置：新增 GitHub Pages 工作流 `.github/workflows/deploy-web.yml`，构建时使用 Node 22，发布 `web_app/dist`；新增 `docs/WEB_DEPLOYMENT.md`，记录部署目标、GitHub 变量和 Supabase 安全注意事项；`web_app/README.md` 已从 Vite 默认说明改为项目说明。
- 2026-07-14：用户确认 v3.0 Web 版与 Android 端同步测试成功；修复 Web 版勾选任务时“添加任务”按钮闪动的问题，原因是登录/刷新/添加/勾选/删除共用了一个全局 loading 状态，现已拆分为更细的操作状态；`npm run lint` 和 `npm run build` 已通过。
- 2026-07-14：创建 v3.0 Web 端 `web_app`，使用 React + Vite + TypeScript + Supabase JS；完成登录/注册、任务列表、添加任务、完成/未完成、删除、手动刷新、日期时间和提醒开关首版页面。已创建 `.env.example`，本地 `.env` 已写入 Supabase URL 与 publishable key 且不会提交。由于当前电脑 Node 为 `v21.7.1`，Vite 固定为 `5.4.21`，Supabase JS 固定为 `2.84.0`，避免最新版对 Node 22 的兼容警告；`npm run lint` 和 `npm run build` 已通过。
- 2026-07-14：用户确认 Windows 与 Android 双向同步测试成功；`main` 已快进合并 `develop-v2`，`v2.0.0` 标签已推送到 GitHub；已安装并登录 GitHub CLI，创建 GitHub Release `v2.0.0`，上传 `SimpleTodo-v2.0.0-windows.exe` 和 `SimpleTodo-v2.0.0-android-debug.apk`。Release 地址：https://github.com/zzldbq/simple-todo/releases/tag/v2.0.0
- 2026-07-14：确认 v3.0 定位为 Web 版，目标是让 Windows / Android / Web 使用同一个 Supabase 后端互联，并让 iPhone 先通过 Safari 使用；新增 `docs/V3_WEB_PLAN.md`。
- 2026-07-14：在不下载依赖的情况下细化 v3.0 Web 方案：确认 React + Vite + TypeScript + Supabase JS，不会阻碍后续 PWA、自动化测试、CI/CD 或 iOS 原生版；补充服务层、字段统一、页面草图和开发顺序，并将多端一致性文档扩展为 Windows / Android / Web 三端。
- 2026-07-13：Windows 端新增 Supabase REST/Auth 客户端 `cloud_tasks.py`，不引入第三方运行依赖；`main.py` 左侧新增云同步账号登录、刷新云端任务，并让添加/完成/删除/提醒状态保存同步到云端。Windows EXE 已用 `venv311` + PyInstaller 重新打包到 `dist\SimpleTodo.exe`。
- 2026-07-13：Android `pubspec.yaml` 版本号更新为 `2.0.0+2`，并重新构建 debug APK 到 `mobile_app\build\app\outputs\flutter-apk\app-debug.apk`。
- 2026-07-14：手机登录 Supabase 曾出现 `Connection timed out`，判断为网络访问 Supabase 偶发超时；已给登录/注册增加 15 秒超时和更短的中文网络错误提示，避免一直卡在“登录中”。同时 Android 任务页新增右上角刷新按钮和下拉刷新，方便拉取电脑端新增任务；`flutter analyze`、`flutter test`、APK 构建均通过。
- 2026-07-13：用户创建 Supabase 项目并完成 URL/key 配置；Android 端注册、登录、任务云同步测试成功。
- 2026-07-13：新增 `supabase/reset_schema.sql`，用于开发期重建 Supabase `tasks` 表，解决表字段或权限不完整导致的“任务加载失败/添加任务失败”问题。
- 2026-07-13：Android 端新增日期时间选择与提醒开关保存；`flutter analyze`、`flutter test` 和 APK 构建均通过；用户安装后测试成功。
- 2026-07-13：安装并确认 GitHub 插件可用，可用于查看 PR/Issue、检查 GitHub Actions/CI、创建 PR 和重新运行失败的 CI job。
- 2026-07-13：新增 `docs/MULTI_CLIENT_CONSISTENCY.md`，记录 Windows 与 Android 多端一致性风险、解决思路、测试策略和后续执行顺序。
- 2026-07-13：记录 Python 环境问题：v1.0 打包用过旧 `venv` 中的 PyInstaller，但旧环境依赖的 C 盘 Python 3.12 出现权限拒绝；已创建新 `venv311`，后续建议用它打包。
- 2026-07-08：在不下载依赖的情况下完成 v2.0 架构、账号方案、同步规则、本地迁移策略与数据库安全设计。
- 2026-07-08：完成 Windows 登录/注册静态原型，可在登录与注册模式间切换，并检查必填项和两次密码是否一致。
- 2026-07-08：测试发现登录窗口缩小时会裁掉输入框和按钮；已将最小尺寸修正为 `920×620`，避免控件不可见。
- 2026-07-08：复测发现注册模式多一组确认密码输入框，`920×620` 仍会裁掉提交按钮；已按注册模式的实际高度调整为 `920×720`。
- 2026-07-08：准备 Supabase 配置骨架并加入密钥防误传规则；尚未填写任何真实项目地址或密钥。
- 2026-07-08：完成工具与技术总览文档，区分已使用、已设计未接入、Android 计划工具和企业实践。
- 2026-07-08：在 D 盘安装 Flutter 3.44.4 和 Dart 3.12.2，配置 PATH 与 CFUG 镜像；未放入项目目录。
- 2026-07-09：Android Studio 官方安装包下载并校验完成；图形安装向导正在等待用户确认后继续。
- 2026-07-09：Android Studio 已安装到 `D:\AndroidDev\AndroidStudio`；Android SDK 与 ADB 已安装到 `D:\AndroidDev\AndroidSdk`；`flutter doctor -v` 的 Android toolchain 检查已通过，ADB 版本为 `37.0.0-14910828`。
- 2026-07-10：创建 Flutter Android 手机端项目 `mobile_app`，包名基础为 `com.zzldbq`，并将默认计数器页面替换为“简单待办”手机版首页雏形，包含标题、添加任务输入区和示例任务列表。
- 2026-07-10：手机端增加登录/注册/任务首页基础导航、本地任务增删改查、本地持久化保存、Supabase Auth 接入代码、Supabase 任务仓库骨架。
- 2026-07-12：已补跑 `dart format`、`flutter analyze`、`flutter test`，全部通过；已用镜像和完整 NDK/CMake 构建成功 Android debug APK，文件约 151 MB。

下一步：配置 GitHub Actions 变量 `VITE_SUPABASE_URL`、`VITE_SUPABASE_ANON_KEY`，启用 GitHub Pages 的 Actions 部署来源，触发部署并测试 `https://zzldbq.github.io/simple-todo/`。
