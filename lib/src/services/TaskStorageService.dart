import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TaskStorageService {
  static const _key = 'tasks';

  // Save tasks list
  static Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, jsonEncode(tasks));
    // print('✅ All Tasks Saved:');
    // for (var task in tasks) {
    //   print(' - Task ID: ${task['id']}, Title: ${task['title']}, Completed: ${task['completed']}');
    // }
    print('📦 Total Tasks Saved: ${tasks.length}');
  }

  // Load tasks list
  static Future<List<Map<String, dynamic>>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return [];
    final List decoded = jsonDecode(jsonStr);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> updateTaskCompletion(int taskId, bool isCompleted) async {
    final tasks = await loadTasks();
    final index = tasks.indexWhere((task) => task['id'] == taskId);
    if (index != -1) {
      tasks[index]['completed'] = isCompleted;
      await saveTasks(tasks);
      print('✅ Task Updated -> ID: ${taskId}, New Status: ${isCompleted ? "Completed" : "Pending"}');
  } else {
  print('⚠️ Task with ID $taskId not found!');
  }
  }

  // Update single task
  static Future<void> updateTaskStatus(int taskId, bool isCompleted) async {
    final tasks = await loadTasks();
    final index = tasks.indexWhere((task) => task['id'] == taskId);
    if (index != -1) {
      tasks[index]['completed'] = isCompleted;
      await saveTasks(tasks);
    }
  }

  // Add new task
  static Future<void> addTask(Map<String, dynamic> task) async {
    final tasks = await loadTasks();
    final index = tasks.indexWhere((t) => t['id'] == task['id']);

    task['isLocal'] = true;         // Mark as local
    task['completed'] = false;      // Mark as pending

    if (index != -1) {
      // Task already exists → update it
      tasks[index] = task;
      print('🔄 Task with ID ${task['id']} updated.');
    } else {
      // New task → insert at the top
      tasks.insert(0, task);
      print('🆕 Task with ID ${task['id']} added.');
    }

    await saveTasks(tasks);
  }


  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // or remove specific keys
  }

}
