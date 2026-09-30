//bir yüzme yetisi ekle dalış yap methodu su altına daldı yapan kişi denizci
mixin yuzmeYetisi{
  void dalisYap(){
    print("Suya Daldı");
  }
}

class Denizci with yuzmeYetisi{
  final String ad;
  Denizci({required this.ad});

}

void main(){
  final denizci = Denizci(ad: "Meryem");
  denizci.dalisYap();
}

