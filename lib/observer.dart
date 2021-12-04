import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

class AmountObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
