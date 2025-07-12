import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_details_state.dart';
import 'package:task_manager_app/src/services/TaskStorageService.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final TaskStorageService storageService;
  final int taskId;

  TaskDetailsCubit({
    required this.storageService,
    required bool initialCompleted,
    required this.taskId,
  }) : super(TaskDetailsState(isCompleted: initialCompleted));

  Future<void> toggleCompletion() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final newStatus = !state.isCompleted;
      await TaskStorageService.updateTaskCompletion(taskId, newStatus);
      emit(state.copyWith(isLoading: false, isCompleted: newStatus));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Error updating task: $e"));
    }
  }
}
