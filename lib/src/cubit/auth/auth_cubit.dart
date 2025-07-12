import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/src/cubit/auth/auth_state.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null, isSuccess: false));
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@test.com' && password == '123456') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } else {
      emit(state.copyWith(isLoading: false, error: 'Invalid credentials'));
    }
  }
}