//kasa sınıfı yaz oyuncu adı altın miktarı başta sıfır ve gizli eğer altına eksi bakiye gelirse sahte altın eklenemez pozitifse altını ekle

class Kasa{
  final String oyuncuAdi;
  int _altinMiktari = 0;


  Kasa({required this.oyuncuAdi});

  int get altinMiktari{
    return _altinMiktari;
  }

  set altinMiktari(int eklenenAltin){
    if(eklenenAltin < 0){
      print("Altın sahte eklenmedi. Altın Miktarı : $altinMiktari");
    }else{
      _altinMiktari += eklenenAltin;
      print("Altın ekleme işlemi başarılı. Altın miktarı : $_altinMiktari");
    }
  }
}

void main(){
  print("Karakter Kasa Durumu");

  final karakter = Kasa(oyuncuAdi: "Meryem Duymuş");

  print("Başlangıç altın miktarı : ${karakter.altinMiktari}");
  
  print("Kasaya altın eklendi");
  karakter.altinMiktari = 50;
  karakter.altinMiktari = -10;

}