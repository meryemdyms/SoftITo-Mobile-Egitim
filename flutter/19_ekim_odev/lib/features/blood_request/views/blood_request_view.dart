import 'package:flutter/material.dart';
import '../controllers/blood_request_controller.dart';
import '../models/blood_request_model.dart';
import '../widgets/blood_request_widgets.dart';

class BloodRequestView extends StatefulWidget {
  const BloodRequestView({super.key, this.controller});

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
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = BloodRequestController();
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

  void _openCreateDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateDialog,
        icon: const Icon(Icons.add_alert_outlined),
        label: const Text('Çağrı Aç'),
      ),
      body: ValueListenableBuilder<BloodRequestState>(
        valueListenable: _controller.state,
        builder: (context, state, _) {
          final requests = state.filteredRequests;
          return Column(
            children: [
              BloodGroupFilterBar(
                selectedGroup: state.filterBloodGroup,
                onGroupSelected: _controller.filterByBloodGroup,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: requests.length,
                  padding: const EdgeInsets.only(bottom: 80),
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
