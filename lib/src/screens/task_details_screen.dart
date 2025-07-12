import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/src/logic/theme/theme_cubit.dart';
import 'package:task_manager_app/src/services/TaskStorageService.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.task['completed'];
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final isDark = context.watch<ThemeCubit>().state;

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
                isCompleted ? Icons.check_circle : Icons.pending_actions,
                color: isCompleted ? Colors.green : Colors.orange,
                size: 60,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                isCompleted ? "This task is completed" : "This task is pending",
                style: TextStyle(
                  fontSize: 16,
                  color: isCompleted ? Colors.green : Colors.orange,
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
                onPressed: () async {
                  try {
                    final newStatus = !isCompleted; // Toggle status

                    await TaskStorageService.updateTaskCompletion(task['id'], newStatus);

                    if (mounted) {
                      setState(() {
                        isCompleted = newStatus; // ✅ Update local state to reflect change in UI
                      });

                      // ✅ Print updated status
                      print('Task ID: ${task['id']} updated to ${isCompleted ? "Completed" : "Pending"}');

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isCompleted ? 'Task marked as completed' : 'Task marked as pending',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: isCompleted ? Colors.green : Colors.orange,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      await Future.delayed(const Duration(milliseconds: 300));
                      Navigator.pop(context, true); // Return success
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }

                    // ✅ Also print error in console
                    print('Error updating task: $e');
                  }
                },
                icon: Icon(
                  isCompleted ? Icons.undo : Icons.check_circle_outline,
                  size: 20,
                ),
                label: Text(
                  isCompleted ? "Mark as Incomplete" : "Mark as Completed",
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:
                  isCompleted ? Colors.orange : Colors.green,
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
  }
}
