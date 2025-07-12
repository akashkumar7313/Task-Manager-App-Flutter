import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/src/cubit/home%20/home_cubit.dart';
import 'package:task_manager_app/src/cubit/home%20/home_state.dart';
import 'package:task_manager_app/src/widgets/task_card.dart';
import 'package:task_manager_app/src/widgets/custom_loader.dart';
import 'package:task_manager_app/src/services/TaskStorageService.dart';
import 'package:task_manager_app/src/screens/add_task_screen.dart';
import 'package:task_manager_app/src/screens/login_screen.dart';
import 'package:task_manager_app/src/screens/task_details_screen.dart';
import 'package:task_manager_app/src/cubit/theme/theme_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  Future<void> _logout(BuildContext context, HomeCubit cubit) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontSize: 16),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await cubit.clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => HomeCubit(TaskStorageService())..fetchTasks(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.isLoading) {
            CustomLoader.show(context);
          } else {
            CustomLoader.hide(context);
          }
          if (state.error != null) {
            _showError(context, state.error!);
          }
        },
        builder: (context, state) {
          final isDark = context.watch<ThemeCubit>().state;
          final cubit = context.read<HomeCubit>();

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.black),
              titleTextStyle: const TextStyle(color: Colors.black),
              foregroundColor: isDark ? Colors.white : Colors.black,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Task Manager",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "Manage your daily goals",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 12),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.light_mode, color: Colors.amber),
                      BlocBuilder<ThemeCubit, bool>(
                        builder: (context, isDarkMode) {
                          return Switch(
                            value: isDarkMode,
                            onChanged: context.read<ThemeCubit>().toggleTheme,
                            activeColor: Colors.white,
                            inactiveThumbColor: Colors.black,
                          );
                        },
                      ),
                      const Icon(Icons.dark_mode, color: Colors.deepPurple),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  tooltip: "Logout",
                  onPressed: () => _logout(context, cubit),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await cubit.fetchTasks();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () async {
                      CustomLoader.show(context);
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailsScreen(task: task),
                        ),
                      );
                      CustomLoader.hide(context);
                      if (result == true) {
                        await cubit.fetchTasks();
                      }
                    },
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final newTask = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                );
                if (newTask != null) {
                  await cubit.addTask(newTask);
                  await cubit.fetchTasks();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
