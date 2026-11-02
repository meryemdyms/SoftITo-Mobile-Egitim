/// Ritmo Alışkanlık Hatırlatıcı ve Bildirim Tercih Modeli.
///
/// `project.md` 11. (Bildirim Sistemi) ve 14. (Veri Modelleri - NotificationPreference)
/// bölümlerine uygun olarak tanımlanmıştır. Her alışkanlık için kullanıcının belirlediği
/// hatırlatma saati ve bildirim açık/kapalı durumunu yönetir.
class NotificationPreferenceModel {
  /// Tercih kaydının benzersiz kimliği
  final String id;

  /// Bildirimin bağlı olduğu alışkanlığın kimliği
  final String habitId;

  /// Bildirimde kullanıcıya sunulacak alışkanlık adı
  final String habitName;

  /// Hatırlatıcının aktif olup olmadığı
  final bool enabled;

  /// Hatırlatma saati ('HH:mm' formatında, örn: '08:30')
  final String reminderTime;

  const NotificationPreferenceModel({
    required this.id,
    required this.habitId,
    required this.habitName,
    this.enabled = true,
    required this.reminderTime,
  });

  /// Modeli yerel depolama için JSON haritasına dönüştürür.
  Map<String, dynamic> toJson() => {
        'id': id,
        'habitId': habitId,
        'habitName': habitName,
        'enabled': enabled,
        'reminderTime': reminderTime,
      };

  /// JSON haritasından yeni bir [NotificationPreferenceModel] nesnesi üretir.
  factory NotificationPreferenceModel.fromJson(Map<String, dynamic> json) =>
      NotificationPreferenceModel(
        id: json['id'] as String,
        habitId: json['habitId'] as String,
        habitName: json['habitName'] as String,
        enabled: json['enabled'] as bool? ?? true,
        reminderTime: json['reminderTime'] as String? ?? '09:00',
      );

  /// Mevcut modelin kopyasını güncellenmiş alanlarla oluşturur.
  NotificationPreferenceModel copyWith({
    String? id,
    String? habitId,
    String? habitName,
    bool? enabled,
    String? reminderTime,
  }) {
    return NotificationPreferenceModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      habitName: habitName ?? this.habitName,
      enabled: enabled ?? this.enabled,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
