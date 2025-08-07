import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedDateCubit extends Cubit<DateTime> {
  SelectedDateCubit() : super(DateTime.now());

  void getNextDay() => emit(state.add(const Duration(days: 1)));
  void getPrevDay() => emit(state.subtract(const Duration(days: 1)));
}
