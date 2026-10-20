enum FuelType {
  gasoline('Benzin'),
  diesel('Dizel'),
  hybrid('Hibrit'),
  electric('Elektrik');

  final String label;
  const FuelType(this.label);
}
