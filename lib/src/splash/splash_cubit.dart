import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SplashState { initial, toLogin, toHome }

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.initial);

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      emit(SplashState.toHome);
    } else {
      emit(SplashState.toLogin);
    }
  }
}
