import 'package:encrypt/encrypt.dart' as encrypt;

class Encryption{
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));
  static  encryptAes(text){
    final encrypted = encrypter.encrypt(text, iv:iv);

    return encrypted;
  }

  static decryptAES(text){
    return  encrypter.decrypt64(text,iv: iv);

  }


  static final keySalsa20 = encrypt.Key.fromLength(32);
  static final ivSalsa20 = encrypt.IV.fromLength(8);
  static final encrypterSalsa20 = encrypt.Encrypter(encrypt.Salsa20(keySalsa20));


  static  encryptSalsa20(text){
    return encrypterSalsa20.encrypt(text,iv: ivSalsa20);


  }

  static decryptSalsa20(text){
    return  encrypterSalsa20.decrypt(text,iv: ivSalsa20);
//return decrypted;
  }


}