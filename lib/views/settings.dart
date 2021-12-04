import 'dart:math';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubits/amount.dart';
import '../components/scaffold.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LNURLPoSScaffold(
      body: FutureBuilder<SharedPreferences>(
        future: futurePrefs,
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          if (!prefs.hasData) return Text("");

          return Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Settings',
                      style: textTheme.headline6,
                    ),
                    margin: EdgeInsets.only(bottom: 25),
                  ),
                  TextFormField(
                    initialValue: prefs.data?.getString('action_url'),
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'LNbits Action Endpoint',
                        hintText:
                            'https://your.lnbits/ext/wallet_id/app_id/action/lnurlp'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }

                      try {
                        final url = Uri.parse(value);
                        if (!url.isAbsolute) {
                          return 'Invalid URL.';
                        }
                      } catch (e) {
                        return 'Invalid URL.';
                      }

                      return null;
                    },
                    onSaved: (value) async {
                      final saved = await prefs.data
                          ?.setString("action_url", value != null ? value : '');
                    },
                  ),
                  TextFormField(
                    initialValue: prefs.data?.getString('encryption_key'),
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Encryption Key, the same used on LNbits',
                        hintText: 'b0d7f523dce19cb139138fa1'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Type something here.';
                      }

                      if (!value.length.isEven) {
                        return 'Invalid input length ${value.length}, must be even.';
                      }

                      try {
                        hex.decoder.convert(value);
                      } catch (e) {
                        return 'Invalid hex, use only characters 0123456789abcdef.';
                      }

                      return null;
                    },
                    onSaved: (value) async {
                      await prefs.data?.setString(
                          "encryption_key", value != null ? value : '');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        final FormState formState = _formKey.currentState!;
                        if (formState.validate()) {
                          formState.save();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
