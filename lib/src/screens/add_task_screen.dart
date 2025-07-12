import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/src/cubit/addTask/add_task_cubit.dart';
import 'package:task_manager_app/src/cubit/addTask/add_task_state.dart';
import 'package:task_manager_app/src/screens/home_screen.dart';
import 'package:task_manager_app/src/services/TaskStorageService.dart';
import 'package:task_manager_app/src/cubit/theme/theme_cubit.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _saveTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final newTask = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "title": _titleController.text.trim(),
        "description": _descriptionController.text.trim(),
        "completed": false,
        "isLocal": true,
      };
      context.read<AddTaskCubit>().addTask(newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;
    final backgroundColor = isDark ? Colors.black : Colors.grey[100];
    final cardColor = isDark ? Colors.grey[850] : Colors.grey.shade100;
    final textColor = isDark ? Colors.white : Colors.black87;

    return BlocProvider(
      create: (_) => AddTaskCubit(TaskStorageService()),
      child: BlocListener<AddTaskCubit, AddTaskState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  '✅ Task added successfully!',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ), // Replace with your destination widget
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: isDark ? Colors.white : Colors.black,
            title: const Text(
              "Create Task",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(
                          Icons.edit_note_rounded,
                          color: isDark
                              ? Colors.lightBlueAccent
                              : Colors.blueAccent,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Create a New Task",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.lightBlueAccent
                                : Colors.blueAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _titleController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: "Enter task title",
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey,
                          ),
                          filled: true,
                          fillColor: cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? "Title is required"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: "Write a short description (optional)",
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey,
                          ),
                          filled: true,
                          fillColor: cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<AddTaskCubit, AddTaskState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: state.isLoading
                                  ? null
                                  : () => _saveTask(context),
                              icon: const Icon(Icons.save_rounded, size: 20),
                              label: state.isLoading
                                  ? const Text("Saving...")
                                  : const Text("Save Task"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: isDark
                                    ? Colors.tealAccent[700]
                                    : Colors.blueAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
