/// Alışkanlık hedefinin ölçüm türü.
///
/// `project.md` 5.7. Bölüm kurallarına göre 3 farklı hedef türü desteklenir:
/// 1. [boolean]: Evet / Hayır (Örn: Diş fırçalama, yatak toplama)
/// 2. [quantity]: Sayısal miktar (Örn: 20 sayfa kitap, 2000 ml su)
/// 3. [duration]: Süre (Örn: 30 dakika yürüyüş, 10 dakika meditasyon)
enum MeasurementType {
  boolean,
  quantity,
  duration;

  /// Kullanıcı arayüzünde görüntülenecek Türkçe başlık
  String get displayName {
    switch (this) {
      case MeasurementType.boolean:
        return 'Evet / Hayır';
      case MeasurementType.quantity:
        return 'Miktar';
      case MeasurementType.duration:
        return 'Süre';
    }
  }
}

/// Alışkanlığın tekrarlanma sıklığı.
///
/// `project.md` 5.7. Bölüm kurallarına göre:
/// - [everyday]: Haftanın her günü (Pazartesi - Pazar)
/// - [weekdays]: Sadece hafta içi günleri (Pazartesi - Cuma)
/// - [customDays]: Kullanıcının özel olarak seçtiği günler (1 = Pazartesi, 7 = Pazar)
enum FrequencyType {
  everyday,
  weekdays,
  customDays;

  /// Kullanıcı arayüzünde görüntülenecek Türkçe başlık
  String get displayName {
    switch (this) {
      case FrequencyType.everyday:
        return 'Her gün';
      case FrequencyType.weekdays:
        return 'Hafta içi';
      case FrequencyType.customDays:
        return 'Seçilen günler';
    }
  }
}

/// Alışkanlığın genel yaşam döngüsü durumu.
enum HabitStatus {
  /// Alışkanlık aktif olarak takip ediliyor
  active,

  /// Alışkanlık geçici olarak duraklatıldı
  paused,

  /// Alışkanlık arşivlendi (arşiv listesinde saklanır)
  archived,
}

/// Alışkanlık sürecinin (yolculuğunun) durumu.
enum ProcessStatus {
  /// Süreç devam ediyor ve yapboz parçaları açılıyor
  active,

  /// Süreç başarıyla tamamlandı (tüm parçalar açıldı)
  completed,

  /// Süreç süresi bitti ancak tüm parçalar açılamadı (Yarım Kalan Hikâyeler)
  endedIncomplete,
}

/// Temel Alışkanlık Bilgi Modeli.
///
/// `project.md` 14. Bölüm (Veri Modelleri - Habit) gereksinimlerine göre tanımlanmıştır.
class HabitModel {
  /// Alışkanlığın benzersiz kimliği
  final String id;

  /// Alışkanlığın sahibi olan kullanıcının kimliği
  final String userId;

  /// Alışkanlığın adı (Örn: 'Kitap Okumak')
  final String name;

  /// Kategori başlığı (Örn: 'Kişisel Gelişim', 'Spor')
  final String category;

  /// İkon anahtarı (Örn: 'book', 'water', 'run')
  final String icon;

  /// Renk değeri (Hex integer, örn: 0xFF344E41)
  final int colorValue;

  /// Hedef ölçüm türü ([MeasurementType.boolean], [MeasurementType.quantity], [MeasurementType.duration])
  final MeasurementType measurementType;

  /// Hedef birimi (Örn: 'sayfa', 'dk', 'bardak', 'adım')
  final String unit;

  /// Alışkanlığın aktif/arşiv durumu
  final HabitStatus status;

  /// Oluşturulma tarihi
  final DateTime createdAt;

  const HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.icon,
    required this.colorValue,
    required this.measurementType,
    required this.unit,
    this.status = HabitStatus.active,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'category': category,
        'icon': icon,
        'colorValue': colorValue,
        'measurementType': measurementType.name,
        'unit': unit,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        icon: json['icon'] as String,
        colorValue: json['colorValue'] as int,
        measurementType: MeasurementType.values.byName(json['measurementType'] as String),
        unit: json['unit'] as String? ?? '',
        status: HabitStatus.values.byName(json['status'] as String? ?? 'active'),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  HabitModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? category,
    String? icon,
    int? colorValue,
    MeasurementType? measurementType,
    String? unit,
    HabitStatus? status,
    DateTime? createdAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      measurementType: measurementType ?? this.measurementType,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Alışkanlık Takvim ve Hedef Planlama Modeli.
///
/// `project.md` 14. Bölüm (HabitSchedule) gereksinimlerine göre tanımlanmıştır.
/// Alışkanlığın hangi günlerde uygulanacağını, günlük hedef miktarını ve hatırlatıcı saatini saklar.
class HabitScheduleModel {
  final String id;
  final String habitId;
  final FrequencyType frequency;
  final List<int> selectedDays; // 1 = Pazartesi, 7 = Pazar
  final double targetValue; // Günlük hedef miktarı (1.0, 20.0, 30.0 vb.)
  final DateTime startDate;
  final DateTime? endDate; // null ise süresiz alışkanlık
  final String? reminderTime; // 'HH:mm' formatında hatırlatma saati

  const HabitScheduleModel({
    required this.id,
    required this.habitId,
    required this.frequency,
    required this.selectedDays,
    required this.targetValue,
    required this.startDate,
    this.endDate,
    this.reminderTime,
  });

