import { supabase } from './supabaseClient'

export async function getCurrentUser() {
  const { data, error } = await supabase.auth.getSession()
  if (error) {
    return null
  }
  return data.session?.user ?? null
}

export async function signIn(email: string, password: string) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })
  if (error) {
    throw error
  }

  if (!data.session || !data.user) {
    throw new Error('登录会话无效，请重新登录')
  }

  return data.user
}

export async function signUp(email: string, password: string) {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
  })
  if (error) {
    throw error
  }

  if (!data.session) {
    return null
  }

  return data.user
}

export async function signOut() {
  const { error } = await supabase.auth.signOut()
  if (error) {
    throw error
  }
}
