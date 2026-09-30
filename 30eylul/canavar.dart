//Görev: bir canavar sınıfı tanımla soyut olarak void kükre gövdesi bş method 
//ondan türüyen kurt canavarı ejderha canavı sınıfalrından kükreme seslerini ekrana yazdıe

abstract class Canavar{
  final String canavarAdi;

Canavar({required this.canavarAdi});

void kukre();
}

class KurtCanavari extends Canavar{
  KurtCanavari({required super.canavarAdi});

  @override
  void kukre(){
    print(" $canavarAdi Canavarı kükredi : UĞĞĞĞĞĞĞĞ");
  }
}

class EjderhaCanavari extends Canavar{
  EjderhaCanavari({required super.canavarAdi});
  @override
  void kukre(){
    print(" $canavarAdi Canavarı kükredi : ROAAAAARRRRR");
  }
}

void main(){
   print("Canavarlar");
   KurtCanavari kurt =KurtCanavari(canavarAdi: "Kurt");
   kurt.kukre();

    EjderhaCanavari ejderha =EjderhaCanavari(canavarAdi: "Ejderha");
    ejderha.kukre();

}
