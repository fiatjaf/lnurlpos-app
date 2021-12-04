import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/amount.dart';
import '../components/scaffold.dart';

class QRView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AmountCubit, String>(builder: (context, state) {
      final lnurl =
          "lnurl1aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      final qrSize = min(width * 0.95 - 8, height * 0.9 - 32);

      return LNURLPoSScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
              child: Center(
                child: QrImage(
                  data: lnurl.toUpperCase(),
                  version: QrVersions.auto,
                  size: qrSize,
                ),
              ),
            ),
            Text(lnurl),
          ],
        ),
      );
    });
  }
}
