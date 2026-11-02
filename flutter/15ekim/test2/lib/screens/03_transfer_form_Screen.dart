import 'package:flutter/material.dart';
import '../models/transation_model.dart';

/// Para transferi işlemlerini, form yönetimini ve dinamik liste güncellemelerini
/// gösteren ekran widget'ı.
///
/// Bu ekranda; Form ve TextFormField kullanımı, form doğrulama (validation),
/// showModalBottomSheet ile alt pencere açma, TextEditingController yönetimi,
/// ve setState ile bakiye ve işlem geçmişini canlı güncelleme mekanizmaları gösterilir.
class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({super.key});

  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  /// Kullanıcının mevcut hesap bakiyesi.
  /// Yapılan her transfer sonrasında bu tutardan düşülür.
  double _balance = 148950.00;

  /// İşlem geçmişini tutan dinamik liste.
  /// Yeni bir transfer yapıldığında listenin başına  yeni kayıt eklenir.
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


  // PARA TRANSFERİ BOTTOMSHEET (ALT FORM PENCERESİ)
  /// Ekranın altından yukarı doğru açılan (Modal Bottom Sheet) transfer formunu açar.
  void _openTransferModel() {
    // Formun geçerlilik durumunu denetlemek için kullanılan anahtar (GlobalKey)
    final formKey = GlobalKey<FormState>();

    // Kullanıcının girdiği metinleri okumak için controller nesneleri
    final receiverController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      // isScrollControlled: true -> Klavye açıldığında formun yukarı kayabilmesini sağlar
      isScrollControlled: true,
      // useSafeArea: true -> Cihazın çentik ve alt navigasyon barı gibi alanlarını korur
      useSafeArea: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            24,
            20,
            // Klavye yüksekliğini hesaba katarak alt boşluk bırakır (klavyenin altında kalmayı önler)
            MediaQuery.viewInsetsOf(sheetContext).bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey, // Form doğrulaması için GlobalKey bağlandı
              child: Column(
                mainAxisSize: MainAxisSize.min, // Sadece içerik kadar yer kapla
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Başlığı
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

                  // 1. Alıcı Adı Giriş Alanı
                  TextFormField(
                    controller: receiverController,
                    decoration: const InputDecoration(
                      labelText: 'Alıcı Adı',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    // Doğrulama kuralı: Boş olamaz
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Alıcı adı boş bırakılamaz';
                      }
                      return null; // Hata yok anlamına gelir
                    },
                  ),

                  const SizedBox(height: 16),

                  // 2. Transfer Tutarı Giriş Alanı
                  TextFormField(
                    controller: amountController,
                    // Sayısal klavyeyi açar ve ondalık sayı girişine izin verir
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Transfer Tutarı',
                      prefixIcon: Icon(Icons.payments_outlined),
                      suffixText: '₺',
                      border: OutlineInputBorder(),
                    ),
                    // Doğrulama kuralları: Boş olamaz, sayı olmalı, sıfırdan büyük olmalı ve bakiyeyi aşmamalı
                    validator: (value) {
                      final amount = double.tryParse(
                        (value ?? '')
                            .trim()
                            .replaceAll(',', '.'), // Virgülü noktaya çevirerek ayrıştırmayı garantiye al
                      );

                      if (amount == null ||
                          !amount.isFinite ||
                          amount <= 0) {
                        return 'Geçerli bir tutar giriniz';
                      }

                      // Bakiye kontrolü
                      if (amount > _balance) {
                        return 'Yetersiz bakiye';
                      }

                      return null; // Başarılı doğrulama
                    },
                  ),

                  const SizedBox(height: 16),

                  // 3. Açıklama Giriş Alanı (İsteğe bağlı)
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 2, // 2 satırlık geniş alan
                    decoration: const InputDecoration(
                      labelText: 'Açıklama',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. Transferi Onaylama Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Form alanlarındaki validator fonksiyonlarını çalıştırır
                        // Eğer kurallara uymayan bir alan varsa işlemi durdurur
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        // Form verilerini değişkenlere al
                        final receiver = receiverController.text.trim();
                        final amount = double.parse(
                          amountController.text
                              .trim()
                              .replaceAll(',', '.'),
                        );
                        final description = descriptionController.text.trim();

                        // Ekran durumunu güncelle
                        setState(() {
                          // 1. Bakiyeyi transfer tutarı kadar azalt
                          _balance -= amount;

                          // 2. Yeni işlemi listenin en başına (index 0) ekle
                          _history.insert(
                            0,
                            TransactionItem(
                              // Zaman damgası kullanarak benzersiz bir id oluşturulur
                              id: 'tx_${DateTime.now().microsecondsSinceEpoch}',
                              title: receiver,
                              category: description.isEmpty
                                  ? 'Para Transferi'
                                  : description,
                              date: 'Az önce',
                              amount: amount,
                              isExpense: true, // Para çıkışı olduğu için gider olarak işaretlenir
                              icon: Icons.send,
                            ),
                          );
                        });

                        // Form penceresini (BottomSheet) kapat
                        Navigator.pop(sheetContext);

                        // Kullanıcıya yeşil renkli başarı SnackBar'ı göster
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
      // BottomSheet kapatıldığında controller nesnelerini bellekten temizler (memory leak önlemi)
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
          // 1. Güncel bakiye kartı
          _buildBalanceCard(),

          const SizedBox(height: 24),

          // 2. Transfer modalını açan buton
          _buildTransferButton(),

          const SizedBox(height: 32),

          // 3. Geçmiş transfer işlemleri listesi
          _buildTransactionHistory(),
        ],
      ),
    );
  }
  // BAKİYE KARTI BİLEŞENİ
  /// Kullanıcının kalan toplam bakiyesini gösteren mor kart widget'ı.
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

          // Anlık güncellenen bakiye (virgülden sonra iki basamak formatlı)
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

  // TRANSFER BUTONU BİLEŞENİ
  /// Modal form penceresini tetikleyen ana aksiyon butonu.
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

  // İŞLEM GEÇMİŞİ LİSTE BİLEŞENİ
  /// Yapılan transferlerin ve harcamaların listelendiği bölüm.
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

        // İşlem listesini dinamik olarak oluşturan ListView.builder
        ListView.builder(
          shrinkWrap: true, // Liste boyutunu içeriğe göre ayarla
          physics: const NeverScrollableScrollPhysics(), // Kaydırma çatışmasını önle
          itemCount: _history.length,
          itemBuilder: (context, index) {
            final transaction = _history[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                // Sol taraftaki yuvarlak ikon alanı: Gider ise açık kırmızı, gelir ise açık yeşil arka plan
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
                // Alıcı veya işlem adı
                title: Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Kategori ve tarih bilgisi
                subtitle: Text(
                  '${transaction.category} • ${transaction.date}',
                ),
                // Tutar gösterimi ve renk biçimlendirmesi
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
