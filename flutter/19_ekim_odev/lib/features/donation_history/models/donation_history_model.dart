import 'package:flutter/foundation.dart';

/// Tek bir kan bağışı kaydını temsil eden değiştirilemez model sınıfı.
@immutable
class DonationRecord {
  const DonationRecord({
    required this.id,
    required this.date,
    required this.hospitalName,
    required this.city,
    required this.donationType,
    this.units = 1,
    this.status = 'Tamamlandı',
    this.notes = '',
  });

  /// Bağış kaydının benzersiz kimliği
  final String id;

  /// Bağışın gerçekleştirildiği tarih
  final DateTime date;

  /// Bağışın yapıldığı hastane veya Kızılay kan merkezi adı
  final String hospitalName;

  /// Bağışın yapıldığı il/ilçe
  final String city;

  /// Bağış türü ('Tam Kan', 'Trombosit', 'Plazma')
  final String donationType;

  /// Bağışlanan ünite miktarı (varsayılan: 1)
  final int units;

  /// İşlem durumu (örn: 'Tamamlandı', 'İnceleniyor')
  final String status;

  /// Ek açıklama veya notlar
  final String notes;

  /// Mevcut kaydı kopyalayıp güncellenmiş yeni bir nesne oluşturur.
  DonationRecord copyWith({
    String? id,
    DateTime? date,
    String? hospitalName,
    String? city,
    String? donationType,
    int? units,
    String? status,
    String? notes,
  }) {
    return DonationRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      hospitalName: hospitalName ?? this.hospitalName,
      city: city ?? this.city,
      donationType: donationType ?? this.donationType,
      units: units ?? this.units,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

/// Bağış geçmişi ekranının durumunu (State) saklayan sınıf.
@immutable
class DonationHistoryState {
  const DonationHistoryState({
    this.records = const [],
    this.isLoading = false,
  });

  /// Geçmiş bağış kayıtları listesi
  final List<DonationRecord> records;

  /// Verilerin yüklenme durumu
  final bool isLoading;

  /// Tüm geçmiş kayıtlardaki toplam bağışlanan ünite sayısı
  int get totalUnits => records.fold(0, (sum, item) => sum + item.units);

  /// Durum nesnesini kopyalamak için yardımcı metot.
  DonationHistoryState copyWith({
    List<DonationRecord>? records,
    bool? isLoading,
  }) {
    return DonationHistoryState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

