/// Araçların yakıt türlerini temsil eden numaralandırma.
enum FuelType {
  /// Benzinli motor.
  gasoline('Benzin'),

  /// Dizel motor.
  diesel('Dizel'),

  /// Hibrit (benzin + elektrik) motor.
  hybrid('Hibrit'),

  /// Tamamen elektrikli motor.
  electric('Elektrik');

  /// Arayüzde görüntülenecek Türkçe metin etiketi.
  final String label;

  const FuelType(this.label);
}
