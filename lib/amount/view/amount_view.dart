import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../amount.dart';

class AmountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('LNURLPoS')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AmountCubit, int>(
            builder: (context, state) {
              String text = state.toString();
              while (text.length < 3) {
                text = '0' + text;
              }

              final formatted = text.substring(0, text.length - 2) +
                  "." +
                  text.substring(text.length - 2);

              return Text(
                formatted,
                style: textTheme.headline2,
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Button(
                    content: "1",
                    onPressed: () {
                      context.read<AmountCubit>().pressNumber("1");
                    },
                  ),
                  Button(
                    content: "2",
                    onPressed: () {
                      context.read<AmountCubit>().pressNumber("2");
                    },
                  ),
                  Button(
                    content: "3",
                    onPressed: () {
                      context.read<AmountCubit>().pressNumber("3");
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Button(
                    content: "4",
                    onPressed: () {
                      context.read<AmountCubit>().pressNumber("4");
                    },
                  ),
                  Button(
                    content: "5",
                    onPressed: () {
                      context.read<AmountCubit>().pressNumber("5");
                    },
                  ),
                  Button(
                    content: "6",
                    onPressed: () {
                      context.read<AmountCubit>().pressNumber("6");
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Button(
                    content: "7",
                    onPressed: () {
                      context.read<AmountCubit>().pressNumber("7");
                    },
                  ),
                  Button(
                    content: "8",
                    onPressed: () {
                      context.read<AmountCubit>().pressNumber("8");
                    },
                  ),
                  Button(
                    content: "9",
                    onPressed: () {
                      context.read<AmountCubit>().pressNumber("9");
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Button(
                    content: "C",
                    color: Colors.red,
                    onPressed: () {
                      context.read<AmountCubit>().pressClear();
                    },
                  ),
                  Button(
                    content: "0",
                    onPressed: () {
                      context.read<AmountCubit>().pressNumber("0");
                    },
                  ),
                  Button(
                    content: "OK",
                    onPressed: () {
                      print("pressed OK");
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
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
    return ElevatedButton(
      child: Text(this.content),
      style: ElevatedButton.styleFrom(
        primary: this.color,
        minimumSize: Size(80, 80),
        enableFeedback: true,
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        elevation: 4,
      ),
      onPressed: this.onPressed,
    );
  }
}
