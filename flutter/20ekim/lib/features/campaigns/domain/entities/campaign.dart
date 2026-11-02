/// Kiralama firmalarının sunduğu indirim fırsatlarını ve kampanya iş kurallarını temsil eden varlık (Entity).
class Campaign {
  /// Kampanyanın benzersiz kimliği.
  final String id;

  /// Kampanyayı tanımlayan firmanın kimliği.
  final String companyId;

  /// Kampanya başlığı (örn. "Bahar İndirimi %15").
  final String title;

  /// Kampanya açıklaması ve şartları.
  final String description;

  /// Yüzde olarak indirim oranı (örn. 15 = %15 indirim).
  final int discountPercent;

  /// Kampanyanın geçerlilik başlangıç tarihi.
  final DateTime validFrom;

  /// Kampanyanın geçerlilik bitiş tarihi.
  final DateTime validTo;

  /// Kampanyanın geçerli olduğu belirli araç ID'leri listesi (null veya boş ise firmanın tüm araçlarında geçerlidir).
  final List<String>? eligibleVehicleIds;

  /// Kampanyanın aktiflik durumu.
  final bool active;

  const Campaign({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.discountPercent,
    required this.validFrom,
    required this.validTo,
    this.eligibleVehicleIds,
    this.active = true,
  });

  /// Verilen araç ve kiralama tarih aralığı için bu kampanyanın uygulanabilir olup olmadığını denetler.
  bool isEligibleFor(String vehicleId, DateTime startAt, DateTime endAt) {
    if (!active) return false;
    // Kiralama aralığı kampanyanın geçerlilik tarihleri içerisinde olmalıdır
    if (startAt.isBefore(validFrom) || endAt.isAfter(validTo)) {
      return false;
    }
    // Belirli araç kısıtlaması varsa kontrol edilir
    if (eligibleVehicleIds != null && eligibleVehicleIds!.isNotEmpty) {
      return eligibleVehicleIds!.contains(vehicleId);
    }
    return true;
  }

  /// Belirli alanları güncelleyerek yeni bir [Campaign] nesnesi üretir.
  Campaign copyWith({
    String? id,
    String? companyId,
    String? title,
    String? description,
    int? discountPercent,
    DateTime? validFrom,
    DateTime? validTo,
    List<String>? eligibleVehicleIds,
    bool? active,
  }) {
    return Campaign(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      description: description ?? this.description,
      discountPercent: discountPercent ?? this.discountPercent,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      eligibleVehicleIds: eligibleVehicleIds ?? this.eligibleVehicleIds,
      active: active ?? this.active,
    );
  }
}
