import 'package:flutter/material.dart';

// Ekranlar (Sayfalar)
import 'screens/01_layout_screen.dart';
import 'screens/02_market_list_screen.dart';
import 'screens/03_transfer_form_screen.dart';

/// Flutter uygulamasının başlangıç noktası (Entry Point).
///
/// `runApp` fonksiyonu verilen kök widget'ı Flutter motoruna bağlar ve
/// uygulamanın yaşam döngüsünü başlatır.
void main() {
  runApp(const DtmMasterApp());
}

/// Uygulamanın kök (Root) widget'ı.
///
/// Bu widget `StatelessWidget` türündedir çünkü uygulamanın genel teması
/// veya temel ayarları çalışma esnasında dinamik olarak değişmez.
class DtmMasterApp extends StatelessWidget {
  const DtmMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Sağ üst köşedeki debug (hata ayıklama) bandını gizler
      debugShowCheckedModeBanner: false,

      // Uygulamanın cihaz görev yöneticisinde görünen başlığı
      title: "DTM Flutter Sınıfı",

      // Uygulamanın genel tema ayarları
      theme: ThemeData(
        // Google Material Design 3 standartlarını etkinleştirir
        useMaterial3: true,

        // Belirtilen tohum renkten (seedColor) uyumlu bir renk paleti üretir
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // İndigo / Mor tonlu kurumsal tema
          brightness: Brightness.light,
        ),

        // Tüm ekranların varsayılan arka plan rengi (açık gri/mavi ton)
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),

      // Uygulama açıldığında gösterilecek ilk ekran
      home: const LiveCanvasScreen(),
    );
  }
}

/// Alt navigasyon çubuğu (Bottom Navigation Bar) ile sayfalar arası geçişi
/// yöneten ana kapsayıcı ekran widget'ı.
///
/// Sayfa geçişlerinde aktif sekme indeksi değiştiği için `StatefulWidget` kullanılmıştır.
class LiveCanvasScreen extends StatefulWidget {
  const LiveCanvasScreen({super.key});

  @override
  State<LiveCanvasScreen> createState() => _LiveCanvasScreenState();
}

class _LiveCanvasScreenState extends State<LiveCanvasScreen> {
  /// O an seçili olan sekmenin indeks numarası (0: Ana Sayfa, 1: Piyasalar, 2: Transfer)
  int _selectedIndex = 0;

  /// Alt navigasyon sekmelerine karşılık gelen sayfaların listesi
  final List<Widget> _pages = const [
    LayoutStylingScreen(),
    MarketsGridListScreen(),
    TransferFormScreen(),
  ];

  /// AppBar (Üst Çubuk) üzerinde seçili sekmeye göre dinamik olarak gösterilecek başlıklar
  final List<String> _titles = const [
    "DTM Canlı Arayüz",
    "Piyasalar ve İşlemler",
    "Para Transferi",
  ];

  /// Kullanıcı alt menüden bir sekmeye dokunduğunda tetiklenen fonksiyon.
  /// `setState` çağrısı Flutter'a ekranı yeni `_selectedIndex` değeriyle yeniden çizmesini bildirir.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // Üst Bar (AppBar): Başlık ve sağ üstteki aksiyon butonunu içerir
      appBar: AppBar(
        // Başlık metni aktif sekmenin indeksi kullanılarak listeden seçilir
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true, // Başlığı ortalar
        backgroundColor: Colors.white,
        elevation: 0, // Gölgeyi sıfırlayarak modern ve düz bir görünüm sağlar
        actions: [
          // Bildirim simgesi butonu
          IconButton(
            icon: const Icon(
              Icons.notifications_active_outlined,
            ),
            onPressed: () {
              // Kullanıcıya ekranın altında anlık bir bilgilendirme mesajı (SnackBar) gösterir
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Henüz yeni bildiriminiz bulunmuyor.",
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // Aktif Sayfa Gövdesi:
      // `IndexedStack`, tüm çocuk widget'ları bellekte oluşturur ancak yalnızca
      // belirtilen indekstekini ekranda gösterir. Bu sayede sekmeler arasında gezinirken
      // sayfa durumu (scroll pozisyonu, form alanları vb.) kaybolmaz.
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // Alt Menü Çubuğu (Material 3 NavigationBar):
      // Modern gezinme çubuğu tasarımı sağlar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: const Color(0x1F6366F1), // Seçili sekmenin etrafındaki hafif renk vurgusu
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: "Ana Sayfa",
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: "Piyasalar",
          ),
          NavigationDestination(
            icon: Icon(Icons.send_outlined),
            selectedIcon: Icon(Icons.send),
            label: "Transfer",
          ),
        ],
      ),
    );
  }
}
