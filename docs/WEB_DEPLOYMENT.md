# Simple Todo Web 部署说明

## 当前选择

v3.0 Web 版优先使用 GitHub Pages 部署。

GitHub Pages 是 GitHub 自带的静态网页托管服务，适合 React/Vite 这种前端项目。类似工具还有 Vercel、Netlify、Cloudflare Pages。

## 部署目标

部署后预计访问地址：

```text
https://zzldbq.github.io/simple-todo/
```

这个地址可以在 Windows、Mac、Android、iPhone 浏览器中打开。

## 使用的流程

项目中新增 GitHub Actions 工作流：

```text
.github/workflows/deploy-web.yml
```

它会在以下情况运行：

- 推送 `main` 分支且修改了 `web_app`。
- 手动在 GitHub Actions 页面点击运行。

工作流会执行：

1. 安装 Node 22。
2. 进入 `web_app`。
3. 执行 `npm ci`。
4. 执行 `npm run lint`。
5. 执行 `npm run build`。
6. 将 `web_app/dist` 发布到 GitHub Pages。

## 需要的 GitHub 变量

Web 版构建需要两个公开客户端配置：

```text
VITE_SUPABASE_URL
VITE_SUPABASE_ANON_KEY
```

它们不是 `service_role` 密钥，属于浏览器客户端可使用的配置。数据安全依赖 Supabase RLS。

## 注意事项

- 不要把真实 `.env` 提交到 GitHub。
- 不要把 Supabase `service_role key` 放进 Web 项目。
- 部署后如果登录跳转或邮箱确认链接异常，需要在 Supabase Auth 的 URL 配置中加入 GitHub Pages 地址。
