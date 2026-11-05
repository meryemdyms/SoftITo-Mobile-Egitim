import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/storage_ve_fcm_ekrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //firebase servislerini initalize etmiştik diyoruz ki onlardan emin ol sonra bu sayfayı başlat emin olmak için
  try{
    await Firebase.initializeApp();
  }catch(_){}
  runApp(const SoftitoFcmDemoApplication());
}

class SoftitoFcmDemoApplication extends StatelessWidget{
  const SoftitoFcmDemoApplication ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Softito FCM Demo Applications",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(0, 0, 0, 0)),
        brightness: Brightness.light,
      ),
      home: const StorageVeFcmEkrani(),
    );
  }
}