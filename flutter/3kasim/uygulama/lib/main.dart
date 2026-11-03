import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screen/firestore_yonetim_ekrani.dart';

void main() async{
  //firebase motorunu başlatalım
  WidgetsFlutterBinding.ensureInitialized();

  //await ile firebase başlatalm
  await Firebase.initializeApp();
  runApp(const SoftitoFirestoreUygulamasi());
}

class SoftitoFirestoreUygulamasi extends StatelessWidget{

  const SoftitoFirestoreUygulamasi({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cloud FireStore",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home:const FireStoreYonetimEkrani(),
    );
  }
}