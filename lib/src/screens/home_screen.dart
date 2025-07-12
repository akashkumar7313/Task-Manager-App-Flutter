import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager_app/src/logic/theme/theme_cubit.dart';
import 'package:task_manager_app/src/screens/add_task_screen.dart';
import 'package:task_manager_app/src/screens/login_screen.dart';
import 'package:task_manager_app/src/screens/task_details_screen.dart';
import 'package:task_manager_app/src/services/TaskStorageService.dart';
import 'package:task_manager_app/src/widgets/custom_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _loadLocalTasks();
  }

  Future<void> _fetchTasks() async {
    Future.delayed(Duration.zero, () {
      if (mounted) CustomLoader.show(context);
    });

    try {
      List<Map<String, dynamic>> tasks = await TaskStorageService.loadTasks();

      if (tasks.isEmpty) {
        final response = await http.get(Uri.parse('http://jsonplaceholder.typicode.com/todos'));
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          tasks = data.cast<Map<String, dynamic>>();
          await TaskStorageService.saveTasks(tasks);
           _loadLocalTasks();
        } else {
          _showError("Failed to load tasks - ${response.statusCode}");
          return;
        }
      }

      tasks.sort((a, b) => a['completed'] == b['completed'] ? 0 : (a['completed'] ? 1 : -1));
      setState(() => _tasks = tasks);
    } catch (e) {
      _showError("Something went wrong: $e");
    } finally {
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) CustomLoader.hide(context);
      });
    }
  }

  void _loadLocalTasks() async {
    final localTasks = await TaskStorageService.loadTasks();

    print("Loaded tasks from storage: $localTasks");

    localTasks.sort((a, b) {
      // Prioritize local + pending > remote + pending > completed
      bool aIsPending = !(a['completed'] as bool);
      bool bIsPending = !(b['completed'] as bool);

      bool aIsLocal = a['isLocal'] == true;
      bool bIsLocal = b['isLocal'] == true;

      if (aIsPending && bIsPending) {
        if (aIsLocal && !bIsLocal) return -1;
        if (!aIsLocal && bIsLocal) return 1;
      }

      if (aIsPending && !bIsPending) return -1;
      if (!aIsPending && bIsPending) return 1;

      return 0;
    });

    setState(() {
      _tasks = localTasks;
    });
  }



  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to logout?", style: TextStyle(fontSize: 16)),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // dismiss the dialog
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context); // close dialog
                await TaskStorageService.clearUserSession(); // clear session

                if (!mounted) return;

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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    final isDark = context.watch<ThemeCubit>().state;

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
                  fontWeight: FontWeight.bold, fontSize: 22
              ),
            ),

            Text(
              "Manage your daily goals",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
              ),
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
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchTasks();
           _loadLocalTasks();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            final isCompleted = task['completed'] as bool;

            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: isCompleted ? Colors.green : Colors.orange,
                  child: Icon(
                    isCompleted ? Icons.check : Icons.hourglass_bottom,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  task['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  // Wait for the current frame to complete
                  await Future.delayed(Duration.zero);

                  if (!mounted) return;

                  try {
                    CustomLoader.show(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailsScreen(task: task),
                      ),
                    ).whenComplete(() {
                      if (mounted) CustomLoader.hide(context);
                    });

                    if (result == true && mounted) {
                      await _fetchTasks();
                      _loadLocalTasks();
                    }
                  } catch (e) {
                    if (mounted) {
                      CustomLoader.hide(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
              ),
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
            await TaskStorageService.addTask(newTask);
            print("📝 Saved Task: $newTask");
            _fetchTasks();
            _loadLocalTasks();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
