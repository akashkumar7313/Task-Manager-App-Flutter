class AddTaskState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const AddTaskState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  AddTaskState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return AddTaskState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}