
/*
// Soyutlama Abstraction Kavramı 

//1. Adım (sözleşmeler) Contract
abstract class AuthReposity{
    Future<String>login(String email, String password);
    Future<void>logout();
    bool get isAuth;
}

//canlı uygulama
class FirebaseAuthReposity implements AuthReposity{
    @override
    Future<String> login(String email, String password) async{
        //gerçek Firebase SDK Çağrısı
        return "firebase_token_xyz_123";

    }

    @override
    Future<void> logout() async{
        //Firebase Logout
    }

    @override 
    bool get isAuth => true;
}


//Test ve offline simülasyon
class MockAuthReposity implements AuthReposity{
    @override
    Future<String> login(String email, String password) async{
        await Future.delayed(Duration(seconds: 1));
        return "mock_token_abc_789";
    }

    @override
    Future<void> logout() async {}

    @override
    bool get isAuth => false;
}
*/

/*
mixin Logger{
    void log(String msg)=>print("LOG:$msg");
}

mixin Analytics{
    void log(String msg)=>print("ANALİZ:$msg");
}

//asenkron çalış demediğim için önce logger dan aldı sonra Analytics en son gelip diğerleri ezdi ve o çalıştı
class PaymentService with Logger,Analytics{
    void pay(){
        log("Ödeme yapıldı");
    }
}

abstract class Basewidget{

}

//sadece Basewidget ve alt sınıflarında kullansın
//sadece ekrana özgü mixin yapmak istediğimizde bunu kullanırız
mixin  LifeLogger on Basewidget{
    void logInit() => print("Widget Başlatıldı");
}

*/

/*
extension StringValidator on String{
    bool get isValidEmail{
        final emailRegex=RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        return emailRegex.hasMatch(this);

    }

    String toCapitalize(){
        if(isEmpty) return this;
        return this[0].toUpperCase()+substring(1);
    }
}

//Kullanımı
void main(){
    String email="selehaddin@kodvance.com";
    if(email.isValidEmail){
        print("Geçerli Eposta");
    }else{
        print("Geçersiz Eposta");
    }
}
*/
/*
abstract class Identifiable{
    String get id;
}

//T tipi mutlaka Identifiable arayüzünü uygulamak ZORUNDADIR
class GenericCache<T extends Identifiable>{
    final Map<String,T> _storage={};


    void save (T item){
        _storage[item.id]=item;
        print("ID:${item.id} önbelleğe alındı");
    }

    T? getById(String id)=>_storage[id];
}

*/

import 'dart:async';

void main(){
    print("1.Senkron Başladı");
    scheduleMicrotask((){
        print("2.Task Oluştu(Vip Kuyruk)");
    });

    Future((){
        print("3.Standart Event Kuyruğu");
    });
    Future.microtask((){
        print("4. Future.microtask çalıştı");
    });

    print("5.Senkron kod tamaml");
}
//çıktı: 1-5-2-4-3






