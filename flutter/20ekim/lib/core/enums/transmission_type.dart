/// Araçların vites türlerini temsil eden numaralandırma.
enum TransmissionType {
  /// Otomatik vitesli araç.
  automatic('Otomatik'),

  /// Manuel (düz) vitesli araç.
  manual('Manuel');

  /// Arayüzde görüntülenecek Türkçe metin etiketi.
  final String label;

  const TransmissionType(this.label);
}
