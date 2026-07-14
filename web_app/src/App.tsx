import { useEffect, useMemo, useState } from 'react'
import type { User } from '@supabase/supabase-js'
import './App.css'
import { getCurrentUser, signIn, signOut, signUp } from './services/authService'
import { addTask, deleteTask, listTasks, toggleTask } from './services/taskService'
import { isSupabaseConfigured } from './services/supabaseClient'
import type { TodoTask } from './types/task'

type AuthMode = 'login' | 'register'

function App() {
  const [user, setUser] = useState<User | null>(null)
  const [authMode, setAuthMode] = useState<AuthMode>('login')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [title, setTitle] = useState('')
  const [dueAt, setDueAt] = useState('')
  const [reminder, setReminder] = useState(false)
  const [tasks, setTasks] = useState<TodoTask[]>([])
  const [isAuthLoading, setIsAuthLoading] = useState(false)
  const [isRefreshing, setIsRefreshing] = useState(false)
  const [isAdding, setIsAdding] = useState(false)
  const [updatingTaskId, setUpdatingTaskId] = useState<string | null>(null)
  const [deletingTaskId, setDeletingTaskId] = useState<string | null>(null)
  const [message, setMessage] = useState('')

  const completedCount = useMemo(
    () => tasks.filter((task) => task.completed).length,
    [tasks],
  )

  useEffect(() => {
    getCurrentUser().then((currentUser) => {
      setUser(currentUser)
      if (currentUser) {
        refreshTasks()
      }
    })
  }, [])

  async function handleAuthSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setMessage('')

    if (!isSupabaseConfigured) {
      setMessage('尚未配置 Supabase，请先创建 web_app/.env')
      return
    }

    if (!email || !password) {
      setMessage('请填写邮箱和密码')
      return
    }

    setIsAuthLoading(true)
    try {
      const nextUser =
        authMode === 'login'
          ? await signIn(email, password)
          : await signUp(email, password)
      setUser(nextUser)
      setPassword('')
      setMessage(authMode === 'login' ? '登录成功' : '注册成功，可以开始同步任务')
      await refreshTasks()
    } catch (error) {
      setMessage(formatError(authMode === 'login' ? '登录失败' : '注册失败', error))
    } finally {
      setIsAuthLoading(false)
    }
  }

  async function refreshTasks() {
    setIsRefreshing(true)
    setMessage('')
    try {
      const nextTasks = await listTasks()
      setTasks(nextTasks)
      setMessage(`已刷新 ${nextTasks.length} 个任务`)
    } catch (error) {
      setMessage(formatError('任务加载失败', error))
    } finally {
      setIsRefreshing(false)
    }
  }

  async function handleAddTask(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const trimmedTitle = title.trim()

    if (!trimmedTitle) {
      setMessage('请先输入任务内容')
      return
    }

    setIsAdding(true)
    try {
      const task = await addTask({
        title: trimmedTitle,
        due_at: dueAt ? new Date(dueAt).toISOString() : null,
        reminder: reminder && Boolean(dueAt),
      })
      setTasks((current) => [task, ...current])
      setTitle('')
      setDueAt('')
      setReminder(false)
      setMessage('任务已添加')
    } catch (error) {
      setMessage(formatError('添加任务失败', error))
    } finally {
      setIsAdding(false)
    }
  }

  async function handleToggleTask(task: TodoTask) {
    setUpdatingTaskId(task.id)
    try {
      const updated = await toggleTask(task)
      setTasks((current) =>
        current.map((item) => (item.id === updated.id ? updated : item)),
      )
    } catch (error) {
      setMessage(formatError('更新任务失败', error))
    } finally {
      setUpdatingTaskId(null)
    }
  }

  async function handleDeleteTask(taskId: string) {
    setDeletingTaskId(taskId)
    try {
      await deleteTask(taskId)
      setTasks((current) => current.filter((task) => task.id !== taskId))
      setMessage('任务已删除')
    } catch (error) {
      setMessage(formatError('删除任务失败', error))
    } finally {
      setDeletingTaskId(null)
    }
  }

  async function handleSignOut() {
    await signOut()
    setUser(null)
    setTasks([])
    setMessage('已退出登录')
  }

  if (!user) {
    return (
      <main className="auth-page">
        <section className="auth-card">
          <p className="eyebrow">Simple Todo Web v3.0</p>
          <h1>{authMode === 'login' ? '登录' : '创建账号'}</h1>
          <p className="muted">用同一个账号同步 Windows、Android 和 Web 任务。</p>

          <form className="stack" onSubmit={handleAuthSubmit}>
            <label>
              邮箱
              <input
                value={email}
                onChange={(event) => setEmail(event.target.value)}
                type="email"
                placeholder="you@example.com"
              />
            </label>
            <label>
              密码
              <input
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                type="password"
                placeholder="请输入密码"
              />
            </label>
            <button disabled={isAuthLoading} type="submit">
              {isAuthLoading ? '处理中...' : authMode === 'login' ? '登录' : '注册'}
            </button>
          </form>

          <button
            className="link-button"
            onClick={() => setAuthMode(authMode === 'login' ? 'register' : 'login')}
            type="button"
          >
            {authMode === 'login' ? '还没有账号？创建账号' : '已有账号？返回登录'}
          </button>

          {message && <p className="message">{message}</p>}
        </section>
      </main>
    )
  }

  return (
    <main className="app-shell">
      <header className="topbar">
        <div>
          <p className="eyebrow">Simple Todo Web v3.0</p>
          <h1>简单待办</h1>
          <p className="muted">{user.email}</p>
        </div>
        <div className="topbar-actions">
          <button className="secondary" disabled={isRefreshing} onClick={refreshTasks}>
            {isRefreshing ? '刷新中...' : '刷新'}
          </button>
          <button className="secondary" onClick={handleSignOut}>
            退出
          </button>
        </div>
      </header>

      <section className="panel">
        <form className="task-form" onSubmit={handleAddTask}>
          <label className="title-input">
            新任务
            <input
              value={title}
              onChange={(event) => setTitle(event.target.value)}
              placeholder="输入新任务"
            />
          </label>
          <label>
            日期时间
            <input
              value={dueAt}
              onChange={(event) => setDueAt(event.target.value)}
              type="datetime-local"
            />
          </label>
          <label className="checkbox-row">
            <input
              checked={reminder}
              disabled={!dueAt}
              onChange={(event) => setReminder(event.target.checked)}
              type="checkbox"
            />
            提醒我
          </label>
          <button disabled={isAdding} type="submit">
            {isAdding ? '添加中...' : '添加任务'}
          </button>
        </form>
      </section>

      <section className="panel">
        <div className="section-title">
          <h2>我的任务</h2>
          <span>
            {tasks.length} 个任务 / {completedCount} 个已完成
          </span>
        </div>

        {message && <p className="message">{message}</p>}

        {tasks.length === 0 ? (
          <p className="empty">暂无任务。可以先在 Web、Windows 或 Android 添加一条。</p>
        ) : (
          <ul className="task-list">
            {tasks.map((task) => (
              <li className="task-item" key={task.id}>
                <button
                  aria-label={task.completed ? '标记未完成' : '标记完成'}
                  className="check-button"
                  disabled={updatingTaskId === task.id}
                  onClick={() => handleToggleTask(task)}
                  type="button"
                >
                  {task.completed ? '✓' : ''}
                </button>
                <div>
                  <p className={task.completed ? 'completed' : ''}>{task.title}</p>
                  <span>{formatDueAt(task.due_at)}</span>
                </div>
                <button
                  className="danger"
                  disabled={deletingTaskId === task.id}
                  onClick={() => handleDeleteTask(task.id)}
                  type="button"
                >
                  {deletingTaskId === task.id ? '删除中' : '删除'}
                </button>
              </li>
            ))}
          </ul>
        )}
      </section>
    </main>
  )
}

function formatDueAt(value: string | null) {
  if (!value) {
    return '无截止时间'
  }

  return new Date(value).toLocaleString('zh-CN', {
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
  })
}

function formatError(prefix: string, error: unknown) {
  if (error instanceof Error) {
    return `${prefix}：${error.message}`
  }
  return `${prefix}：请稍后再试`
}

export default App
