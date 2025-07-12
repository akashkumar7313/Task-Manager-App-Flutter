import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  void loginWithCredentials() {
    if (state.email == 'test@test.com' && state.password == '123456') {
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } else {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: 'Invalid email or password.',
      ));
    }
  }
}
