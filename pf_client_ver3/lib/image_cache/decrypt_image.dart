import 'dart:typed_data';

List<Uint8List> _featuresList = [
  Uint8List.fromList([0xff, 0xd8, 0xff]), //jpg,jpeg
  Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]), //png
  Uint8List.fromList([0x47, 0x49, 0x46]), //gif
];

int _encryptedLen = 100; //加密图片的数据长度
Uint8List _decryptKey = Uint8List.fromList('2019ysapp7527'.codeUnits); //加密key

bool _isEncryptedImage(Uint8List imgBytes) {
  bool isDecrypted = false;
  int _featuresLen = _featuresList.length;
  for (int i = 0; i < _featuresLen; i++) {
    isDecrypted = false;
    for (int j = 0; j < _featuresList[i].length; j++) {
      if (_featuresList[i][j] != imgBytes[j]) {
        isDecrypted = true;
        break;
      }
    }
    if (isDecrypted) {
      continue;
    } else {
      break;
    }
  }

  // if (isDecrypted) {
  //   print('isDecrypted!!!!!!!!!!!!!!!!!');
  // }
  return isDecrypted;
}

Uint8List decryptImage(Uint8List imgBytes) {
  if (imgBytes == null || imgBytes.length == 0) {
    return imgBytes;
  }

  if (_isEncryptedImage(imgBytes)) {
    int decryptKeyLen = _decryptKey.length;
    for (int i = 0; i < _encryptedLen; i++) {
      imgBytes[i] ^= _decryptKey[i % decryptKeyLen];
    }
  }

  return imgBytes;
}
