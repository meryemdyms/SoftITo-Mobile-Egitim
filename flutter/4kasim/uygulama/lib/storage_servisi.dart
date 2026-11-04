import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageServisi {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask yuklemeBaslat({
    required File dosya,
    required String hedefDizin,
    required String dosyaAdi,
  }){
    final Reference ref = _storage.ref().child('$hedefDizin/$dosyaAdi');
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata:{'yukleyen':'Faik fahri fuat furkan fahrettin tek kişilik dev kadro'},
    );
    return ref.putFile(dosya,metadata);
  }

  task.snapshot.listen((TaskSnapshot snapshot){
    final double yuzde = snapshot.bytesTransferred / snapshot.totalBytes;
    print('yükleniyor %${(yuzde * 100).toStringAsFixed(1)}');
  })
}