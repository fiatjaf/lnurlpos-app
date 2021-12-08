import "dart:typed_data";
import "dart:convert";
import "dart:math";
import "package:crypto/crypto.dart";

class NoncePayload {
  NoncePayload({this.nonce = '', this.payload = ''});

  final String nonce;
  final String payload;
}

final Random _random = Random.secure();

NoncePayload snigirev_encrypt(String key, int pin, int amount) {
  List<int> keyb = utf8.encode(key);

  var pinw = ByteData(2);
  pinw.setInt16(0, pin);
  List<int> pinb = List.from(pinw.buffer.asUint8List().reversed);

  var amountw = ByteData(4);
  amountw.setInt32(0, amount);
  List<int> amountb = List.from(amountw.buffer.asUint8List().reversed);

  final nonceb = List<int>.generate(8, (int index) => _random.nextInt(256));
  final checksum = sha256.convert(pinb + amountb).bytes.sublist(0, 2);
  var payloadb = sha256.convert(nonceb + keyb).bytes.sublist(0, 8);

  for (var i = 0; i < 2; i++) {
    payloadb[i] = payloadb[i] ^ pinb[i];
  }
  for (var i = 0; i < 4; i++) {
    payloadb[2 + i] = payloadb[2 + i] ^ amountb[i];
  }
  for (var i = 0; i < 2; i++) {
    payloadb[6 + i] = payloadb[6 + i] ^ checksum[i];
  }

  final re = RegExp(r'=');
  return NoncePayload(
    nonce: base64Url.encode(nonceb).replaceAll(re, ""),
    payload: base64Url.encode(payloadb).replaceAll(re, ""),
  );
}
