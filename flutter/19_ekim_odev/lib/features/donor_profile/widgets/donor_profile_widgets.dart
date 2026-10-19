import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/date_extensions.dart';
import '../models/donor_profile_model.dart';

class _DonorAvatarInfo extends StatelessWidget {
  const _DonorAvatarInfo({required this.profile});

  final DonorProfile profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.fullName,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: colorScheme.secondary),
            const SizedBox(width: 4),
            Text(
              '${profile.city}, ${profile.district}',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

class _DonorBloodBadge extends StatelessWidget {
  const _DonorBloodBadge({required this.bloodGroup});

  final String bloodGroup;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        bloodGroup,
        style: textTheme.titleMedium?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Bağışçının kimlik ve kan grubu özet kartı
class DonorAvatarCard extends StatelessWidget {
  const DonorAvatarCard({super.key, required this.profile});

  final DonorProfile profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 36,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: _DonorAvatarInfo(profile: profile)),
            _DonorBloodBadge(bloodGroup: profile.bloodGroup),
          ],
        ),
      ),
    );
  }
}

class _DonorEligibilityHeader extends StatelessWidget {
  const _DonorEligibilityHeader({
    required this.isEligible,
    required this.isAvailable,
    required this.onAvailabilityChanged,
  });

  final bool isEligible;
  final bool isAvailable;
  final ValueChanged<bool> onAvailabilityChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          isEligible ? Icons.check_circle : Icons.schedule,
          color: isEligible ? colorScheme.secondary : colorScheme.error,
          size: 22,
        ),
        const SizedBox(width: 8),
        Text(
          isEligible ? 'Bağışa Uygun' : 'Bekleme Süresinde',
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Switch(value: isAvailable, onChanged: onAvailabilityChanged),
      ],
    );
  }
}

class _DonorEligibilityBody extends StatelessWidget {
  const _DonorEligibilityBody({required this.profile});

  final DonorProfile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.isEligibleToDonate
              ? 'Gerektiğinde acil çağrılar için bildirim alabilirsiniz.'
              : 'Sonraki bağış yapabileceğiniz güne ${profile.daysUntilNextDonation} gün kaldı.',
          style: textTheme.bodyMedium,
        ),
        if (profile.lastDonationDate != null) ...[
          const SizedBox(height: 8),
          Text(
            'Son Bağış: ${profile.lastDonationDate!.toFormattedTurkish()}',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
          ),
        ],
      ],
    );
  }
}

/// Bağış uygunluğu ve durum bildirimi kartı
class DonorEligibilityCard extends StatelessWidget {
  const DonorEligibilityCard({
    super.key,
    required this.profile,
    required this.onAvailabilityChanged,
  });

  final DonorProfile profile;
  final ValueChanged<bool> onAvailabilityChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DonorEligibilityHeader(
              isEligible: profile.isEligibleToDonate,
              isAvailable: profile.isAvailable,
              onAvailabilityChanged: onAvailabilityChanged,
            ),
            const SizedBox(height: 8),
            _DonorEligibilityBody(profile: profile),
          ],
        ),
      ),
    );
  }
}

class _CompatibilityGroupRow extends StatelessWidget {
  const _CompatibilityGroupRow({
    required this.title,
    required this.icon,
    required this.groups,
    required this.accentColor,
  });

  final String title;
  final IconData icon;
  final List<String> groups;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: accentColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: groups.map((grp) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                grp,
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Sabit kan grubu uyumluluk rehberi ve gerektiğinde düzeltme seçeneği kartı
class DonorBloodCompatibilityCard extends StatelessWidget {
  const DonorBloodCompatibilityCard({
    super.key,
    required this.bloodGroup,
    required this.onGroupCorrected,
  });

  final String bloodGroup;
  final ValueChanged<String> onGroupCorrected;

  void _showCorrectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Kan Grubunu Düzelt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kan grubu sabit bir biyolojik veridir. Sadece kayıt esnasında hatalı seçtiyseniz düzeltiniz.',
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.bloodGroups.map((group) {
                  return ChoiceChip(
                    label: Text(group),
                    selected: group == bloodGroup,
                    onSelected: (selected) {
                      if (selected) {
                        onGroupCorrected(group);
                        Navigator.of(ctx).pop();
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Vazgeç'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final donateList = AppConstants.canDonateTo[bloodGroup] ?? [bloodGroup];
    final receiveList = AppConstants.canReceiveFrom[bloodGroup] ?? [bloodGroup];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bloodtype, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kan Uyumluluk Rehberi ($bloodGroup)',
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Sabit Biyolojik Veri',
                        style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showCorrectionDialog(context),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Düzelt'),
                ),
              ],
            ),
            const Divider(height: 24),
            _CompatibilityGroupRow(
              title: 'Kan Verebileceğiniz Gruplar',
              icon: Icons.arrow_upward,
              groups: donateList,
              accentColor: colorScheme.primary,
            ),
            const SizedBox(height: 14),
            _CompatibilityGroupRow(
              title: 'Kan Alabileceğiniz Gruplar',
              icon: Icons.arrow_downward,
              groups: receiveList,
              accentColor: colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
