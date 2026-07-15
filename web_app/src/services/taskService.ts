import { supabase } from './supabaseClient'
import type { NewTodoTask, TodoTask } from '../types/task'

export async function listTasks(): Promise<TodoTask[]> {
  const { data, error } = await supabase
    .from('tasks')
    .select('*')
    .order('created_at', { ascending: false })

  if (error) {
    throw error
  }

  return data ?? []
}

export async function addTask(task: NewTodoTask): Promise<TodoTask> {
  const {
    data: { session },
    error: sessionError,
  } = await supabase.auth.getSession()

  if (sessionError || !session?.user) {
    throw sessionError ?? new Error('登录状态已失效，请退出后重新登录')
  }

  const { data, error } = await supabase
    .from('tasks')
    .insert({
      user_id: session.user.id,
      title: task.title,
      due_at: task.due_at,
      reminder: task.reminder,
      completed: false,
      notified: false,
    })
    .select('*')
    .single()

  if (error) {
    throw error
  }

  return data
}

export async function toggleTask(task: TodoTask): Promise<TodoTask> {
  const { data, error } = await supabase
    .from('tasks')
    .update({ completed: !task.completed })
    .eq('id', task.id)
    .select('*')
    .single()

  if (error) {
    throw error
  }

  return data
}

export async function deleteTask(taskId: string): Promise<void> {
  const { error } = await supabase.from('tasks').delete().eq('id', taskId)

  if (error) {
    throw error
  }
}
