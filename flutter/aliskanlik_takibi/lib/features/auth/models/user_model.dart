/// Ritmo Kullanıcı Bilgi Modeli.
///
/// `project.md` 14. Bölüm (Veri Modelleri - User) gereksinimlerine göre tanımlanmıştır.
/// Kullanıcının benzersiz kimliğini, ad-soyadını, e-posta adresini ve
/// hesabın oluşturulma zamanını temsil eder.
class UserModel {
  /// Kullanıcının benzersiz kimlik belirteci (Örn: 'usr_1730000000')
  final String id;

  /// Kullanıcının adı
  final String firstName;

  /// Kullanıcının soyadı
  final String lastName;

  /// Kullanıcının giriş için kullandığı e-posta adresi
  final String email;

  /// Hesabın oluşturulduğu tarih ve saat
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.createdAt,
  });

  /// Kullanıcının ad ve soyadını birleştirerek tam isim olarak döndürür.
  String get fullName => '$firstName $lastName'.trim();

  /// Modeli yerel depolamada saklanmak üzere JSON haritasına dönüştürür.
  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': createdAt.toIso8601String(),
      };

  /// JSON haritasından yeni bir [UserModel] nesnesi oluşturur.
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  /// Mevcut modelin belirli alanlarını güncelleyerek kopyasını oluşturur (Immutability deseni).
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
