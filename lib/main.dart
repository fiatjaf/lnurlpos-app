import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'observer.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(const AmountApp()),
    blocObserver: AmountObserver(),
  );
}
