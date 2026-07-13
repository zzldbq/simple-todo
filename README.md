# 简单待办

一个跨 Windows 与 Android 的待办事项学习项目。

## 当前功能

- 添加、修改、完成和删除任务
- 设置任务日期和提醒时间
- 到点弹窗提醒
- 在本地自动保存任务
- 搜索任务，并按今天或完成状态筛选
- Android 端支持邮箱注册、登录和 Supabase 云同步
- Windows 端 v2 已加入 Supabase 登录与任务同步入口

## 运行方式

普通用户可以下载发布页面中的 `SimpleTodo.exe`，双击运行，无需安装 Python。

如果要启用 Windows 云同步，需要在 `SimpleTodo.exe` 同一目录放置 `.env` 文件：

```text
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_PUBLISHABLE_KEY=your-publishable-key
```

然后打开 Windows 版，在左下角输入邮箱和密码，点击“登录并同步”。

开发者可以使用 Python 运行：

```powershell
.\venv311\Scripts\python.exe main.py
```

## 数据位置

打包后的程序把任务保存在：

`%LOCALAPPDATA%\SimpleTodo\tasks.json`

## 后续计划

后续计划继续完善 Android 到点系统通知、自动化测试、正式安装包和发布流程。

## v2.0 开发文档

- Android 真机测试：`docs/ANDROID_TESTING.md`
- 多端一致性与测试策略：`docs/MULTI_CLIENT_CONSISTENCY.md`
- Python 环境记录：`docs/PYTHON_ENVIRONMENT_NOTES.md`
- Supabase 云端配置：`docs/SUPABASE_SETUP.md`
- 工具说明：`docs/TOOLS.md`
- v2.0 架构设计：`docs/V2_DESIGN.md`
