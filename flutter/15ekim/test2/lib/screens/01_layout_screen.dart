import 'package:flutter/material.dart';

/// Flutter arayüz düzeni (Layout) ve stil (Styling) tekniklerini gösteren ekran.
class LayoutStylingScreen extends StatefulWidget {
  const LayoutStylingScreen({super.key});

  @override
  State<LayoutStylingScreen> createState() => _LayoutStylingScreenState();
}

class _LayoutStylingScreenState extends State<LayoutStylingScreen> {
  /// Cüzdan bakiyesinin ekranda görünür olup olmadığını kontrol eden durum bayrağı.
  /// Kullanıcı göz ikonuna tıkladığında tersine çevrilir 
  bool _isBalanceVisible = true;

  /// Kullanıcının tıkladığı son aksiyonu veya durumu tutan metin.
  /// Alt kısımda bilgilendirme olarak canlı güncellenir.
  String _lastAction = 'Hazır - Butonlara Tıklayabilirsiniz';

  @override
  Widget build(BuildContext context) {
    // Sayfanın dikeyde kaydırılabilir olmasını sağlamak için SingleChildScrollView kullanılır.
    // Bu sayede küçük ekranlarda taşma (overflow) hataları önlenir.
    return SingleChildScrollView(
      // iOS tarzı yumuşak yaylanma kaydırma efekti (BouncingScrollPhysics)
      physics: const BouncingScrollPhysics(),
      // Ekranın en altına boşluk bırakarak alt çubuğun içeriği kapatmasını önler
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        // Elemanları yatayda sola hizalar
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Profil ve online rozeti alanı
          _buildProfileHeader(),

          // 2. Bakiyenin yer aldığı şık cüzdan kartı
          _buildWalletCard(),

          // 3. Hızlı aksiyon butonları (Gönder, Ekle, Geçmiş)
          _buildQuickActions(),

          // 4. Gelir ve gider istatistik kutucukları
          _buildFlexStatistics(),

          // 5. Bilgilendirme / Kampanya duyuru banner'ı
          _buildNotificationBanner(),

          // 6. Canlı durum bildirimi: En son tıklanan butonu gösterir
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Son İşlem: $_lastAction',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  // 1. PROFİL HEADER BÖLÜMÜ
  /// Kullanıcı avatarı, çevrimiçi rozeti ve karşılama metinlerini içeren üst başlık.
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Stack widget'ı, çocuklarını üst üste (katmanlar halinde) yerleştirmeyi sağlar
          Stack(
            // Rozetin taşabilmesine izin vermek için clipBehavior Clip.none yapılır
            clipBehavior: Clip.none,
            children: [
              // Profil avatarı dairesel kutusu
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x1F6366F1), // Yarı saydam mor zemin
                  border: Border.all(
                    color: const Color(0xFF6366F1),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  size: 30,
                  color: Color(0xFF6366F1),
                ),
              ),

              // Online durumu gösteren yeşil küçük daire rozeti
              // Positioned ile avatar dairesinin sağ alt köşesine konumlandırılır
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // Avatar kenarlığından ayıran beyaz çerçeve
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Avatar ile metin arasındaki yatay boşluk
          const SizedBox(width: 16),

          // Karşılama ve isim metinleri
          // Expanded, metinlerin kalan tüm yatay alanı doldurmasını sağlar
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoş Geldiniz',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'DTM Kullanıcısı',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. CÜZDAN KARTI BÖLÜMÜ
  /// Toplam bakiyeyi ve bakiye gizle/göster butonunu barındıran cüzdan kartı widget'ı.
  Widget _buildWalletCard() {
    return Container(
      width: double.infinity, // Kartın yatayda tam genişlikte olmasını sağlar
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1), 
        borderRadius: BorderRadius.circular(20), // Köşe yuvarlama
        boxShadow: [
          // Karta derinlik hissi katan yumuşak gölge
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık satırı: Cüzdan ikonu ve "Toplam Bakiye" metni
          const Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white70,
              ),
              SizedBox(width: 8),
              Text(
                'Toplam Bakiye',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bakiye ve gizleme/gösterme butonu satırı
          Row(
            children: [
              // Bakiye metni: _isBalanceVisible true ise gerçek tutarı, false ise yıldızlı hali gösterir
              Expanded(
                child: Text(
                  _isBalanceVisible
                      ? '₺24.500,00'
                      : '₺******',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Bakiye görünürlüğünü değiştiren buton
              IconButton(
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                    _lastAction = _isBalanceVisible
                        ? 'Bakiye gösterildi'
                        : 'Bakiye gizlendi';
                  });
                },
                icon: Icon(
                  _isBalanceVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Kartın alt bilgisi
          const Text(
            'DTM Dijital Cüzdan',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  
  // 3. HIZLI AKSİYONLAR BÖLÜMÜ
  /// Sık kullanılan işlemleri (Gönder, Para Ekle, Geçmiş) yan yana hizalayan bölüm.
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        // Butonları satır üzerinde eşit mesafeyle dağıtır
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.send, 'Gönder'),
          _buildActionButton(Icons.add, 'Para Ekle'),
          _buildActionButton(Icons.history, 'Geçmiş'),
        ],
      ),
    );
  }

  // 4. ORTAK AKSİYON BUTONU ŞABLONU
  /// Tekrar kullanılabilir (reusable) aksiyon butonu bileşeni.
  /// [icon]: Butonun ikonu, [title]: Altında yer alan açıklayıcı etiket.
  Widget _buildActionButton(
    IconData icon,
    String title,
  ) {
    return Column(
      children: [
        // İkonun bulunduğu yuvarlak köşeli arka plan kutusu
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE0E7FF), 
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: () {
              // Durumu güncelle
              setState(() {
                _lastAction = title;
              });

              // Kullanıcıya bildirim çubuğu (SnackBar) göster
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title butonuna tıklandı'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(
              icon,
              color: const Color(0xFF6366F1),
              size: 28,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Butonun altındaki başlık metni
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }


  // 5. GELİR-GİDER İSTATİSTİKLERİ BÖLÜMÜ
  /// Gelir ve gider kartlarını eşit genişlikte yan yana yerleştiren bölüm.
  Widget _buildFlexStatistics() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Gelir Kartı - Expanded ile satırın %50'sini kaplar
          Expanded(
            child: _buildStatisticCard(
              'Gelir',
              '₺12.500',
              Icons.trending_up,
              Colors.green,
            ),
          ),

          const SizedBox(width: 12),

          // Gider Kartı - Expanded ile satırın %50'sini kaplar
          Expanded(
            child: _buildStatisticCard(
              'Gider',
              '₺4.200',
              Icons.trending_down,
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }


  // 6. ORTAK İSTATİSTİK KARTI ŞABLONU
  /// Gelir veya gider bilgisini gösteren tekrar kullanılabilir kart bileşeni.
  /// [title]: Kart başlığı (Gelir/Gider), [amount]: Gösterilecek tutar,
  /// [icon]: İkon, [color]: Vurgu rengi (Yeşil veya Kırmızı).
  Widget _buildStatisticCard(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // İlgili rengin %10 opaklıkta açık tonu arka plan yapılır
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }


  // 7. BİLDİRİM / KAMPANYA BANNER BÖLÜMÜ
  /// Ekranın alt kısmında duyuruları ve kampanyaları gösteren bilgilendirme kutusu.
  Widget _buildNotificationBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E7FF), // Açık mor/mavi arka plan
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.notifications_active,
            color: Color(0xFF6366F1),
          ),

          SizedBox(width: 12),

          // Metin uzun olduğunda satırın taşmasını önlemek için Expanded ile sarılmıştır
          Expanded(
            child: Text(
              'Yeni kampanyalar ve fırsatlar sizi bekliyor!',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
