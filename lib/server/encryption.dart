import 'package:encrypt/encrypt.dart' as encrypt;

enum ID_APPWRITE {
  ENDPOINT,
  PROJECTID,
  DATABASEID,
  ACCOUNTID,
  RECEIVEID,
  EXPENSEID
}

class Encryption {
  late encrypt.Encrypter encrypter;
  late encrypt.IV iv;

  List<String> data = [
    'rEfRkvxpeYvYFgKA/TRVRwJL53wF0VcXq8M/XvJsbUU=',
    '8gXA2rxgbpOLSlyR/C8CU0sF9id9uHVyyOBFY/pkZU0=',
    '8gXA2rwxNMeLSl6WqHkNBRNd9iZ9uHVyyOBFY/pkZU0=',
    '8gXAg+0xZJaLSl/Hr38AUUBeonF9uHVyyOBFY/pkZU0=',
    '8guVgLwyYJGLSl+QqS8BA0FfrHd9uHVyyOBFY/pkZU0=',
    '8guVgLwyYsGLSlyRqSMMUhYJpC19uHVyyOBFY/pkZU0='
  ];

  Encryption() {
    final key = encrypt.Key.fromUtf8('..........!@#NCT%^&*()..........');
    iv = encrypt.IV.fromUtf8('..!@#NCT%^&*()..');
    encrypter = encrypt.Encrypter(encrypt.AES(key));
  }

  void encryptService(String str) {
    String strEncrypt = encrypter.encrypt(str, iv: iv).base64;
    print(strEncrypt);
  }

  String decryptedService(ID_APPWRITE id) {
    return encrypter.decrypt64(data[id.index], iv: iv);
  }
}