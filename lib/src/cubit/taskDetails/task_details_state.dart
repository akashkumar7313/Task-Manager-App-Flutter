class TaskDetailsState {
  final bool isLoading;
  final bool isCompleted;
  final String? error;

  const TaskDetailsState({
    this.isLoading = false,
    required this.isCompleted,
    this.error,
  });

  TaskDetailsState copyWith({
    bool? isLoading,
    bool? isCompleted,
    String? error,
  }) {
    return TaskDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error,
    );
  }
}