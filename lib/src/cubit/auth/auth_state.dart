class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const LoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  LoginState copyWith({bool? isLoading, bool? isSuccess, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}
