import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/transation_model.dart';

/// Piyasalar ve son finansal işlemleri listeleyen ekran widget'ı.
///
/// Bu ekran; Flutter'da liste ve ızgara yapılarını (`GridView.builder` ve `ListView.builder`),
/// `Card`, `ListTile` bileşenlerini ve harici veri modellerinin (`Asset`, `TransactionItem`)
/// arayüzde nasıl gösterileceğini ve koşullu renklendirmeyi örnekler.
class MarketsGridListScreen extends StatelessWidget {
  const MarketsGridListScreen({super.key});

  /// Piyasalarda listelenecek kripto para / varlık mock (örnek) verileri
  static const List<Asset> assets = [
    Asset(
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 67420.00,
      change24h: 4.20,
      balance: 0.4,
    ),
    Asset(
      symbol: 'ETH',
      name: 'Ethereum',
      price: 3500.00,
      change24h: -1.80,
      balance: 4.20,
    ),
    Asset(
      symbol: 'SOL',
      name: 'Solana',
      price: 200.00,
      change24h: 0.5,
      balance: 85.00,
    ),
  ];

  /// Kullanıcının gerçekleştirdiği son finansal işlemleri temsil eden mock (örnek) veriler
  static const List<TransactionItem> transactions = [
    TransactionItem(
      id: 'tx_1',
      title: 'Apple Store',
      category: 'Teknoloji',
      date: 'Bugün 14:20',
      amount: 64500.00,
      isExpense: true, // Harcama (Gider)
      icon: Icons.laptop_mac,
    ),
    TransactionItem(
      id: 'tx_2',
      title: 'Kodusta Danışmanlık Hakediş',
      category: 'Kurumsal Gelir',
      date: 'Dün 09:00',
      amount: 125000.00,
      isExpense: false, // Gelir
      icon: Icons.account_balance,
    ),
    TransactionItem(
      id: 'tx_3',
      title: 'Market Alışverişi',
      category: 'Alışveriş',
      date: 'Dün 18:30',
      amount: 2450.00,
      isExpense: true, // Harcama (Gider)
      icon: Icons.shopping_cart,
    ),
    TransactionItem(
      id: 'tx_4',
      title: 'Freelance Proje Ödemesi',
      category: 'Yazılım Geliri',
      date: '12 Ekim 11:00',
      amount: 18000.00,
      isExpense: false, // Gelir
      icon: Icons.payments,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Sayfanın tamamının dikey olarak kaydırılabilmesini sağlar
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          // 1. PİYASALAR BAŞLIĞI VE GRID GÖRÜNÜMÜ
          const Text(
            'Piyasalar',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Varlıkların 2 sütunlu ızgara (GridView) ile gösterimi
          GridView.builder(
            // shrinkWrap: true -> Grid'in kendi içeriği kadar yer kaplamasını sağlar
            shrinkWrap: true,
            // NeverScrollableScrollPhysics -> GridView'in kendi kaydırmasını devre dışı bırakır,
            // böylece dıştaki SingleChildScrollView ile çakışma (scroll conflict) yaşanmaz.
            physics: const NeverScrollableScrollPhysics(),
            itemCount: assets.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Satır başına düşen kart sayısı (2 sütun)
              crossAxisSpacing: 12, // Kartlar arasındaki yatay boşluk
              mainAxisSpacing: 12, // Kartlar arasındaki dikey boşluk
              childAspectRatio: 1.3, // Kartların genişlik / yükseklik oranı
            ),
            itemBuilder: (context, index) {
              final asset = assets[index];

              // Her bir varlık kartı
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Sembol (Örn: BTC, ETH)
                      Text(
                        asset.symbol,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      // Varlık tam adı (Örn: Bitcoin)
                      Text(asset.name),
                      // Fiyat (2 ondalık basamaklı formatta)
                      Text(
                        '\$${asset.price.toStringAsFixed(2)}',
                      ),
                      // 24 saatlik değişim: Pozitifse yeşil (+), negatifse kırmızı (-) gösterilir
                      Text(
                        '${asset.change24h}%',
                        style: TextStyle(
                          color: asset.change24h >= 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Cüzdandaki mevcut bakiye
                      Text(
                        'Bakiye: ${asset.balance}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          
          // 2. SON İŞLEMLER BAŞLIĞI VE LİSTE GÖRÜNÜMÜ
          const Text(
            'Son İşlemler',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // İşlem geçmişinin ListView.builder ile dinamik olarak listelenmesi
          ListView.builder(
            // İçerik boyutu kadar yükseklik kapla
            shrinkWrap: true,
            // Kaydırma kontrolünü üstteki SingleChildScrollView'e devret
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];

              return Card(
                child: ListTile(
                  // Sol taraftaki yuvarlak ikon alanı
                  leading: CircleAvatar(
                    child: Icon(transaction.icon),
                  ),
                  // İşlem ana başlığı / alıcı adı
                  title: Text(transaction.title),
                  // Kategori ve tarih bilgisi
                  subtitle: Text(
                    '${transaction.category} • ${transaction.date}',
                  ),
                  // Sağ taraftaki tutar: Harcama ise kırmızı ve '-' işareti, gelir ise yeşil ve '+' işareti
                  trailing: Text(
                    '${transaction.isExpense ? "-" : "+"}'
                    '₺${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: transaction.isExpense
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
