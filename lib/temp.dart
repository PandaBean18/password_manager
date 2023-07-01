import 'package:pbkdf2ns/pbkdf2ns.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

void main() {
  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';

  PBKDF2NS gen = PBKDF2NS(hash: sha256);
  List<int> key =
      gen.generateKey("passwordpassword", "Aqx@0&^*&r92055eW9^C", 1000, 24);
  final encryptionKey = Key.fromUtf8(base64.encode(key));
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(encryptionKey));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  print(encrypted == Encrypted.fromBase64(encrypted.base64));

  print(encrypted.base64);
  print(decrypted);
}
