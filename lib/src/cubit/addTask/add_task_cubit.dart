import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_task_state.dart';
import 'package:task_manager_app/src/services/TaskStorageService.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final TaskStorageService storageService;

  AddTaskCubit(this.storageService) : super(const AddTaskState());

  Future<void> addTask(Map<String, dynamic> newTask) async {
    emit(state.copyWith(isLoading: true, error: null, isSuccess: false));
    try {
      await TaskStorageService.addTask(newTask);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Failed to add task: $e"));
    }
  }
}