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
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatelessWidget {
  const TodoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const SizedBox(height: 24),
              const _AddTaskCard(),
              const SizedBox(height: 24),
              Text(
                '我的任务',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              const Expanded(
                child: _TaskPreviewList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white),
        ),
        const SizedBox(width: 14),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '简单待办',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 4),
            Text(
              '未来会和电脑端同步',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ],
    );
  }
}

class _AddTaskCard extends StatelessWidget {
  const _AddTaskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: '输入新任务...',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.calendar_today_outlined),
                label: const Text('日期'),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.notifications_none_rounded),
                label: const Text('提醒'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: null,
                child: const Text('添加'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskPreviewList extends StatelessWidget {
  const _TaskPreviewList();

  @override
  Widget build(BuildContext context) {
    final tasks = [
      ('学习 Flutter 项目结构', '今天 20:00'),
      ('连接 Supabase 云端', '稍后完成'),
      ('测试电脑和手机同步', '计划中'),
    ];

    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const Icon(Icons.radio_button_unchecked, color: Color(0xFF4F6BED)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.$1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.$2,
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
