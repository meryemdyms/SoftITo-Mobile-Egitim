
import 'package:flutter/material.dart';
import 'package:uygulama2/model/urun_model.dart';
import 'package:uygulama2/service/canli_api_urun_servisi.dart';
import 'package:uygulama2/service/i_urun_servisi.dart';

class UrunlerSayfasi extends StatefulWidget{
  const UrunlerSayfasi({super.key});

  @override
  State<UrunlerSayfasi> createState() => _UrunlerSayfasi();
}
class _UrunlerSayfasi extends State<UrunlerSayfasi>{

  final IUrunServisi _servis = CanliApiUrunServisi();
  List<UrunModel> _tumUrunler =[];

   @override
   void initState(){
    super.initState();
    _urunleriGetir();
   }

   @override
   void dispose(){
    super.dispose();
   }

   Future<void> _urunleriGetir()async{
    setState(() {
      
    });
   }
}
