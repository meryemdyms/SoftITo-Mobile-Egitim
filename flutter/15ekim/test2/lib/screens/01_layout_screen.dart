
import 'package:flutter/material.dart';

class LayoutStylingScreen extends StatefulWidget {
  const LayoutStylingScreen({super.key});

  @override
  State<LayoutStylingScreen> createState() =>
      _LayoutStylingScreenState();
}

class _LayoutStylingScreenState extends State<LayoutStylingScreen> {
  bool _isBalanceVisible = true;
  String _lastAction = 'Hazır - Butonlara Tıklayabilirsiniz';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profil ve online rozeti
          _buildProfileHeader(),

          // Cüzdan kartı
          _buildWalletCard(),

          // Aksiyon butonları
          _buildQuickActions(),

          // Gelir ve gider istatistikleri
          _buildFlexStatistics(),

          // Bildirim banner
          _buildNotificationBanner(),

          // Canlı durum bildirimi
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

  // 1. PROFİL HEADER
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x1F6366F1),
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

              // Online rozeti
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
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

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

  // 2. CÜZDAN KARTI
  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
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

          Row(
            children: [
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

  // 3. HIZLI AKSİYONLAR
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.send, 'Gönder'),
          _buildActionButton(Icons.add, 'Para Ekle'),
          _buildActionButton(Icons.history, 'Geçmiş'),
        ],
      ),
    );
  }

  // 4. ORTAK AKSİYON BUTONU
  Widget _buildActionButton(
    IconData icon,
    String title,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE0E7FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: () {
              setState(() {
                _lastAction = title;
              });

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

  // 5. GELİR-GİDER İSTATİSTİKLERİ
  Widget _buildFlexStatistics() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatisticCard(
              'Gelir',
              '₺12.500',
              Icons.trending_up,
              Colors.green,
            ),
          ),

          const SizedBox(width: 12),

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

  // 6. ORTAK İSTATİSTİK KARTI
  Widget _buildStatisticCard(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
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

  // 7. BİLDİRİM BANNER
  Widget _buildNotificationBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E7FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.notifications_active,
            color: Color(0xFF6366F1),
          ),

          SizedBox(width: 12),

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
