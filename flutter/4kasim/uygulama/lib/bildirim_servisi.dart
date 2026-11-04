import 'package:firebase_messaging/firebase_messaging.dart';

//uygulama kapalı olsa bile arka planda bildirimleri okuyabilen sistemi kuralım
//her zaman en üstte olmalıdır sınıfın üstüne yazılır
@pragma('vm:entry-point')//her şeyden bağımsız arka planda çalışmasını sağlayan fonksiyon
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Arka planda bildirim geldi: ${message.notification?.title}");
}//Arka planda gelen bildirimi okuduk henüz daha ekranda göstermedik


class BildirimServisi{
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  Future<void> baslat() async {
    //ayarları başlatarak izinleri istiyeceğiz
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true, //bildiirm ekranda
      badge: true, //bildirim simgesi
      sound: true //bildirim sesi
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("Kullanıcı bildirim iznini verdi");
    }
    //her cihazın kendine ait tokeni vardır
    final token = await _fcm.getToken();
    print('Cihazın FCM Tokenı: $token');

 
  }
}

   