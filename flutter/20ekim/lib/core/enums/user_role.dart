/// Sistemdeki kayıtlı kullanıcı rollerini temsil eden numaralandırma.
///
/// Misafir kullanıcılar oturumsuz durumu ifade eder, veri modelinde rol olarak tutulmaz.
enum UserRole {
  /// Bireysel araç kiralayan son kullanıcı rolü.
  customer('Müşteri'),

  /// Filo ve araç sahibi kiralama firması rolü.
  company('Firma');

  /// Arayüzde görüntülenecek Türkçe metin etiketi.
  final String label;

  const UserRole(this.label);
}
