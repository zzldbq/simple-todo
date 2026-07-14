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

这些工具都是企业真实会使用的技术：

- React：常见前端 UI 框架。
- Vite：现代前端开发和构建工具，适合新项目。
- TypeScript：企业前端常用，用类型减少低级错误。
- Supabase JS：Supabase 官方 JavaScript 客户端。
- Vercel / Netlify / Cloudflare Pages / GitHub Pages：常见 Web 托管平台。

也可以考虑：

- Flutter Web：复用一部分 Flutter 思路，但 Web 包体可能较大。
- Vue + Vite：和 React 类似，也是常见 Web 前端方案。
- Next.js：更完整，但对当前项目可能偏重。

## 后续可扩展性原则

v3.0 的技术选择不能只满足当前页面能跑，还要避免影响后续开发。当前方案不会阻碍后续功能，但实现时要遵守几个原则。

### 1. Supabase 操作集中到服务层

不要把数据库读写散落在页面组件里。建议结构：

```text
web_app/
  src/
    services/
      authService.ts
      taskService.ts
    types/
      task.ts
    pages/
    components/
```

页面只负责展示和交互，具体登录、读取任务、添加任务、删除任务都放到 `services` 中。

好处：

- 以后换后端时，主要改服务层。
- 以后加缓存、错误处理、自动刷新时更容易。
- 自动化测试更好写。

### 2. 三端字段必须统一

Web 版继续使用 Supabase `tasks` 表，不新建另一套字段。

统一字段：

| 字段 | 含义 | Web 版处理 |
|---|---|---|
| `id` | 任务 ID | 读取并作为列表 key |
| `user_id` | 用户 ID | 由 Supabase 登录用户决定 |
| `title` | 任务内容 | 必填，不能为空 |
| `due_at` | 日期时间 | 使用 ISO 时间，展示时转成本地时间 |
| `reminder` | 是否提醒 | 第一阶段保存开关，不做 Web Push |
| `completed` | 是否完成 | 支持切换 |
| `notified` | 是否已提醒 | 第一阶段保持兼容 |
| `created_at` | 创建时间 | 用于排序 |
| `updated_at` | 更新时间 | 后续冲突处理会用到 |

### 3. 部署平台先不绑定死

第一阶段只保证本地运行。部署时再从以下平台中选择：

- Vercel
- Netlify
- Cloudflare Pages
- GitHub Pages

这样不会因为一开始选错平台而影响开发。

### 4. 预留 PWA 和测试能力

v3.0 第一阶段不做 PWA，但目录和构建方式要保留后续能力：

- PWA：以后可添加到 iPhone 主屏幕。
- 单元测试：可用 Vitest。
- 浏览器端到端测试：可用 Playwright。
- CI/CD：可用 GitHub Actions 自动构建和部署。

### 5. 环境变量只放公开客户端配置

Web 版只使用：

```text
VITE_SUPABASE_URL
VITE_SUPABASE_ANON_KEY
```

这些是客户端可公开配置。绝对不要在 Web 代码里放 `service_role key`。

真正的数据安全继续依赖 Supabase RLS。

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

## 页面草图

第一阶段页面保持简单：

```text
┌────────────────────────────┐
│ 简单待办                 退出 │
├────────────────────────────┤
│ 登录邮箱 / 当前账号          │
├────────────────────────────┤
│ [输入新任务.............]    │
│ [选择日期时间] [提醒我]      │
│ [添加任务]                  │
├────────────────────────────┤
│ 我的任务              [刷新] │
│ □ 学习 Web 版               │
│   07-14 20:00 / 未完成       │
│ ✓ 已完成任务                │
└────────────────────────────┘
```

先适配手机窄屏，再兼容电脑宽屏。

## 开发顺序

在流量网络下，先做不需要下载依赖的设计文档。等可以下载依赖后再开始创建项目。

建议步骤：

1. 创建 `web_app`。（已完成）
2. 安装 React + Vite + TypeScript。（已完成）
3. 安装 Supabase JS。（已完成）
4. 建立 `task.ts` 类型。（已完成）
5. 建立 `authService.ts` 和 `taskService.ts`。（已完成）
6. 实现登录页。（已完成首版）
7. 实现任务页。（已完成首版）
8. 在电脑浏览器测试。（下一步）
9. 在 iPhone Safari 测试。
10. 部署到公开网址。

## 当前实现状态（2026-07-14）

`web_app` 已创建并完成首版页面：

- 登录 / 注册 / 退出。
- 读取云端任务。
- 添加任务。
- 任务完成 / 未完成切换。
- 删除任务。
- 日期时间输入与展示。
- 提醒开关保存。
- 手动刷新。

当前依赖版本：

- React `19.2.7`
- Vite `5.4.21`
- TypeScript `5.9.3`
- Supabase JS `2.84.0`

版本选择说明：当前电脑 Node 是 `v21.7.1`，不是长期支持版。Vite 和 Supabase 最新版本更偏向 Node 22，所以本项目先固定到能稳定构建的版本。后续做 CI/CD 或长期 Web 开发时，建议安装 Node 22 LTS。

已验证命令：

```text
npm run lint
npm run build
```

下一步是本地运行：

```text
cd web_app
npm run dev
```

然后在浏览器打开 Vite 给出的本地地址，使用和 Android/Windows 相同的 Supabase 账号登录测试。

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
