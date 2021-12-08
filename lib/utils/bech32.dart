/// Taken from bech32 (bitcoinjs): https://github.com/bitcoinjs/bech32
List<int> to5bits(List<int> data) {
  const inBits = 8;
  const outBits = 5;

  var value = 0;
  var bits = 0;
  var maxV = (1 << outBits) - 1;

  var result = <int>[];
  for (var i = 0; i < data.length; ++i) {
    value = (value << inBits) | data[i];
    bits += inBits;

    while (bits >= outBits) {
      bits -= outBits;
      result.add((value >> bits) & maxV);
    }
  }

  if (bits > 0) {
    result.add((value << (outBits - bits)) & maxV);
  }

  return result;
}
