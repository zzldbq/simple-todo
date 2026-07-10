import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleTodoMobileApp());
}

class SimpleTodoMobileApp extends StatelessWidget {
  const SimpleTodoMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '简单待办',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F6BED)),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const TaskHomePage(),
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: '登录',
      subtitle: '登录后可在电脑和手机同步任务',
      children: [
        const TextField(
          decoration: InputDecoration(labelText: '邮箱'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(labelText: '密码'),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          child: const Text('登录'),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/register'),
          child: const Text('还没有账号？创建账号'),
        ),
      ],
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: '创建账号',
      subtitle: '之后会接入 Supabase 账号系统',
      children: [
        const TextField(
          decoration: InputDecoration(labelText: '邮箱'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(labelText: '密码'),
          obscureText: true,
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(labelText: '确认密码'),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          child: const Text('注册'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('返回登录'),
        ),
      ],
    );
  }
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(subtitle),
                  const SizedBox(height: 32),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskHomePage extends StatelessWidget {
  const TaskHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      const TaskItem('学习 Flutter 页面结构', '今天 20:00'),
      const TaskItem('接入 Supabase 登录', '计划中'),
      const TaskItem('测试电脑手机同步', '计划中'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('简单待办'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            icon: const Icon(Icons.logout),
            tooltip: '退出',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const TextField(
            decoration: InputDecoration(
              labelText: '输入新任务',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.add),
            label: const Text('添加任务'),
          ),
          const SizedBox(height: 24),
          Text(
            '我的任务',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...tasks,
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem(this.title, this.time, {super.key});

  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.radio_button_unchecked),
        title: Text(title),
        subtitle: Text(time),
      ),
    );
  }
}
