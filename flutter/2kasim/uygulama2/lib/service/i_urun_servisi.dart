import '../model/urun_model.dart';

abstract class IUrunServisi{
  Future<List<UrunModel>> urunleriGetir();

}