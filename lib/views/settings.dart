import 'dart:io' show Platform;
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/scaffold.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: 'settingsForm');
  final GlobalKey qrKey = GlobalKey(debugLabel: 'settingsQRScanner');
  TextEditingController? actionTextFieldController;
  bool showingQRReader = false;
  QRViewController? controller;
  Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LNURLPoSScaffold(
      body: FutureBuilder<SharedPreferences>(
        future: futurePrefs,
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          if (!prefs.hasData) return Container();

          if (actionTextFieldController == null) {
            actionTextFieldController = TextEditingController(
                text: prefs.data?.getString('action_url'));
          }

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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: actionTextFieldController,
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
                            final saved = await prefs.data?.setString(
                                "action_url", value != null ? value : '');
                          },
                        ),
                      ),
                      Platform.isAndroid || Platform.isIOS
                          ? IconButton(
                              icon: Icon(Icons.qr_code),
                              onPressed: () {
                                setState(() {
                                  showingQRReader = !showingQRReader;
                                });
                              },
                            )
                          : Container()
                    ],
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

                      return null;
                    },
                    onSaved: (value) async {
                      await prefs.data?.setString(
                          "encryption_key", value != null ? value : '');
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            enableFeedback: true,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {
                            final FormState formState = _formKey.currentState!;
                            if (formState.validate()) {
                              formState.save();
                              Navigator.of(context).popAndPushNamed('/pos');
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                  (Platform.isAndroid || Platform.isIOS) && showingQRReader
                      ? Expanded(
                          flex: 5,
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        if (scanData.code != null && actionTextFieldController != null) {
          actionTextFieldController!.text = scanData.code!;
          showingQRReader = false;
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
