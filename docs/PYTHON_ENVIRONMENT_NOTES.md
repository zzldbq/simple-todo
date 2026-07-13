# Python 环境记录与故障处理

## 背景

项目早期 Windows v1.0 打包时使用过 PyInstaller。PyInstaller 当时安装在项目旧虚拟环境中：

```text
C:\Users\zzl\Desktop\learning\simple-todo\venv\Scripts\pyinstaller.exe
```

但这个旧虚拟环境绑定的基础 Python 是：

```text
C:\Users\zzl\AppData\Local\Programs\Python\Python312\python.exe
```

后续检查发现该 Python 目录出现访问权限异常：

```text
Access is denied
```

因此旧虚拟环境里的 PyInstaller 仍然存在，但无法正常使用。

## 当前发现的 Python 环境

| 位置 | 状态 | 说明 |
|---|---|---|
| `D:\PY\python.exe` | 可运行，Python 3.11.4 | 用户电脑上较早已有的 Python |
| `C:\Users\zzl\AppData\Local\Programs\Python\Python312\python.exe` | 文件存在，但运行/访问目录时报 `Access is denied` | 旧 `venv` 依赖它，因此旧环境不可用 |
| `venv` | 旧虚拟环境，已安装 PyInstaller，但依赖不可访问的 Python 3.12 | 暂时保留，不继续依赖 |
| `venv311` | 新建虚拟环境，绑定 `D:\PY\python.exe` | 后续 Windows 打包建议使用它 |

## 为什么会出现两套 Python

Python 不是只能安装一份。常见情况是：

- 以前用户自己安装过一份 Python。
- 项目开发时又安装或使用了另一份 Python。
- PyCharm、命令行、虚拟环境可能各自指向不同 Python。
- PyInstaller、pip 包、虚拟环境都属于某一个具体 Python，不是所有 Python 共享。

所以会出现“以前明明能打包，现在却提示没有 PyInstaller”的情况：当前正在使用的 Python 环境和以前打包时的 Python 环境不是同一个。

## 可能原因

目前不能确定是哪一个操作导致了旧 Python 3.12 权限异常，但常见原因包括：

- Windows 目录权限或 ACL 被改动。
- 使用管理员/非管理员身份混装 Python。
- 安全软件或 Defender 限制了该目录。
- Python 安装/卸载过程异常。
- 系统清理、权限修复工具改动了 `AppData\Local\Programs` 下的权限。

## 解决方案

优先推荐：

1. 保留旧 `venv`，暂时不删除。
2. 使用当前可运行的 `D:\PY\python.exe` 创建新虚拟环境 `venv311`。
3. 在 `venv311` 中安装 PyInstaller。
4. 后续 Windows 打包统一使用 `venv311`。

不优先推荐直接修旧 Python 权限，因为这可能涉及 Windows 权限、安全软件、安装器状态，容易扩大问题。

## 以后如何避免

- 每个项目固定使用一个虚拟环境，不混用多个 Python。
- 在文档中记录“当前项目使用哪个 Python”和“打包用哪个虚拟环境”。
- 尽量不要手动移动或删除 Python 安装目录。
- 不要随意用系统清理工具处理 Python、venv、AppData 下的开发目录。
- 如果要升级 Python，优先新建虚拟环境，而不是原地改旧环境。
- 打包前运行：

```powershell
.\venv311\Scripts\python.exe --version
.\venv311\Scripts\python.exe -m pip show pyinstaller
```

确认当前使用的是预期环境。
