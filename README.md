# 简单待办

一个面向 Windows 的桌面待办事项软件，使用 Python 和 Tkinter 开发。

## 第一版功能

- 添加、修改、完成和删除任务
- 设置任务日期和提醒时间
- 到点弹窗提醒
- 在本地自动保存任务
- 搜索任务，并按今天或完成状态筛选

## 运行方式

普通用户可以下载发布页面中的 `SimpleTodo.exe`，双击运行，无需安装 Python。

开发者可以使用 Python 3.12 运行：

```powershell
python main.py
```

## 数据位置

打包后的程序把任务保存在：

`%LOCALAPPDATA%\SimpleTodo\tasks.json`

## 后续计划

后续版本计划加入账号、云端同步和 Android 客户端，实现电脑与手机同步。
