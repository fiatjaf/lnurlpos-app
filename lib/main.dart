import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'observer.dart';
import 'views/qr.dart';
import 'views/amount.dart';
import 'views/settings.dart';
import 'cubits/globalstate.dart';

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
            headline1: TextStyle(fontSize: 120.0, fontWeight: FontWeight.w900),
            headline6: TextStyle(fontSize: 36.0, fontFamily: 'Hind'),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        home: MainPage(),
      ),
    ),
    blocObserver: GlobalStateObserver(),
  );
}

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GlobalStateCubit(),
      child: FutureBuilder(
        future: futurePrefs,
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          if (!prefs.hasData)
            return Center(
              child: Text("Loading settings..."),
            );

          String initialRoute = '/';
          if (prefs.data!.getString('action_url') == null ||
              prefs.data!.getString('encryption_key') == null) {
            initialRoute = '/settings';
          }

          return Navigator(
            initialRoute: initialRoute,
            onGenerateRoute: (RouteSettings settings) {
              late Widget page;
              switch (settings.name) {
                case '/':
                  page = AmountView();
                  break;
                case '/qr':
                  page = QRView();
                  break;
                case '/settings':
                  page = SettingsView();
                  break;
              }

              return MaterialPageRoute<dynamic>(
                builder: (context) {
                  return page;
                },
                settings: settings,
              );
            },
          );
        },
      ),
    );
  }
}
