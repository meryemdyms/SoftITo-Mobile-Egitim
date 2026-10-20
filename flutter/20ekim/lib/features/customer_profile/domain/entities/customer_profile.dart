class CustomerProfile {
  final String userId;
  final DateTime birthDate;
  final String drivingLicenceNumber;
  final String licenceClass;
  final DateTime issueDate;

  const CustomerProfile({
    required this.userId,
    required this.birthDate,
    required this.drivingLicenceNumber,
    required this.licenceClass,
    required this.issueDate,
  });

  /// Calculates age based on given current date
  int ageAt(DateTime date) {
    int age = date.year - birthDate.year;
    if (date.month < birthDate.month ||
        (date.month == birthDate.month && date.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Calculates driving licence age in years based on given current date
  int licenceYearsAt(DateTime date) {
    int years = date.year - issueDate.year;
    if (date.month < issueDate.month ||
        (date.month == issueDate.month && date.day < issueDate.day)) {
      years--;
    }
    return years;
  }

  CustomerProfile copyWith({
    String? userId,
    DateTime? birthDate,
    String? drivingLicenceNumber,
    String? licenceClass,
    DateTime? issueDate,
  }) {
    return CustomerProfile(
      userId: userId ?? this.userId,
      birthDate: birthDate ?? this.birthDate,
      drivingLicenceNumber: drivingLicenceNumber ?? this.drivingLicenceNumber,
      licenceClass: licenceClass ?? this.licenceClass,
      issueDate: issueDate ?? this.issueDate,
    );
  }
}
