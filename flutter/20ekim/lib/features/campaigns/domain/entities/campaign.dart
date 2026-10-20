class Campaign {
  final String id;
  final String companyId;
  final String title;
  final String description;
  final int discountPercent; // 0..100
  final DateTime validFrom;
  final DateTime validTo;
  final List<String>? eligibleVehicleIds;
  final bool active;

  const Campaign({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.discountPercent,
    required this.validFrom,
    required this.validTo,
    this.eligibleVehicleIds,
    this.active = true,
  });

  /// Checks if campaign applies to given vehicle and date interval
  bool isEligibleFor(String vehicleId, DateTime startAt, DateTime endAt) {
    if (!active) return false;
    // Campaign must cover the rental window or be valid when booking is created/started
    if (startAt.isBefore(validFrom) || endAt.isAfter(validTo)) {
      return false;
    }
    if (eligibleVehicleIds != null && eligibleVehicleIds!.isNotEmpty) {
      return eligibleVehicleIds!.contains(vehicleId);
    }
    return true;
  }

  Campaign copyWith({
    String? id,
    String? companyId,
    String? title,
    String? description,
    int? discountPercent,
    DateTime? validFrom,
    DateTime? validTo,
    List<String>? eligibleVehicleIds,
    bool? active,
  }) {
    return Campaign(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      description: description ?? this.description,
      discountPercent: discountPercent ?? this.discountPercent,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      eligibleVehicleIds: eligibleVehicleIds ?? this.eligibleVehicleIds,
      active: active ?? this.active,
    );
  }
}
