import 'package:formz/formz.dart';

class AuthState {
  final String email;
  final String password;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  AuthState({
    this.email = '',
    this.password = '',
    this.status = FormzSubmissionStatus.failure,
    this.errorMessage,
  });

  AuthState copyWith({
    String? email,
    String? password,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
