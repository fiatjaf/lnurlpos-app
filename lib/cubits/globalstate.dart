import 'dart:math';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bech32/bech32.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/bech32.dart';
import '../utils/snigirev.dart';

final Random _random = Random.secure();

class GlobalState {
  String amount;
  int pin;
  String lnurl;

  GlobalState({
    this.amount = '',
    this.pin = 0,
    this.lnurl = '',
  });
}

class GlobalStateCubit extends Cubit<GlobalState> {
  GlobalStateCubit() : super(GlobalState());

  void pressNumber(String char) {
    if (int.tryParse(char) == null) {
      emit(state);
      return;
    }

    if (state == '' && char == '0') {
      emit(state);
      return;
    }

    if (state.amount.length > 7) {
      emit(state);
    } else {
      emit(GlobalState(amount: state.amount + char));
    }
  }

  void clear() => emit(GlobalState());

  void amountDone() async {
    final prefs = await SharedPreferences.getInstance();

    final actionURL = prefs.getString('action_url');
    final key = prefs.getString('encryption_key');
    if (actionURL == null || key == null) {
      throw new Exception("Settings were not defined.");
    }

    final pin = _random.nextInt(10000);
    final payload = snigirev_encrypt(key, pin, int.parse(state.amount));
    Uri url = Uri.parse(actionURL);
    Map<String, String> qs = Uri.splitQueryString(url.query);
    qs.putIfAbsent("p", () => payload);
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

    emit(GlobalState(
      amount: state.amount,
      pin: pin,
      lnurl: lnurl,
    ));
  }
}
