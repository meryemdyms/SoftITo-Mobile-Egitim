import 'package:flutter/material.dart';
import '../controllers/blood_request_controller.dart';
import '../models/blood_request_model.dart';
import '../widgets/blood_request_widgets.dart';

/// Acil kan çağrılarının listelendiği, kan grubuna göre filtrelendiği
/// ve yeni çağrı açılabildiği ana ekran bileşeni.
class BloodRequestView extends StatefulWidget {
  const BloodRequestView({super.key, this.controller});

  /// Dışarıdan enjekte edilebilen kontrolcü (AppShell tarafından sağlanır)
  final BloodRequestController? controller;

  @override
  State<BloodRequestView> createState() => _BloodRequestViewState();
}

class _BloodRequestViewState extends State<BloodRequestView> {
  late final BloodRequestController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    // Eğer widget'a dışarıdan bir controller verilmemişse dahili olarak oluşturulur.
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = BloodRequestController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    // Controller bu widget tarafından oluşturulduysa bellek sızıntısını önlemek için dispose edilir.
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Yeni kan çağrısı oluşturmak için alt modal penceresini (BottomSheet) açar.
  void _openCreateDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Klavyenin modalı örtmesini engellemek için tam yükseklik kontrolü
      builder: (_) => CreateRequestBottomSheet(
        onSubmit: _controller.addRequest,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acil Kan Çağrıları'),
      ),
      // Yeni çağrı oluşturma butonu (FAB)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateDialog,
        icon: const Icon(Icons.add_alert_outlined),
        label: const Text('Çağrı Aç'),
      ),
      // Taleplerin durumunu dinler ve liste güncellendiğinde UI'ı yeniden çizer
      body: ValueListenableBuilder<BloodRequestState>(
        valueListenable: _controller.state,
        builder: (context, state, _) {
          final requests = state.filteredRequests;
          return Column(
            children: [
              // Kan grubu yatay filtre çubuğu
              BloodGroupFilterBar(
                selectedGroup: state.filterBloodGroup,
                onGroupSelected: _controller.filterByBloodGroup,
              ),
              // Filtrelenmiş çağrıların listesi
              Expanded(
                child: ListView.builder(
                  itemCount: requests.length,
                  padding: const EdgeInsets.only(bottom: 80), // FAB altında kalmaması için boşluk
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return BloodRequestCard(
                      request: request,
                      onSupport: () => _controller.supportRequest(request.id),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

