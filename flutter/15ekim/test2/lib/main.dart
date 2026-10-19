
import 'package:flutter/material.dart';

// Sayfalar
import 'screens/01_layout_screen.dart';
import 'screens/02_market_list_screen.dart';
import 'screens/03_transfer_form_screen.dart';

void main() {
  runApp(const DtmMasterApp());
}

class DtmMasterApp extends StatelessWidget {
  const DtmMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DTM Flutter Sınıfı",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const LiveCanvasScreen(),
    );
  }
}

class LiveCanvasScreen extends StatefulWidget {
  const LiveCanvasScreen({super.key});

  @override
  State<LiveCanvasScreen> createState() => _LiveCanvasScreenState();
}

class _LiveCanvasScreenState extends State<LiveCanvasScreen> {
  int _selectedIndex = 0;

  // Sayfalar
  final List<Widget> _pages = const [
    LayoutStylingScreen(),
    MarketsGridListScreen(),
    TransferFormScreen(),
  ];

  // Sayfa başlıkları
  final List<String> _titles = const [
    "DTM Canlı Arayüz",
    "Piyasalar ve İşlemler",
    "Para Transferi",
  ];

  // Sayfa değiştirme
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // Üst Bar
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_active_outlined,
            ),
            onPressed: () {
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

      // Aktif Sayfa
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // Alt Navigasyon
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: const Color(0x1F6366F1),
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
