import 'package:flutter/material.dart';


class SepetKontrol{

  static final SepetKontrol ornek = SepetKontrol._dahili();
  SepetKontrol._dahili();

  final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

  void sepeteEkle(){
    urunSayisi.value++;
  }

  void sepetSifirla(){
    urunSayisi.value = 0;
  }
}