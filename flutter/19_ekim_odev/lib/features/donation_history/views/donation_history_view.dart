import 'package:flutter/material.dart';
import '../controllers/donation_history_controller.dart';
import '../models/donation_history_model.dart';
import '../widgets/donation_history_widgets.dart';

class DonationHistoryView extends StatefulWidget {
  const DonationHistoryView({super.key, this.controller});

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
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = DonationHistoryController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _openAddDonationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddDonationDialog,
        icon: const Icon(Icons.add),
        label: const Text('Bağış Ekle'),
      ),
      body: ValueListenableBuilder<DonationHistoryState>(
        valueListenable: _controller.state,
        builder: (context, state, _) {
          if (state.records.isEmpty) {
            return const DonationEmptyView();
          }
          return ListView.builder(
            itemCount: state.records.length,
            padding: const EdgeInsets.only(top: 8, bottom: 80),
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
