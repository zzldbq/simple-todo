# Simple Todo Web

这是 Simple Todo 的 v3.0 Web 版。

目标：让 Windows、Android、Web 使用同一个 Supabase 云端任务数据，并让 iPhone 可以先通过 Safari 浏览器使用。

## 技术栈

- React：页面 UI。
- Vite：本地开发与打包。
- TypeScript：类型检查。
- Supabase JS：登录和云端任务同步。

## 本地运行

先准备本地配置：

```text
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-publishable-or-anon-key
```

真实配置写到 `.env`，不要提交到 GitHub。

运行：

```powershell
npm install
npm run dev
```

构建检查：

```powershell
npm run lint
npm run build
```

## 部署

当前准备使用 GitHub Pages 部署。说明见：

```text
../docs/WEB_DEPLOYMENT.md
```
