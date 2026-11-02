import 'package:flutter/material.dart';
import '../controllers/donation_history_controller.dart';
import '../models/donation_history_model.dart';
import '../widgets/donation_history_widgets.dart';

/// Donörün geçmişte yaptığı tüm kan, trombosit veya plazma bağışlarını
/// listeleyen ve yeni bağış kaydı girilmesine olanak tanıyan görünüm ekranı.
class DonationHistoryView extends StatefulWidget {
  const DonationHistoryView({super.key, this.controller});

  /// Dışarıdan iletilebilen kontrolcü (AppShell tarafından sağlanır)
  final DonationHistoryController? controller;

  @override
  State<DonationHistoryView> createState() => _DonationHistoryViewState();
}

class _DonationHistoryViewState extends State<DonationHistoryView> {
  late final DonationHistoryController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    // Dışarıdan bir kontrolcü enjekte edilmediyse bağımsız bir kontrolcü oluşturulur.
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = DonationHistoryController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    // Dahili kontrolcü oluşturulduysa bellek sızıntısını engellemek için dispose edilir.
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Yeni bağış kaydetme formunu alt modal (BottomSheet) şeklinde açar.
  void _openAddDonationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Klavye açıldığında modalın kaydırılabilmesini sağlar
      builder: (_) => AddDonationBottomSheet(
        onSubmit: _controller.addDonation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bağış Geçmişim'),
      ),
      // Yeni bağış ekleme butonu (FAB)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddDonationDialog,
        icon: const Icon(Icons.add),
        label: const Text('Bağış Ekle'),
      ),
      // Bağış geçmişi listesini reaktif olarak dinler
      body: ValueListenableBuilder<DonationHistoryState>(
        valueListenable: _controller.state,
        builder: (context, state, _) {
          // Kayıt bulunmuyorsa özel boş durum (empty state) görünümü sunar
          if (state.records.isEmpty) {
            return const DonationEmptyView();
          }
          // Bağış kayıtları listesi
          return ListView.builder(
            itemCount: state.records.length,
            padding: const EdgeInsets.only(top: 8, bottom: 80), // FAB altına taşmayı önleyen boşluk
            itemBuilder: (context, index) {
              final record = state.records[index];
              return DonationRecordCard(
                record: record,
                onDelete: () => _controller.removeDonation(record.id),
              );
            },
          );
        },
      ),
    );
  }
}

