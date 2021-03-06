import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/globalstate.dart';
import '../components/scaffold.dart';

class QRView extends StatefulWidget {
  const QRView({Key? key}) : super(key: key);

  @override
  State<QRView> createState() => QRViewState();
}

class QRViewState extends State<QRView> {
  bool showingPin = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalStateCubit, GlobalState>(
        builder: (context, state) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      final qrSize = min(width * 0.95 - 8, height * 0.6 - 32);

      return LNURLPoSScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 14,
              ),
              child: Center(
                child: QrImage(
                  data: state.lnurl.toUpperCase(),
                  version: QrVersions.auto,
                  size: qrSize,
                ),
              ),
            ),
            showingPin
                ? Container()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(state.lnurl),
                  ),
            Spacer(flex: 1),
            showingPin
                ? Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Text(state.pin.toString(),
                        style: TextStyle(fontSize: 60)),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(bottom: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: Text(
                        "${showingPin ? 'Hide' : 'Show'} Confirmation Code"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      enableFeedback: true,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      setState(() {
                        showingPin = !showingPin;
                      });
                    },
                  ),
                  showingPin
                      ? ElevatedButton(
                          child: Text('Done'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            enableFeedback: true,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {
                            context.read<GlobalStateCubit>().clear();
                            Navigator.of(context).popAndPushNamed('/pos');
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
