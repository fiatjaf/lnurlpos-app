import 'package:bloc/bloc.dart';

class AmountCubit extends Cubit<int> {
  AmountCubit() : super(0);

  void pressNumber(String char) {
    String typed = state == 0 ? char : char + state.toString();
    if (typed.length > 8) {
      emit(state);
    } else {
      int newState = int.parse(typed);
      emit(newState);
    }
  }

  void pressClear() => emit(0);
}
