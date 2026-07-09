# Simple Todo 工具与技术说明

## 一、已经使用

### Python

- 是什么：通用编程语言。
- 项目作用：实现任务管理、时间校验、提醒、本地保存等逻辑。
- 同类工具：Java、C#、JavaScript、Go。

### PyCharm

- 是什么：Python 集成开发环境（IDE）。
- 项目作用：查看代码、选择解释器、运行和调试程序。
- 同类工具：VS Code、Visual Studio、Spyder。

### venv

- 是什么：Python 自带的虚拟环境工具。
- 项目作用：为项目隔离 Python 和第三方依赖，避免与其他项目冲突。
- 同类工具：Conda、Poetry、uv virtual environment。

### pip

- 是什么：Python 软件包安装工具。
- 项目作用：在项目虚拟环境中安装 PyInstaller 等依赖。
- 同类工具：Conda、Poetry、uv。

### Tkinter

- 是什么：Python 自带的桌面图形界面（GUI）框架。
- 项目作用：创建 Windows 窗口、按钮、输入框、任务列表和弹窗。
- 同类工具：PySide/PyQt、wxPython、Kivy、C# WPF。

### JSON

- 是什么：一种常见的文本数据格式，不是数据库软件。
- 项目作用：v1.0 在本机的 `tasks.json` 中保存任务。
- 同类方案：SQLite、YAML、CSV、正式数据库。

### PyInstaller

- 是什么：Python 应用打包工具。
- 项目作用：将 Python、Tkinter、代码和依赖封装成 `SimpleTodo.exe`，让未安装 Python 的电脑也能运行。
- 同类工具：Nuitka、cx_Freeze、Briefcase。

### Git

- 是什么：分布式版本控制工具。
- 项目作用：记录代码历史、创建分支和标签、恢复旧版本。
- 同类工具：Mercurial、Subversion；企业中 Git 最主流。

### GitHub

- 是什么：在线代码托管与协作平台。
- 项目作用：保存公开源码、展示项目，并协助版本发布。
- 同类工具：GitLab、Bitbucket、Gitee。

### GitHub Releases

- 是什么：GitHub 的软件版本发布功能。
- 项目作用：发布 `v1.0.0` 并提供 `SimpleTodo.exe` 下载。
- 同类方案：自建官网、Microsoft Store、对象存储、其他应用商店。

### Git Credential Manager

- 是什么：Git 的安全账号授权工具。
- 项目作用：通过浏览器授权 GitHub 推送，避免使用已被 GitHub 停止支持的账号密码推送。
- 同类方案：SSH Key、Personal Access Token、GitHub CLI 登录。

### PowerShell

- 是什么：Windows 命令行和自动化环境。
- 项目作用：检查安装、运行 Git、安装依赖和执行打包命令。
- 同类工具：命令提示符、Bash、Windows Terminal（终端外壳）。

### Markdown

- 是什么：轻量文本标记格式。
- 项目作用：编写 `README.md`、设计文档和项目状态文档。
- 同类工具：纯文本、AsciiDoc、Word；Markdown 更适合代码项目。

### `.gitignore`

- 是什么：Git 的忽略规则文件，不是独立软件。
- 项目作用：阻止 `venv`、`.idea`、`tasks.json`、`.env` 和打包临时文件被提交。
- 同类方案：Git 的本地 exclude 或全局 ignore；项目通常使用 `.gitignore`。

### `.env` 与环境变量

- 是什么：将运行配置与源码分离的常见方式。
- 项目作用：以后保存 Supabase URL 和客户端 publishable key，真实 `.env` 不上传 GitHub。
- 同类方案：系统环境变量、配置文件、云端 Secret Manager。

### Figma / Axure（仅讨论，尚未接入项目）

- Figma：偏视觉界面设计和协作；同类工具有 Sketch、Adobe XD、即时设计。
- Axure：偏复杂交互和业务原型；同类工具有 ProtoPie、Justinmind、墨刀。
- 与 Tkinter/Flutter 的区别：它们主要产出设计稿或原型，不是最终运行程序。

## 二、已经设计，尚未联网接入

### Supabase

- 是什么：提供账号、PostgreSQL 数据库和 API 的云后端平台。
- 项目作用：v2.0 负责注册登录、云端任务和电脑手机同步。
- 同类工具：Firebase、Appwrite、PocketBase、自建后端。

