# Android 真机测试步骤

这份文档用于把 Simple Todo Android 版安装到安卓手机测试。

## 1. 当前 APK 位置

debug APK 已经构建成功：

```text
mobile_app/build/app/outputs/flutter-apk/app-debug.apk
```

完整路径：

```text
C:\Users\zzl\Desktop\learning\simple-todo\mobile_app\build\app\outputs\flutter-apk\app-debug.apk
```

## 2. 手机准备

在安卓手机上：

1. 打开设置。
2. 找到“关于手机”。
3. 连续点击“版本号”或“系统版本”多次，开启开发者选项。
4. 返回设置，进入“开发者选项”。
5. 开启 `USB 调试`。

不同品牌位置略有不同，小米、OPPO、vivo、荣耀、三星都大致类似。

## 3. 连接电脑

1. 用数据线连接手机和电脑。
2. 手机弹出“是否允许 USB 调试”时，点允许。
3. 最好勾选“始终允许这台电脑”。

## 4. 验证 ADB 是否识别手机

在电脑终端运行：

```powershell
adb devices
```

如果成功，会看到类似：

```text
设备序列号    device
```

如果显示 `unauthorized`，说明手机上还没有点允许。

## 5. 安装 APK

进入项目目录后运行：

```powershell
adb install -r mobile_app/build/app/outputs/flutter-apk/app-debug.apk
```

说明：

- `install` 是安装 APK
- `-r` 是覆盖安装已有版本

## 6. 当前 APK 的限制

这个 APK 是 debug 版本：

- 适合自己测试
- 不适合正式发布给大量用户
- 体积会比正式 release 包大

后续正式发布时再构建 release APK，并考虑签名。
