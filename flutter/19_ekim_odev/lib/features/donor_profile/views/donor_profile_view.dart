import 'package:flutter/material.dart';
import '../controllers/donor_profile_controller.dart';
import '../models/donor_profile_model.dart';
import '../widgets/donor_profile_widgets.dart';

class DonorProfileView extends StatefulWidget {
  const DonorProfileView({super.key, this.controller});

  final DonorProfileController? controller;

  @override
  State<DonorProfileView> createState() => _DonorProfileViewState();
}

class _DonorProfileViewState extends State<DonorProfileView> {
  late final DonorProfileController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = DonorProfileController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bağışçı Profilim'),
      ),
      body: ValueListenableBuilder<DonorProfile>(
        valueListenable: _controller.state,
        builder: (context, profile, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              DonorAvatarCard(profile: profile),
              DonorEligibilityCard(
                profile: profile,
                onAvailabilityChanged: _controller.toggleAvailability,
              ),
              DonorBloodCompatibilityCard(
                bloodGroup: profile.bloodGroup,
                onGroupCorrected: _controller.updateBloodGroup,
              ),
            ],
          );
        },
      ),
    );
  }
}
