import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class YerelBildirimYoneticisi{
  //FlutterLocalNotificationsPlugin, cihaz üzerinde bildirim göstermek için kullanılır.
  static final FlutterLocalNotificationsPlugin _yerelBildirim = FlutterLocalNotificationsPlugin();

  static Future<void> kurulum() async{
    const androidAyarlar = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosAyarlar = DarwinInitializationSettings();
    const ayarlar = InitializationSettings(
      android: androidAyarlar,
      iOS: iosAyarlar
    );

    await _yerelBildirim.initialize(settings: ayarlar);
  }

    //kurulumları yaptık ancak henüz göstemiyoruz
    //gösterme kodlarını yazalım
    static Future<void> bildirimGetir(RemoteMessage message) async{
      const androidDetay = AndroidNotificationDetails(
        //bildirim kanalı tanımlaam bilgileri id ve kanal adı
        'softito_kanal_id',
        'Softito Bildirimleri',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true
        );
        const detaylar = NotificationDetails(
          android: androidDetay
        );
        await _yerelBildirim.show(
          id:message.hashCode,
          title:message.notification?.title ?? 'Yeni Bildirim',
          body:message.notification?.body ?? '',
          notificationDetails: detaylar,
        );
    }
}

