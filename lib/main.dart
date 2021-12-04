import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'observer.dart';
import 'views/amount.dart';
import 'views/qr.dart';
import 'cubits/amount.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(
      MaterialApp(
        title: 'LNURLPoS',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red,
          fontFamily: 'Georgia',
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontFamily: 'Hind'),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        home: MainPage(),
      ),
    ),
    blocObserver: AmountObserver(),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AmountCubit(),
      child: Navigator(
        initialRoute: '/',
        observers: [
          NavigatorObserver(),
        ],
        onGenerateRoute: (RouteSettings settings) {
          late Widget page;
          switch (settings.name) {
            case '/':
              page = AmountView();
              break;
            case '/qr':
              page = QRView();
              break;
            // case '/settings':
            //   page = SettingsView();
            //   break;
          }

          return MaterialPageRoute<dynamic>(
            builder: (context) {
              return page;
            },
            settings: settings,
          );
        },
      ),
    );
  }
}
