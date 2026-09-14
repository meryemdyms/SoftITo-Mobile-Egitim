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
