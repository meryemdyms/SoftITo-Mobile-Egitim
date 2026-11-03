import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OgrenciModel{
  final String id;
  final String adSoyad;
  final String projeAdi;
  final int notu;
  final DateTime kayitTarihi;

  const OgrenciModel({
    required this.id,
    required this.adSoyad,
    required this.projeAdi,
    required this.notu,
    required this.kayitTarihi
  });

  factory OgrenciModel.fromFireStore(DocumentSnapshot doc){
    //dışarıdan gelen veri dynmamic alınır
    final veri = doc.data() as Map<String,dynamic>? ?? {};

    return OgrenciModel(
      id:doc.id, //id'yi sistem otomatik atadığı için direk doc içinde alırız
      //adsoyad veri içinden alınır
      adSoyad: veri['adSoyad'] as String? ?? "İsimsiz Öğrenci Shad",
      projeAdi: veri['projeAdi'] as String? ?? "Henüz Shad'ın Projesi yok",
      notu: (veri['notu']as num?)?.toInt() ?? 0,
      kayitTarihi: (veri['kayitTarihi'] as Timestamp?)?.toDate() ?? DateTime.now()
    );
  }
}

class FirestoreOgrenciServis{

  final CollectionReference _ogrencilerKoleksiyonu = FirebaseFirestore.instance.collection('ogrenciler');
  //future verdiğimizde sistem bize bir şey dönme sözü veriyor dönmezse hata verir.
  //ancak asenkron çalıştığı için sistem çökmez bu yapı çalışmaz ama sistem işlemeye devam eder.
  //void herhangi bir yanıtta hata olsa bile fonksiyonu bitirir
  //void hiçbir yanıt almazsa sonlandıramaz devam eder
  //add sen kaydet
  Future<void> ogrenciEkle({
    required String adSoyad,
    required String projeAdi,
    required int notu,
  }) async {
    try{
      await _ogrencilerKoleksiyonu.add({
        'adSoyad':adSoyad,
        'projeAdi':projeAdi,
        'notu':notu,
        'kayitTarihi':FieldValue.serverTimestamp(),
      });
      print('Öğrenci Başarıyla Kaydedildi');
    }catch(e){
      print('Öğrenci ekleme Başarısız:$e');
      rethrow; //yakaladığımız hatayı daha sonra bırakmamız lazım yoksa sürekli bellekte kalır
    }
  }
  //set ile bizim gönderdiğimize göre kaydeder.güncelleme+kaydetme 
  Future<void> ogrenciIdIleKaydet({
    required String tcNo,
    required String adSoyad,
    required projeAdi,
  }) async{
    await _ogrencilerKoleksiyonu.doc(tcNo).set({
      'adSoyad':adSoyad,
      'projeAdi':projeAdi,
      'guncellemeTarihi':FieldValue.serverTimestamp(),
    },SetOptions(merge: true));//SetOptions ile sadece verdiğim değişiklikleri ekler diğer verilerime dokunmaz

  }

  Future<List<OgrenciModel>> tumOgrencileriGetir()async{
    try{
      final QuerySnapshot snapshot = await _ogrencilerKoleksiyonu.orderBy('notu',descending: true).get();
      return snapshot.docs
      .map((doc)=>OgrenciModel.fromFireStore(doc))
      .toList();
    }catch(e){
      print("Veri çekme hatası");
      return [];
    }
  }
  
  Future<void> ogrenciNotuGuncelle(String documentId,int yeniNot) async{
    await _ogrencilerKoleksiyonu.doc(documentId).update({
      'notu':yeniNot,
      'sonDuzenleme':FieldValue.serverTimestamp(),//karşı taraftaki zaman damgasını kullan gönderdiğimiz yerdeki
    });
  }

  Future<void> ogrenciSil(String documentId) async{
    await _ogrencilerKoleksiyonu.doc(documentId).delete();
    print('$documentId referanslı veri tamamen silindi');
  }


   
  
}