import 'dart:math';
import 'dart:convert';
import 'package:bech32/bech32.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/bech32.dart';
import '../utils/snigirev.dart';
import '../cubits/amount.dart';
import '../components/scaffold.dart';

final Random _random = Random.secure();

class QRView extends StatelessWidget {
  Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: futurePrefs,
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
        if (!prefs.hasData) return Text("Couldn't find settings.");

        final actionURL = prefs.data?.getString('action_url');
        final key = prefs.data?.getString('encryption_key');
        if (actionURL == null || key == null)
          return Text("Settings were not defined.");

        return BlocBuilder<AmountCubit, String>(builder: (context, state) {
          final pin = _random.nextInt(10000);
          final nonce_payload = snigirev_encrypt(key, pin, int.parse(state));
          Uri url = Uri.parse(actionURL);
          Map<String, String> qs = Uri.splitQueryString(url.query);
          qs.putIfAbsent("_n", () => nonce_payload.nonce);
          qs.putIfAbsent("_p", () => nonce_payload.payload);
          url = Uri(
            scheme: url.scheme,
            userInfo: url.userInfo,
            host: url.host,
            port: url.port,
            path: url.path,
            queryParameters: qs,
          );
          final lnurl = bech32.encoder.convert(
            Bech32(
              "lnurl",
              to5bits(utf8.encode(url.toString())),
            ),
            1500,
          );

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
      },
    );
  }
}
