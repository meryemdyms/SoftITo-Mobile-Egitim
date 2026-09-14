//kötü kod
void p(List u){

    for(var i = 0; i<u.length; i++){
        if(u[i].a>18 && u[i].s=="A"){
            print('User' +u[i].n + "can vote");
        }
    }
}

//Temiz kod
class Customer{
    final String name;
    final int age;
    final bool isActive;
    final double basketTotal;

    Customer({required this.name, required this.age, required this.isActive,required this.basketTotal})

    bool get canVote => age >=18;
    double get discount => basketTotal * 0.15;
}

void processCustomers(List<Customer> customers){
    for(final customer in customers){
        if(customer.canVote && customer.isActive){
            print('User vb.')
        }
    }
}


//SOLID PRENSIP IHLALI hem veri tutuyor hem db yazıyor vb,
//Tek class içinde birçok işlem

class UserManager{
    void registerUser(String email, String password){
        //1.Validasyon yap
        //2.SQL/Firebase kaydet
        //3.SMTO üzerinden hoş geldin maili at
        //4.Hata olursa log yaz
    }
}


//SOLID PRENSIP UYUMLU KOD
//Bir class bir göreve özgü
class UserValidator{bool isValid(String email, String password) => true;}
class UserRepository{void saveToDatabase(User user){/*db işlemleri*/}}


//OPEN / CLOSE PRINCIPLE

//soyut arayüz
abstract class PaymentMethod{
    void pay(double amount);
}


class CreditCardPayment implements PaymentMethod{
    @override void pay(double amaount) => print('$amaount TL KREDİ KARTI ILE ODEME ALINDI');
}

class ApplePayment implements PaymentMethod{
     @override void pay(double amaount) => print('$amaount TL APPLE PAY ILE ODEME ALINDI');
}


//
class Rectangle{
    double width = 0;
    double height = 0;

    void setWidth(double w) => width = w;
    void setHeight(double h) => height = h;
    double get area => width * height;
}

//LISKIV IHLALI
class Square extends Rectangle{
    @override void setWidth(double w){width=w; height=w}//kare olduğu için boyu eşitlendi
     @override void setHeight(double h){width=h; height=h}//kare olduğu için boyu eşitlendi
}

//TEST FONKSİYONU
void testRectangle(Rectangle r){
    r.setWidth(5);
    r.setHeight(4);
    //üst sınıf kuralına göre alan 5*4=20 olmalıdır
    //parametre olarak square gönderilirse 4*4=16
    //beklenen davranış bozuldu! LISKOV IHLALI
    assert(r.area == 20);
    }


//Şişkin arayüz
abstract class SmartDevice{
    void printDocument();
    void scanDocument();
    void sendFax();

}

//Normal bir ev yazıcısı (fax çekemez)
class BasicPrinter implements SmartDevice{
    @override void printDocument()=>print('Yazdırılıyor');
    @override void scanDocument()=>print('Tranıyor');
    @override void sendFax()=>throw UnimlementedError('fax ozelligim yok');//ISP IHLALI

}

//ISP UYUMLU
abstractclass Printer{void printDocument();}
abstractclass Scanner{void scanDocument();}
abstractclass FaxMachine{void sendFax();}

//işime yaramıcak olanı direk almadım ssiteme yük bindirmedim
class BasicPrinterClean implements Printer,Scanner{
    @override void printDocument()=>print('Yazdırılıyor');
    @override void scanDocument()=>print('Tranıyor');
}