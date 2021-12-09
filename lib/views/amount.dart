import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubits/globalstate.dart';
import '../components/scaffold.dart';

class AmountView extends StatelessWidget {
  Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return LNURLPoSScaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<GlobalStateCubit, GlobalState>(
              builder: (context, state) {
                String text = state.amount;
                while (text.length < 3) {
                  text = '0' + text;
                }

                final formatted = text.substring(0, text.length - 2) +
                    "." +
                    text.substring(text.length - 2);

                return Center(
                  child: Text(
                    formatted,
                    style: Theme.of(context).textTheme.headline1?.apply(
                          fontWeightDelta: 50,
                        ),
                  ),
                );
              },
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonRow(
                    children: [
                      Button(
                        content: "1",
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressNumber("1");
                        },
                      ),
                      Button(
                        content: "2",
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressNumber("2");
                        },
                      ),
                      Button(
                        content: "3",
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressNumber("3");
                        },
                      ),
                    ],
                  ),
                  ButtonRow(
                    children: [
                      Button(
                        content: "4",
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressNumber("4");
                        },
                      ),
                      Button(
                        content: "5",
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressNumber("5");
                        },
                      ),
                      Button(
                        content: "6",
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressNumber("6");
                        },
                      ),
                    ],
                  ),
                  ButtonRow(
                    children: [
                      Button(
                        content: "7",
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressNumber("7");
                        },
                      ),
                      Button(
                        content: "8",
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressNumber("8");
                        },
                      ),
                      Button(
                        content: "9",
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressNumber("9");
                        },
                      ),
                    ],
                  ),
                  ButtonRow(
                    children: [
                      Button(
                        content: "C",
                        color: Colors.red,
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressClear();
                        },
                      ),
                      Button(
                        content: "0",
                        onPressed: () {
                          context.read<GlobalStateCubit>().pressNumber("0");
                        },
                      ),
                      FutureBuilder(
                        future: futurePrefs,
                        builder: (BuildContext context,
                            AsyncSnapshot<SharedPreferences> prefs) {
                          return Button(
                            content: "OK",
                            color: Colors.blue,
                            onPressed: !prefs.hasData ||
                                    prefs.data?.getString('action_url') ==
                                        null ||
                                    prefs.data?.getString('encryption_key') ==
                                        null
                                ? null
                                : () {
                                    context.read<GlobalStateCubit>().pressOK();
                                    Navigator.of(context).pushNamed('/qr');
                                  },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    Key? key,
    this.color = Colors.green,
    this.content = "",
    this.onPressed,
  }) : super(key: key);

  final Color color;
  final String content;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: BlocBuilder<GlobalStateCubit, GlobalState>(
          builder: (context, state) {
            final tooMuch = state.amount.length > 8;
            final isInt = int.tryParse(this.content) != null;

            return ElevatedButton(
              child: Text(this.content),
              style: ElevatedButton.styleFrom(
                primary: this.color,
                enableFeedback: true,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
                elevation: 4,
              ),
              onPressed: tooMuch && isInt ? null : this.onPressed,
            );
          },
        ),
      ),
    );
  }
}
