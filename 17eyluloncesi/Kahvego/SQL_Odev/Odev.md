
    //Tablo oluşturma
    CREATE TABLE users ( 
    id INT AUTO_INCREMENT PRIMARY KEY, 
    fullname VARCHAR(100) NOT NULL, 
    email VARCHAR(150) NOT NULL 
    );

    //Tabloya eleman ekleme
    NSERT INTO users (fullname, email) VALUES 
    ('Meryem Duymuş', 'meryem@example.com'), 
    ('Mualla Duymuş', 'mualla@example.com'), 
    ('Mücella Duymuş', 'mücella@example.com');

    //Tablodaki tüm elemanları listeleme
    SELECT * FROM users;

    //Tablodaki değeri güncelleme
    UPDATE users
    SET email = 'meryemdyms@example.com'
    WHERE id = 1;
   
   //Tablodan veri silme
    DELETE FROM users
    WHERE id = 3;


    //INNER JOIN
    CREATE TABLE orders 
    ( id INT AUTO_INCREMENT PRIMARY KEY, 
    user_id INT NOT NULL, 
    order_number VARCHAR(50) NOT NULL, 
    FOREIGN KEY (user_id) REFERENCES users(id) 
    );
   
   INSERT INTO orders (user_id, order_number) VALUES 
   (1, 'ORD001'), 
   (1, 'ORD002'), 
   (2, 'ORD003');


   SELECT 
   users.fullname, 
   users.email, 
   orders.order_number
   FROM users 
   INNER JOIN orders 
   ON users.id = orders.user_id;


3. Mobil Uygulama Güvenliği

a) Ekran görüntüsü ve ekran kaydı
Kredi kartı bilgileri ve bakiye gibi veriler kişisel ve hassas bilgilerdir. Ekran görüntüsü veya ekran kaydı alınırsa bu bilgiler başka kişilerle paylaşılabilir. Bu durum dolandırıcılık ve hesap güvenliği riski oluşturur. Bu yüzden bankacılık uygulamalarında ekran görüntüsü ve ekran kaydının engellenmesi kullanıcı güvenliği açısından önemlidir.

Android: FLAG_SECURE kullanılır. Ekran görüntüsü ve ekran kaydı alınmasını engeller.
iOS: UIScreen.main.isCaptured kullanılabilir. Ekran kaydı algılandığında hassas içerikler gizlenebilir. iOS’ta Android’deki FLAG_SECURE gibi ekran görüntüsünü tamamen engelleyen doğrudan bir mekanizma yoktur.

b) Overlay saldırıları
Root veya Jailbreak yapılan cihazlarda sistemin normal güvenlik kısıtlamaları kaldırılır. Bu nedenle kötü amaçlı uygulamalar daha fazla yetkiye sahip olabilir, diğer uygulamaların verilerine erişebilir veya güvenlik kontrollerini aşabilir. Bu da özellikle bankacılık uygulamalarında kullanıcı bilgileri için daha büyük risk oluşturur.

Örneğin root edilmiş bir cihazda saldırgan, bankacılık uygulamasının sakladığı oturum tokenı, kullanıcı bilgileri veya geçici verileri uygulamanın dosyalarından okuyabilir. Bu bilgiler ele geçirilirse kullanıcı hesabına izinsiz erişim sağlanabilir.

d) SQLite ve şifreleme
Normal SQLite veritabanında bilgiler düz metin olarak tutulursa, veritabanı dosyasına erişen biri kullanıcı bilgilerini doğrudan okuyabilir.
SQLCipher kullanıldığında veritabanı şifrelenir. Böylece dosya ele geçirilse bile doğru şifreleme anahtarı olmadan içindeki verileri okumak çok daha zor olur.

e) Access Token ve Refresh Token
Access Token, kullanıcının uygulamada işlem yapabilmesi için kullanılan kısa süreli bir anahtardır. Kısa süreli tutulmasının nedeni, ele geçirilirse saldırganın bu anahtarı uzun süre kullanmasını engellemektir.
Refresh Token ise süresi dolan Access Token’ı yenilemek için kullanılır. Daha uzun süre geçerli olduğu için daha güvenli bir yerde saklanmalıdır.
Kullanıcı çıkış yaptığında Refresh Token iptal edilirse, artık yeni Access Token üretilemez. Böylece oturum tamamen sonlandırılmış olur