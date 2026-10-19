
import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/transation_model.dart';

class MarketsGridListScreen extends StatelessWidget {
  const MarketsGridListScreen({super.key});

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

  static const List<TransactionItem> transactions = [
    TransactionItem(
      id: 'tx_1',
      title: 'Apple Store',
      category: 'Teknoloji',
      date: 'Bugün 14:20',
      amount: 64500.00,
      isExpense: true,
      icon: Icons.laptop_mac,
    ),
    TransactionItem(
      id: 'tx_2',
      title: 'Kodusta Danışmanlık Hakediş',
      category: 'Kurumsal Gelir',
      date: 'Dün 09:00',
      amount: 125000.00,
      isExpense: false,
      icon: Icons.account_balance,
    ),
    TransactionItem(
      id: 'tx_3',
      title: 'Market Alışverişi',
      category: 'Alışveriş',
      date: 'Dün 18:30',
      amount: 2450.00,
      isExpense: true,
      icon: Icons.shopping_cart,
    ),
    TransactionItem(
      id: 'tx_4',
      title: 'Freelance Proje Ödemesi',
      category: 'Yazılım Geliri',
      date: '12 Ekim 11:00',
      amount: 18000.00,
      isExpense: false,
      icon: Icons.payments,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Piyasalar',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Varlıkların GridView ile gösterimi
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: assets.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final asset = assets[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        asset.symbol,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(asset.name),
                      Text(
                        '\$${asset.price.toStringAsFixed(2)}',
                      ),
                      Text(
                        '${asset.change24h}%',
                        style: TextStyle(
                          color: asset.change24h >= 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

          const Text(
            'Son İşlemler',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // İşlemlerin ListView ile gösterimi
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(transaction.icon),
                  ),
                  title: Text(transaction.title),
                  subtitle: Text(
                    '${transaction.category} • ${transaction.date}',
                  ),
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
