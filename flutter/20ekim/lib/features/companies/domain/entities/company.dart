/// Platformda araç listeleyen bağımsız araç kiralama firması varlığı (Entity).
class Company {
  /// Firmanın benzersiz kimliği.
  final String id;

  /// Bu firmanın sahibi olan kullanıcının ID'si (yetkilendirme kontrolünde kullanılır).
  final String ownerUserId;

  /// Firma ticari ünvanı veya marka adı.
  final String name;

  /// Firma logo görsel URL'si veya asset yolu.
  final String logo;

  /// Firma hakkında tanıtım açıklaması.
  final String description;

  /// Firmanın ofis açık adresi.
  final String address;

  /// Harita konumu için enlem (latitude) değeri.
  final double latitude;

  /// Harita konumu için boylam (longitude) değeri.
  final double longitude;

  /// Çalışma saatleri (örn. "08:30 - 20:00").
  final String openingHours;

  /// İletişim telefon numarası.
  final String phone;

  /// Firmanın sistemde aktif olup olmadığı.
  final bool active;

  const Company({
    required this.id,
    required this.ownerUserId,
    required this.name,
    required this.logo,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.openingHours,
    required this.phone,
    this.active = true,
  });

  /// Belirli alanları güncelleyerek yeni bir [Company] nesnesi üretir.
  Company copyWith({
    String? id,
    String? ownerUserId,
    String? name,
    String? logo,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? openingHours,
    String? phone,
    bool? active,
  }) {
    return Company(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingHours: openingHours ?? this.openingHours,
      phone: phone ?? this.phone,
      active: active ?? this.active,
    );
  }
}
