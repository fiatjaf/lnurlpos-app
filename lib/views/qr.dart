import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/globalstate.dart';
import '../components/scaffold.dart';

class QRView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalStateCubit, GlobalState>(
        builder: (context, state) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      final qrSize = min(width * 0.95 - 8, height * 0.9 - 32);

      return LNURLPoSScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              child: Center(
                child: QrImage(
                  data: state.lnurl.toUpperCase(),
                  version: QrVersions.auto,
                  size: qrSize,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(state.lnurl),
            ),
          ],
        ),
      );
    });
  }
}
