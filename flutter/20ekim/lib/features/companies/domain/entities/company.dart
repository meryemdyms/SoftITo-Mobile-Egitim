class Company {
  final String id;
  final String ownerUserId;
  final String name;
  final String logo;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String openingHours;
  final String phone;
  final bool active;

  const Company({
    required this.id,
    required this.ownerUserId,
    required this.name,
    required this.logo,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.openingHours,
    required this.phone,
    this.active = true,
  });

  Company copyWith({
    String? id,
    String? ownerUserId,
    String? name,
    String? logo,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? openingHours,
    String? phone,
    bool? active,
  }) {
    return Company(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingHours: openingHours ?? this.openingHours,
      phone: phone ?? this.phone,
      active: active ?? this.active,
    );
  }
}
