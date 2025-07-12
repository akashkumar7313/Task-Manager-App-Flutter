class HomeState {
  final List<dynamic> tasks;
  final bool isLoading;
  final String? error;

  const HomeState({this.tasks = const [], this.isLoading = false, this.error});

  HomeState copyWith({List<dynamic>? tasks, bool? isLoading, String? error}) {
    return HomeState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
