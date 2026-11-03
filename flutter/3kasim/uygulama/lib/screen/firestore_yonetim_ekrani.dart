import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uygulama/model/ogrenci_model.dart';

class FireStoreYonetimEkrani extends StatefulWidget{
  
  const FireStoreYonetimEkrani({super.key});
  @override
  State<FireStoreYonetimEkrani> createState() => _FirestoreYonetimEkrani();

}

class _FirestoreYonetimEkrani extends State<FireStoreYonetimEkrani>{
  final FirestoreOgrenciServis _servis = FirestoreOgrenciServis();

  final TextEditingController _adsoyadKontrolcusu = TextEditingController();
  final TextEditingController _projeKontrolcusu = TextEditingController();
  final TextEditingController _notKontrolcusu = TextEditingController();


  //bu kontrolcülesi dispose ile kapatmalıyız sayfa açılır açılmaz değil ben kullancağım zaman çalışsınlar
  @override
  void dispose(){
    _adsoyadKontrolcusu.dispose();
    _notKontrolcusu.dispose();
    _projeKontrolcusu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Canlı Firestore Ekranı"),
        backgroundColor: Colors.amber.shade600,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.all(12.0),
            child: Padding(
              padding: const EdgeInsetsGeometry.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _adsoyadKontrolcusu,
                    decoration: const InputDecoration(
                      labelText: "Öğrenci Adı Soyadı",
                      prefixIcon: Icon(Icons.person)
                    ),
                  ),
                  const SizedBox(height: 8),
                  //üstüne proje bölümü gelicek expandede ile ekle
                  SizedBox(
                    width: 90,
                    child: TextField(
                      controller: _notKontrolcusu,
                      keyboardType: TextInputType.number,
                      decoration: const  InputDecoration(
                        labelText: "Not (0-100)",
                        prefixIcon: Icon(Icons.grade),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.brown,
                  minimumSize: const Size.fromHeight(44),
                ),
                onPressed: _yeniOgrenciKaydet,
                icon: const Icon(Icons.cloud_upload),
                label: const Text("Buluta kaydet"),
              )
              ),
            ),
        ],
      ),
      const Divider(thickness: 2),
      Expanded(
        //Devamlı çift taraflı akışı başlattık
        //Veritabanına özel istek atıyorsak QuerySnapshot yoksa normal snapshot kullanırız.
        //Biz burda nota göre özel istek attık QuerySnapshot kullandık
        child: StreamBuilder<QuerySnapshot>(
          //firebaseden ogrenciler koleksiyonunu nota göre sıralı stream içine gömyorum stream sürekli okucak
          stream: FirebaseFirestore.instance
          .collection('ogrenciler')
          .orderBy('notu',descending: true)
          .snapshots(),
          //çekilen verileri ekrana boyuyoruz builder içinde
          builder: (BuildContext contex,AsyncSnapshot<QuerySnapshot> snapshot){
            //hata varsa hata mesajı yazıyoruz
            if(snapshot.hasError){
              return Center(child: Text("Bulut hatası: ${snapshot.error}"));
            }
            //veriler hala yükleniyorsa yükleniyor iconu çıkartıyoruz
            if(snapshot.connectionState == ConnectionState){
              return const Center(child: CircularProgressIndicator());
            }
            //herhangi bir veri yoksa mesaj basıyoruz
            if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
              return const Center(
                child: Text("Henüz bulutta kayıtlı öğrenci yoktur."),
                );
            }
            //Veriler varsa dokumanlar değişkeni  içine alıyoruz
            final List<DocumentSnapshot> dokumanlar = snapshot.data!.docs;
            //builder içinde önce kontrolleri yaptık şimdi return ile ekrana çizicez
            return ListView.builder(
              itemCount: dokumanlar.length,
              itemBuilder: (contex,index){//yukarıda verileri içine koyduğumuz dokumanlar değişkeninden verileri alıcaz
                final doc = dokumanlar[index]; 
                final ogrenci = OgrenciModel.fromFireStore(doc);

                return Dismissible(
                  key: Key(ogrenci.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete_forever,color:Colors.white),
                  ),
                  onDismissed: (direction){
                    _servis.ogrenciSil(ogrenci.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${ogrenci.adSoyad} buluttan silindi')),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ogrenci.notu >= 80 ?Colors.green : (ogrenci.notu >= 50 ? Colors.orange:Colors.red ),
                      child: Text(
                        '${ogrenci.notu}',
                        style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      ogrenci.adSoyad,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Proje: ${ogrenci.projeAdi}'),
                    trailing: IconButton(
                      onPressed: ()=>  _notGuncelleDialog(ogrenci),
                      icon: const Icon(
                      Icons.edit,
                      color:Colors.amberAccent,
                    )
                  ),
                  ),
                );
              },

            );
          },
        ),
      )
    );
  }

  //ödev _notguncelle fonk yaz

  void _yeniOgrenciKaydet(){
    final adSoyad = _adsoyadKontrolcusu.text.trim();
    final proje = _projeKontrolcusu.text.trim();
    final not = int.tryParse(_notKontrolcusu.text.trim()) ?? 0;

    if(adSoyad.isEmpty || proje.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:Text('Lütfen ad soyad ve proje adını giriniz'))
      );
      return;
      
    }
    _servis.ogrenciEkle(adSoyad: adSoyad, projeAdi: proje, notu: not);
    _adsoyadKontrolcusu.clear();
    _projeKontrolcusu.clear();
    _notKontrolcusu.clear();
  }

  //Yapılcaklar
  /*
  1- expanded içinde projeadı inputu açılcak
  2-_notGuncelleDialog fonk yazılcak
  3- sayfalar parse edilecek ve sistem çalışır hale getirlicek
  */

}