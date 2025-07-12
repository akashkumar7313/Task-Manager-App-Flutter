import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/src/cubit/taskDetails/task_details_cubit.dart';
import 'package:task_manager_app/src/cubit/taskDetails/task_details_state.dart';
import 'package:task_manager_app/src/cubit/theme/theme_cubit.dart';
import 'package:task_manager_app/src/services/TaskStorageService.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;
    final task = widget.task;

    return BlocProvider(
      create: (_) => TaskDetailsCubit(
        storageService: TaskStorageService(),
        initialCompleted: task['completed'],
        taskId: task['id'],
      ),
      child: BlocConsumer<TaskDetailsCubit, TaskDetailsState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error!}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: isDark ? Colors.black : Colors.grey[100],
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: isDark ? Colors.white : Colors.black,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Task Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 2),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      state.isCompleted
                          ? Icons.check_circle
                          : Icons.pending_actions,
                      color: state.isCompleted ? Colors.green : Colors.orange,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      state.isCompleted
                          ? "This task is completed"
                          : "This task is pending",
                      style: TextStyle(
                        fontSize: 16,
                        color: state.isCompleted ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Task ID: ${task['id']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task['title'],
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: state.isLoading
                          ? null
                          : () async {
                              final wasCompleted = state.isCompleted;
                              await context
                                  .read<TaskDetailsCubit>()
                                  .toggleCompletion();
                              final isNowCompleted = context
                                  .read<TaskDetailsCubit>()
                                  .state
                                  .isCompleted;
                              if (context
                                      .read<TaskDetailsCubit>()
                                      .state
                                      .error ==
                                  null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isNowCompleted
                                          ? 'Task marked as completed'
                                          : 'Task marked as pending',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: isNowCompleted
                                        ? Colors.green
                                        : Colors.orange,
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pop(context, true);
                              }
                            },
                      icon: Icon(
                        state.isCompleted
                            ? Icons.undo
                            : Icons.check_circle_outline,
                        size: 20,
                      ),
                      label: Text(
                        state.isCompleted
                            ? "Mark as Incomplete"
                            : "Mark as Completed",
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: state.isCompleted
                            ? Colors.orange
                            : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
