//Asset modelimizi tanımladık
class Asset {
  final String symbol;
  final String name;
  final double price;

  /// Son 24 saatteki yüzdelik fiyat değişimi
  final double change24h;

  /// Kullanıcının bu varlıktan cüzdanında bulundurduğu miktar 
  final double balance;

  /// Asset sınıfının kurucu metodu (Constructor).
  const Asset({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change24h,
    required this.balance,
  });
}