### PostgreSQL

- 是什么：企业常用的关系型数据库。
- 项目作用：存储用户的云端任务；Supabase 底层使用它。
- 同类工具：MySQL、SQL Server、SQLite、MongoDB（非关系型）。

### Supabase Auth

- 是什么：Supabase 的用户认证服务。
- 项目作用：实现邮箱密码注册、登录、退出和会话管理。
- 同类工具：Firebase Authentication、Auth0、Clerk、自建认证系统。

### Row Level Security（RLS）

- 是什么：PostgreSQL 的行级数据权限机制，不是独立软件。
- 项目作用：保证每个用户只能读写自己的任务。
- 同类方案：后端 API 权限校验、数据库视图与权限、应用层访问控制。

## 三、Android 阶段工具

### Flutter

- 是什么：Google 推出的跨平台 UI 应用框架。
- 项目作用：用一套主要代码开发 Android 客户端，未来也可复用到 iOS；已安装到 `D:\AndroidDev\flutter`。
- 同类工具：React Native、.NET MAUI、Kotlin Multiplatform、原生 Kotlin/Swift。

### Dart

- 是什么：Flutter 使用的编程语言，会随 Flutter SDK 提供。
- 项目作用：编写 Android 客户端的界面和业务逻辑；已随 Flutter 安装。
- 同类语言：Kotlin、Swift、TypeScript、C#。

### Android Studio

- 是什么：Google 官方 Android 集成开发环境。
- 项目作用：提供 Android SDK 管理、项目检查、设备调试和打包支持；已安装到 `D:\AndroidDev\AndroidStudio`。
- 同类工具：IntelliJ IDEA、VS Code；开发 Android 仍需 Android SDK。

### Android SDK

- 是什么：Android 官方开发工具与系统 API 集合。
- 项目作用：编译、调试并生成手机可安装的 APK；已安装到 `D:\AndroidDev\AndroidSdk`。
- 同类方案：没有完全等价替代品；所有正规 Android 工具最终都依赖它。

### ADB

- 是什么：Android Debug Bridge，Android 设备调试命令工具。
- 项目作用：确认小米手机连接、安装测试 APK、读取调试信息；已随 Android SDK 安装。
- 同类方式：Android Studio 图形设备管理；底层仍通常调用 ADB。

### sdkmanager

- 是什么：Android SDK 的命令行包管理器。
- 项目作用：下载并管理 `platform-tools`、Android 平台和 build-tools。
- 同类工具：Xcode Components、Visual Studio Installer、包管理器如 npm/pip（概念类似）。

## 四、计划加入的企业实践

### 自动化测试

- 是什么：由程序自动验证功能是否正确。
- 项目计划：测试日期校验、任务数据和同步规则。
- 同类工具：Python `unittest`、pytest；Flutter 自带 test 框架。

### 代码审查 / Pull Request

- 是什么：合并代码前检查正确性、可读性与安全性。
- 项目计划：在 `develop-v2` 完成阶段功能后，通过 GitHub Pull Request 合并。
- 同类平台：GitLab Merge Request、Bitbucket Pull Request、Gerrit。

### CI/CD

- 是什么：服务器自动测试、构建和发布软件。
- 项目计划：使用 GitHub Actions 自动测试，之后尝试构建 EXE 或 APK。
- 同类工具：GitLab CI、Jenkins、Azure Pipelines、CircleCI。

### 日志与错误监控

- 是什么：记录运行过程，并收集崩溃或异常。
- 项目计划：先加入本地日志；在线错误监控以后考虑。
- 同类工具：Python logging、Sentry、Firebase Crashlytics、Datadog。

### 正式安装包和数字签名

- 是什么：安装包负责安装、快捷方式和卸载；数字签名证明发布者身份和文件完整性。
- 项目计划：先制作 Windows 安装包，付费数字签名以后考虑。
- 同类工具：Inno Setup、NSIS、WiX Toolset；签名使用代码签名证书和 SignTool。

### 多套环境

- 是什么：分离开发、测试和正式用户的数据与配置。
- 项目计划：至少建立开发与生产两套配置。
- 同类方案：`.env.development` / `.env.production`、不同云项目、容器或云 Secret 管理。
