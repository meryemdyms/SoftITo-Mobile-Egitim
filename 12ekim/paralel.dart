/*

Future<void> fetchDashboardData() async{
  try{
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true);

    print("Tüm veriler geldi $result");
  }catch (e){
    print("İsteklerden Biri başarısız oldu $e");
  }
}
*/

//Future: Tek bir veri çekileceği zaman kullanılır ya hata ya da değer dönüp bitiriri
//Stream: Bir boru hattı şeklinde çalışır(pipe), zaman içinde 1 10 100 ya da sonsuz sayıda veri akışı sağlanabilir
//(Borsa fiyatlrarı,GPS konum güncelleme, Firebase canlı dinleme) stream örnekleri

import 'dart:async';

void main(){

  //controller oluşturma
  final controller = StreamController<int>();

  //dinleyici(listener) bağlama
  //tek bir dinleyicimiz var
  final subscription = controller.stream.listen(
    (data) => print("yeni Veri: $data"),
    onError: (err) => print("Hata Oluştu: $err"),
    onDone: ()=> print("Yayın Tamamlandı"),
  );

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);

  final broadcastStream = controller.stream.asBroadcastStream();
  broadcastStream.listen((d) => print("UI e-Ekranı: $d"));
  broadcastStream.listen((d) => print("Analitik Servis Ekranı: $d"));

  

  controller.close();


}