  /// Verilen tarihin bu takvim planında aktif bir gün olup olmadığını belirler.
  ///
  /// Başlangıç ve bitiş tarihlerini denetler, ardından frekans türüne göre
  /// (her gün, hafta içi veya seçilen günler) günün eşleşmesini kontrol eder.
  bool isScheduledOn(DateTime date) {
    if (date.isBefore(DateTime(startDate.year, startDate.month, startDate.day))) {
      return false;
    }
    if (endDate != null) {
      final end = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
      if (date.isAfter(end)) return false;
    }

    switch (frequency) {
      case FrequencyType.everyday:
        return true;
      case FrequencyType.weekdays:
        return date.weekday >= 1 && date.weekday <= 5;
      case FrequencyType.customDays:
        return selectedDays.contains(date.weekday);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'habitId': habitId,
        'frequency': frequency.name,
        'selectedDays': selectedDays,
        'targetValue': targetValue,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'reminderTime': reminderTime,
      };

  factory HabitScheduleModel.fromJson(Map<String, dynamic> json) =>
      HabitScheduleModel(
        id: json['id'] as String,
        habitId: json['habitId'] as String,
        frequency: FrequencyType.values.byName(json['frequency'] as String),
        selectedDays: (json['selectedDays'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [1, 2, 3, 4, 5, 6, 7],
        targetValue: (json['targetValue'] as num).toDouble(),
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : null,
        reminderTime: json['reminderTime'] as String?,
      );
}

/// Alışkanlık Süreci (Dönemi) Modeli.
///
/// `project.md` 14. Bölüm (HabitProcess) gereksinimlerine göre tanımlanmıştır.
/// Her süreç, belirli bir gizli yapboz ile birebir eşleşir.
/// [plannedDays] sayısı, yapbozun toplam parça sayısını belirler.
class HabitProcessModel {
  final String id;
  final String habitId;
  final DateTime startDate;
  final DateTime? endDate;

  /// Toplam planlanan başarılı gün sayısı (Gizli yapbozun toplam parça sayısına denktir)
  final int plannedDays;

  /// Başarıyla tamamlanan gün sayısı (Açılan yapboz parçası sayısına denktir)
  final int completedDays;

  /// Sürecin aktif, tamamlandı veya yarım kaldı durumu
  final ProcessStatus status;

  const HabitProcessModel({
    required this.id,
    required this.habitId,
    required this.startDate,
    this.endDate,
    required this.plannedDays,
    this.completedDays = 0,
    this.status = ProcessStatus.active,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'habitId': habitId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'plannedDays': plannedDays,
        'completedDays': completedDays,
        'status': status.name,
      };

  factory HabitProcessModel.fromJson(Map<String, dynamic> json) =>
      HabitProcessModel(
        id: json['id'] as String,
        habitId: json['habitId'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : null,
        plannedDays: json['plannedDays'] as int,
        completedDays: json['completedDays'] as int? ?? 0,
        status: ProcessStatus.values.byName(json['status'] as String? ?? 'active'),
      );

  HabitProcessModel copyWith({
    String? id,
    String? habitId,
    DateTime? startDate,
    DateTime? endDate,
    int? plannedDays,
    int? completedDays,
    ProcessStatus? status,
  }) {
    return HabitProcessModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      plannedDays: plannedDays ?? this.plannedDays,
      completedDays: completedDays ?? this.completedDays,
      status: status ?? this.status,
    );
  }
}

/// Günlük İlerleme Kayıt Modeli.
///
/// `project.md` 6. Bölüm (Alışkanlık Yönetimi - Günlük İlerleme Kuralları) ve
/// 14. Bölüm (DailyProgress) kurallarına göre tanımlanmıştır.
///
/// Temel Kurallar:
/// - Kısmi ilerleme kaydedilir (ör. 10/20 sayfa).
/// - Hedef tamamlandığında ([actualValue] >= [targetValue]) gün başarılı sayılır ([isCompleted] = true).
/// - Gün başarılı olunca yapboz parçası açılır.
/// - Hedefin aşılması ertesi güne aktarılmaz veya ek parça kazandırmaz.
class DailyProgressModel {
  final String id;
  final String processId;
  final String habitId;
  final String date; // 'YYYY-MM-DD' ISO formatında tarih
  final double targetValue; // O günkü hedef miktar
  final double actualValue; // Kullanıcının gerçekleştirdiği fiili miktar
  final bool isCompleted; // Hedefin tamamlanıp tamamlanmadığı
  final DateTime? completedAt; // Tamamlanma anı

  const DailyProgressModel({
    required this.id,
    required this.processId,
    required this.habitId,
    required this.date,
    required this.targetValue,
    required this.actualValue,
    required this.isCompleted,
    this.completedAt,
  });

  /// Günlük hedefe ulaşma oranı (0.0 ile 1.0 arasında sınırlandırılmış)
  double get progressRatio {
    if (targetValue <= 0) return 0.0;
    return (actualValue / targetValue).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'processId': processId,
        'habitId': habitId,
        'date': date,
        'targetValue': targetValue,
        'actualValue': actualValue,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory DailyProgressModel.fromJson(Map<String, dynamic> json) =>
      DailyProgressModel(
        id: json['id'] as String,
        processId: json['processId'] as String,
        habitId: json['habitId'] as String? ?? '',
        date: json['date'] as String,
        targetValue: (json['targetValue'] as num).toDouble(),
        actualValue: (json['actualValue'] as num).toDouble(),
        isCompleted: json['isCompleted'] as bool,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
      );

  DailyProgressModel copyWith({
    String? id,
    String? processId,
    String? habitId,
    String? date,
    double? targetValue,
    double? actualValue,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return DailyProgressModel(
      id: id ?? this.id,
      processId: processId ?? this.processId,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      targetValue: targetValue ?? this.targetValue,
      actualValue: actualValue ?? this.actualValue,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
