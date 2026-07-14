# Simple Todo v3.0 Web 版规划

## 定位

v3.0 定位为 Web 版 Simple Todo。

目标不是马上做 iPhone 原生 App，而是先做一个能在浏览器中使用的版本，让 iPhone、Mac、Windows、Android 都可以通过网页访问同一套任务数据。

## 核心目标

- Windows 版、Android 版、Web 版使用同一个 Supabase 项目。
- 三端登录同一个账号后，看到同一批任务。
- 三端都能新增、完成、删除和刷新任务。
- Web 版优先适配手机浏览器，特别是 iPhone Safari。
- 暂不依赖 Mac、Xcode、Apple Developer Program 或 TestFlight。

## 为什么先做 Web

iOS 原生 App 通常需要 Mac 和 Xcode，发布测试还会涉及 Apple Developer 账号、证书、签名和 TestFlight。当前用户有 iPhone，但 Mac 获取不方便，所以先用 Web 版覆盖苹果手机使用场景。

Web 版的优势：

- 不需要安装 App。
- 不需要 Mac。
- 不需要 App Store / TestFlight。
- iPhone 可以直接用 Safari 打开。
- 后续可以考虑做成 PWA，添加到主屏幕。

Web 版的限制：

- 系统通知能力不如原生 App 稳定。
- 后台运行能力有限。
- 某些手机浏览器权限和体验不如原生 App。

## 建议技术方案

优先考虑：

- 前端：React + Vite + TypeScript
- UI：普通 CSS 或轻量 UI 库
- 后端：继续使用 Supabase Auth + PostgreSQL
- 部署：先本地运行，后续可部署到 Vercel、Netlify、Cloudflare Pages 或 GitHub Pages

也可以考虑：

- Flutter Web：复用一部分 Flutter 思路，但 Web 包体可能较大。
- Vue + Vite：和 React 类似，也是常见 Web 前端方案。
- Next.js：更完整，但对当前项目可能偏重。

## v3.0 第一阶段功能

- 登录
- 注册或跳转已有注册流程
- 任务列表
- 添加任务
- 完成/未完成
- 删除任务
- 日期时间显示
- 手动刷新
- 与 Windows / Android 使用同一张 `tasks` 表

## 暂不放进第一阶段

- Web Push 到点通知
- 离线缓存
- 复杂冲突合并
- 多人协作
- iOS 原生 App
- App Store 发布

## 三端互联方式

```text
Windows 版 ─┐
Android 版 ─┼─ Supabase Auth + PostgreSQL tasks 表
Web 版     ─┘
```

三端不互相直连，都只连接 Supabase。

## v3.0 验收标准

1. 在电脑浏览器登录账号，能看到 Android/Windows 创建的任务。
2. 在 iPhone Safari 登录账号，能看到同一批任务。
3. 在 Web 版新增任务后，Android 点击刷新能看到。
4. 在 Windows 版新增任务后，Web 版刷新能看到。
5. Web 版不会暴露 service-role key，只使用 publishable/anon key，并依赖 RLS 保护数据。

## 与 iOS 原生 App 的关系

Web 版不是放弃 iOS 原生 App，而是降低第一步门槛。

未来如果有 Mac，可以再做：

- Flutter iOS 原生版
- TestFlight 测试
- App Store 发布

但在没有 Mac 的阶段，Web 版是最现实的苹果手机使用方案。
