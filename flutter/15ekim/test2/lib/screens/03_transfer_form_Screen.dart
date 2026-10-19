
import 'package:flutter/material.dart';
import '../models/transation_model.dart';

class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({super.key});

  @override
  State<TransferFormScreen> createState() =>
      _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  double _balance = 148950.00;

  final List<TransactionItem> _history = [
    const TransactionItem(
      id: 'tx_init_1',
      title: 'Apple Store',
      category: 'Teknoloji',
      date: 'Bugün 14:20',
      amount: 64500.00,
      isExpense: true,
      icon: Icons.laptop_mac,
    ),
    const TransactionItem(
      id: 'tx_init_2',
      title: 'Kodusta Danışmanlık Hakediş',
      category: 'Kurumsal Gelir',
      date: 'Dün 09:00',
      amount: 125000.00,
      isExpense: false,
      icon: Icons.account_balance,
    ),
    const TransactionItem(
      id: 'tx_init_3',
      title: 'Market Alışverişi',
      category: 'Alışveriş',
      date: 'Dün 18:30',
      amount: 2450.00,
      isExpense: true,
      icon: Icons.shopping_cart,
    ),
    const TransactionItem(
      id: 'tx_init_4',
      title: 'Freelance Proje Ödemesi',
      category: 'Yazılım Geliri',
      date: '12 Ekim 11:00',
      amount: 18000.00,
      isExpense: false,
      icon: Icons.payments,
    ),
  ];

  // Para Transferi BottomSheet
  void _openTransferModel() {
    final formKey = GlobalKey<FormState>();

    final receiverController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            24,
            20,
            MediaQuery.viewInsetsOf(sheetContext).bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yeni Para Transferi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Transfer bilgilerini giriniz.',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Alıcı Adı
                  TextFormField(
                    controller: receiverController,
                    decoration: const InputDecoration(
                      labelText: 'Alıcı Adı',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Alıcı adı boş bırakılamaz';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Transfer Tutarı
                  TextFormField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Transfer Tutarı',
                      prefixIcon: Icon(Icons.payments_outlined),
                      suffixText: '₺',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final amount = double.tryParse(
                        (value ?? '')
                            .trim()
                            .replaceAll(',', '.'),
                      );

                      if (amount == null ||
                          !amount.isFinite ||
                          amount <= 0) {
                        return 'Geçerli bir tutar giriniz';
                      }

                      if (amount > _balance) {
                        return 'Yetersiz bakiye';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Açıklama
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Açıklama',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Transfer Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        final receiver =
                            receiverController.text.trim();

                        final amount = double.parse(
                          amountController.text
                              .trim()
                              .replaceAll(',', '.'),
                        );

                        final description =
                            descriptionController.text.trim();

                        setState(() {
                          // Bakiyeyi azalt
                          _balance -= amount;

                          // Yeni işlemi geçmişe ekle
                          _history.insert(
                            0,
                            TransactionItem(
                              id: 'tx_${DateTime.now().microsecondsSinceEpoch}',
                              title: receiver,
                              category: description.isEmpty
                                  ? 'Para Transferi'
                                  : description,
                              date: 'Az önce',
                              amount: amount,
                              isExpense: true,
                              icon: Icons.send,
                            ),
                          );
                        });

                        Navigator.pop(sheetContext);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$receiver için '
                              '₺${amount.toStringAsFixed(2)} '
                              'tutarında demo transfer oluşturuldu.',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Transfer Yap'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      // BottomSheet kapandıktan sonra controller'ları temizle
      receiverController.dispose();
      amountController.dispose();
      descriptionController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bakiye Kartı
          _buildBalanceCard(),

          const SizedBox(height: 24),

          // Transfer Butonu
          _buildTransferButton(),

          const SizedBox(height: 32),

          // İşlem Geçmişi
          _buildTransactionHistory(),
        ],
      ),
    );
  }

  // Bakiye Kartı
  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Toplam Bakiye',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '₺${_balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Transfer Butonu
  Widget _buildTransferButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _openTransferModel,
        icon: const Icon(Icons.send),
        label: const Text('Yeni Transfer'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // İşlem Geçmişi
  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'İşlem Geçmişi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _history.length,
          itemBuilder: (context, index) {
            final transaction = _history[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: transaction.isExpense
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  child: Icon(
                    transaction.icon,
                    color: transaction.isExpense
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
                title: Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
    );
  }
}
