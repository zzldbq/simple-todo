# Supabase 配置步骤

这份文档用于 Simple Todo v2.0。目标是让 Windows 和 Android 使用同一套云端账号与任务数据。

## 1. 创建 Supabase 项目

1. 打开 Supabase 官网并登录。
2. 创建新项目。
3. 项目名可以用：`simple-todo`
4. 数据库密码请自己保存，不要发到聊天里，也不要提交到 GitHub。
5. Region 选择离你更近的区域即可。

## 2. 创建任务表

进入 Supabase 项目后：

1. 打开 `SQL Editor`
2. 复制项目里的 SQL 文件内容：

   `supabase/schema.sql`

3. 粘贴并运行。

这个 SQL 会创建：

- `tasks` 表
- 用户只能访问自己任务的 RLS 安全策略
- 自动更新 `updated_at` 的触发器

## 3. 获取客户端配置

在 Supabase 项目里找到 API 设置，复制：

```text
Project URL
anon public key / publishable key
```

对应到本项目是：

```text
SUPABASE_URL=你的 Project URL
SUPABASE_ANON_KEY=你的 anon/publishable key
```

注意：

- 可以使用 `anon key` / `publishable key`
- 不要使用 `service_role key`
- 不要把真实 key 提交到 GitHub

## 4. 运行 Android App 时传入配置

在 `mobile_app` 目录运行：

```powershell
flutter run --dart-define=SUPABASE_URL=你的地址 --dart-define=SUPABASE_ANON_KEY=你的anon_key
```

如果只是构建 APK：

```powershell
flutter build apk --debug --dart-define=SUPABASE_URL=你的地址 --dart-define=SUPABASE_ANON_KEY=你的anon_key
```

## 5. 当前状态

手机端已经写好：

- Supabase 初始化
- 登录
- 注册
- 任务云端仓库代码骨架

还需要实测：

- 注册账号
- 登录账号
- 云端任务新增、完成、删除
- Windows 和 Android 双向同步
