// theme_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // false = Light Mode, true = Dark Mode

  void toggleTheme(bool isDarkMode) {
    emit(isDarkMode);
  }
}