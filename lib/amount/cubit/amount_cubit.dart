import 'package:bloc/bloc.dart';

class AmountCubit extends Cubit<String> {
  AmountCubit() : super('');

  void pressNumber(String char) {
    if (int.tryParse(char) == null) {
      emit(state);
      return;
    }

    if (state == '' && char == '0') {
      emit(state);
      return;
    }

    String newState = char + state;
    if (newState.length > 8) {
      emit(state);
    } else {
      emit(newState);
    }
  }

  void pressClear() => emit('');
}
