export type TodoTask = {
  id: string
  user_id: string
  title: string
  due_at: string | null
  reminder: boolean
  completed: boolean
  notified: boolean
  created_at: string
  updated_at: string
}

export type NewTodoTask = {
  title: string
  due_at: string | null
  reminder: boolean
}
