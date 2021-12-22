import "dart:typed_data";
import "dart:convert";
import "dart:math";
import "package:crypto/crypto.dart";

final Random _random = Random.secure();

String snigirev_encrypt(String key, int pin, int amount) {
  List<int> keyb = utf8.encode(key);

  // generate random nonce
  final nonce = List<int>.generate(8, (int index) => _random.nextInt(256));

  // encode pin and amount into payload
  List<int> payload = encodeVarInt(pin) + encodeVarInt(amount);

  // encrypt payload
  var secrethmac = new Hmac(sha256, keyb);
  final secret = secrethmac.convert(utf8.encode("Round secret:") + nonce).bytes;
  for (var i = 0; i < payload.length; i++) {
    payload[i] = payload[i] ^ secret[i];
  }

  // generate checksum
  final blob = <int>[
    1,
    nonce.length,
    ...nonce,
    payload.length,
    ...payload,
  ];
  var checksumhmac = new Hmac(sha256, keyb);
  final checksum = checksumhmac.convert(utf8.encode("Data:") + blob).bytes;

  // concat everything
  final output = blob + checksum;

  return base64Url.encode(output).replaceAll(RegExp(r'='), "");
}

List<int> encodeVarInt(int val) {
  var buf = ByteData(8);
  var length = 0;

  if (val < 0xfd) {
    buf.setUint8(0, val);
    length = 1;
  } else if (val <= 0xffff) {
    buf.setUint8(0, 0xfd);
    buf.setUint16(1, val, Endian.little);
    length = 3;
  } else if (val <= 0xffffffff) {
    buf.setUint8(0, 0xfe);
    buf.setUint32(1, val, Endian.little);
    length = 5;
  } else {
    buf.setUint64(0, val, Endian.little);
    length = 8;
  }

  return buf.buffer.asUint8List().sublist(0, length);
}
