import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/todo_task.dart';
import 'repositories/memory_task_repository.dart';
import 'repositories/supabase_task_repository.dart';
import 'repositories/task_repository.dart';

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
  late final TaskRepository _taskRepository;
  List<TodoTask> _tasks = [];
  bool _isLoadingTasks = true;
  String? _taskError;

  @override
  void initState() {
    super.initState();
    final canUseSupabase = SupabaseConfig.isConfigured &&
        Supabase.instance.client.auth.currentUser != null;
    _taskRepository = canUseSupabase
        ? SupabaseTaskRepository(Supabase.instance.client)
        : MemoryTaskRepository();
    _loadTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _taskRepository.listTasks();
      if (!mounted) {
        return;
      }

      setState(() {
        _tasks = tasks;
        _taskError = null;
        _isLoadingTasks = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _taskError = '任务加载失败';
        _isLoadingTasks = false;
      });
    }
  }

  Future<void> _addTask() async {
    final title = _taskController.text.trim();
    if (title.isEmpty) {
      return;
    }

    try {
      final task = await _taskRepository.addTask(title);
      if (!mounted) {
        return;
      }

      setState(() => _tasks = [task, ..._tasks]);
      _taskController.clear();
    } catch (_) {
      _showTaskError('添加任务失败');
    }
  }

  Future<void> _toggleTask(TodoTask task) async {
    try {
      final updated = await _taskRepository.toggleTask(task);
      if (!mounted) {
        return;
      }

      setState(() {
        _tasks = [
          for (final item in _tasks) item.id == updated.id ? updated : item,
        ];
      });
    } catch (_) {
      _showTaskError('更新任务失败');
    }
  }

  Future<void> _deleteTask(TodoTask task) async {
    try {
      await _taskRepository.deleteTask(task);
      if (!mounted) {
        return;
      }

      setState(() {
        _tasks = [
          for (final item in _tasks)
            if (item.id != task.id) item,
        ];
      });
    } catch (_) {
      _showTaskError('删除任务失败');
    }
  }

  void _showTaskError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          if (_isLoadingTasks)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_taskError != null)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Center(child: Text(_taskError!)),
            )
          else if (_tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Center(child: Text('暂无任务')),
            )
          else
            for (final task in _tasks)
              TaskItem(
                task: task,
                onToggle: () => _toggleTask(task),
                onDelete: () => _deleteTask(task),
              ),
        ],
      ),
    );
  }
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
            task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.displayTime),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          tooltip: '删除',
        ),
      ),
    );
  }
}
