import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  runApp(const SimpleTodoMobileApp());
}

class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('请填写邮箱和密码');
      return;
    }

    if (!SupabaseConfig.isConfigured) {
      _showMessage('尚未配置 Supabase，暂时无法真实登录');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('登录失败，请稍后再试');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: '登录',
      subtitle: '登录后可在电脑和手机同步任务',
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: '邮箱'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: '密码'),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _isLoading ? null : _login,
          child: Text(_isLoading ? '登录中...' : '登录'),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/register'),
          child: const Text('还没有账号？创建账号'),
        ),
      ],
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('请完整填写注册信息');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('两次密码不一致');
      return;
    }

    if (!SupabaseConfig.isConfigured) {
      _showMessage('尚未配置 Supabase，暂时无法真实注册');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      _showMessage('注册成功，请检查邮箱或直接登录');
      if (mounted) {
        Navigator.pop(context);
      }
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('注册失败，请稍后再试');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: '创建账号',
      subtitle: '之后会接入 Supabase 账号系统',
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: '邮箱'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: '密码'),
          obscureText: true,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _confirmPasswordController,
          decoration: const InputDecoration(labelText: '确认密码'),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _isLoading ? null : _register,
          child: Text(_isLoading ? '注册中...' : '注册'),
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

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  final TextEditingController _taskController = TextEditingController();
  final List<TodoTask> _tasks = [
    TodoTask('学习 Flutter 页面结构', '今天 20:00'),
    TodoTask('接入 Supabase 登录', '计划中'),
    TodoTask('测试电脑手机同步', '计划中'),
  ];

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _taskController.text.trim();
    if (title.isEmpty) {
      return;
    }

    setState(() {
      _tasks.insert(0, TodoTask(title, '未设置时间'));
      _taskController.clear();
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              labelText: '输入新任务',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _addTask(),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _addTask,
            icon: const Icon(Icons.add),
            label: const Text('添加任务'),
          ),
          const SizedBox(height: 24),
          Text(
            '我的任务',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (_tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Center(child: Text('暂无任务')),
            )
          else
            for (var index = 0; index < _tasks.length; index++)
              TaskItem(
                task: _tasks[index],
                onToggle: () => _toggleTask(index),
                onDelete: () => _deleteTask(index),
              ),
        ],
      ),
    );
  }
}

class TodoTask {
  TodoTask(this.title, this.time, {this.isDone = false});

  final String title;
  final String time;
  bool isDone;
}

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final TodoTask task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          onPressed: onToggle,
          icon: Icon(
            task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.time),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          tooltip: '删除',
        ),
      ),
    );
  }
}
