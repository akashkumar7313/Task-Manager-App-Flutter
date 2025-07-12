import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'home_state.dart';
import 'package:task_manager_app/src/services/TaskStorageService.dart';

class HomeCubit extends Cubit<HomeState> {
  final TaskStorageService storageService;

  HomeCubit(this.storageService) : super(const HomeState());

  Future<void> fetchTasks() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      List<Map<String, dynamic>> tasks = await TaskStorageService.loadTasks();

      if (tasks.isEmpty) {
        final response = await http.get(
          Uri.parse('http://jsonplaceholder.typicode.com/todos'),
        );
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          tasks = data.cast<Map<String, dynamic>>();
          await TaskStorageService.saveTasks(tasks);
          tasks = await TaskStorageService.loadTasks();
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              error: "Failed to load tasks - ${response.statusCode}",
            ),
          );
          return;
        }
      }

      // Custom sort: local + pending > remote + pending > completed
      tasks.sort((a, b) {
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

      emit(state.copyWith(tasks: tasks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Something went wrong: $e"));
    }
  }

  Future<void> addTask(Map<String, dynamic> newTask) async {
    emit(state.copyWith(isLoading: true));
    try {
      await TaskStorageService.addTask(newTask);
      await fetchTasks(); // Always reload after add
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Failed to add task: $e"));
    }
  }

  Future<void> clearSession() async {
    await TaskStorageService.clearUserSession();
  }
}
