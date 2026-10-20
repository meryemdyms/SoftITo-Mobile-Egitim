import '../enums/fuel_type.dart';
import '../enums/reservation_status.dart';
import '../enums/transmission_type.dart';
import '../enums/user_role.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/customer_profile/domain/entities/customer_profile.dart';
import '../../features/companies/domain/entities/company.dart';
import '../../features/vehicles/domain/entities/vehicle.dart';
import '../../features/bookings/domain/entities/reservation.dart';
import '../../features/campaigns/domain/entities/campaign.dart';

class MockDataSeed {
  MockDataSeed._();

  static List<User> get initialUsers => [
    const User(
      id: 'user_cust_1',
      role: UserRole.customer,
      name: 'Ahmet Yılmaz',
      email: 'customer@demo.com',
      phone: '0555 123 4567',
    ),
    const User(
      id: 'user_cust_2',
      role: UserRole.customer,
      name: 'Zeynep Kaya',
      email: 'zeynep@demo.com',
      phone: '0555 987 6543',
    ),
    const User(
      id: 'user_comp_1',
      role: UserRole.company,
      name: 'Mehmet Demir',
      email: 'company@demo.com',
      phone: '0532 111 2233',
    ),
    const User(
      id: 'user_comp_2',
      role: UserRole.company,
      name: 'Canan Özkan',
      email: 'anadolu@demo.com',
      phone: '0533 444 5566',
    ),
  ];

  static Map<String, CustomerProfile> get initialProfiles => {
    'user_cust_1': CustomerProfile(
      userId: 'user_cust_1',
      birthDate: DateTime(1996, 5, 15),
      drivingLicenceNumber: 'TR-8492041',
      licenceClass: 'B',
      issueDate: DateTime(2018, 6, 10),
    ),
    'user_cust_2': CustomerProfile(
      userId: 'user_cust_2',
      birthDate: DateTime(2003, 9, 20),
      drivingLicenceNumber: 'TR-1192834',
      licenceClass: 'B',
      issueDate: DateTime(2023, 1, 15),
    ),
  };

  static List<Company> get initialCompanies => [
    const Company(
      id: 'comp_1',
      ownerUserId: 'user_comp_1',
      name: 'Ege Filo Araç Kiralama',
      logo: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=150',
      description: 'Kadıköy merkezli, geniş araç filosu ve 7/24 yol yardım desteğiyle güvenilir kiralama hizmeti.',
      address: 'Bağdat Caddesi No: 124, Kadıköy, İstanbul',
      latitude: 40.9632,
      longitude: 29.0742,
      openingHours: '08:30 - 20:00',
      phone: '0216 345 6789',
      active: true,
    ),
    const Company(
      id: 'comp_2',
      ownerUserId: 'user_comp_2',
      name: 'Anadolu Rent a Car',
      logo: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=150',
      description: 'Beşiktaş ve Havalimanı teslimat noktalarımızla konforlu, ekonomik ve prestijli araç seçenekleri.',
      address: 'Barbaros Bulvarı No: 58, Beşiktaş, İstanbul',
      latitude: 41.0482,
      longitude: 29.0094,
      openingHours: '09:00 - 21:00',
      phone: '0212 258 1234',
      active: true,
    ),
  ];

  static List<Vehicle> get initialVehicles => [
    const Vehicle(
      id: 'veh_1',
      companyId: 'comp_1',
      brand: 'Fiat',
      model: 'Egea Sedan 1.4 Fire',
      year: 2023,
      transmission: TransmissionType.manual,
      fuel: FuelType.gasoline,
      seats: 5,
      dailyRate: 110000, // 1.100 ₺
      images: [
        'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=600',
      ],
      pickupLocation: 'Kadıköy Ofis / Sabiha Gökçen HL',
      isActive: true,
      minDriverAge: 21,
      minLicenceYears: 1,
    ),
    const Vehicle(
      id: 'veh_2',
      companyId: 'comp_1',
      brand: 'Renault',
      model: 'Megane 1.3 TCe EDC',
      year: 2024,
      transmission: TransmissionType.automatic,
      fuel: FuelType.gasoline,
      seats: 5,
      dailyRate: 165000, // 1.650 ₺
      images: [
        'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=600',
      ],
      pickupLocation: 'Kadıköy Ofis',
      isActive: true,
      minDriverAge: 22,
      minLicenceYears: 2,
    ),
    const Vehicle(
      id: 'veh_3',
      companyId: 'comp_1',
      brand: 'Peugeot',
      model: '3008 1.5 BlueHDi GT',
      year: 2024,
      transmission: TransmissionType.automatic,
      fuel: FuelType.diesel,
      seats: 5,
      dailyRate: 240000, // 2.400 ₺
      images: [
        'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=600',
      ],
      pickupLocation: 'Kadıköy Ofis / Ataşehir Teslimat',
      isActive: true,
      minDriverAge: 25,
      minLicenceYears: 3,
    ),
    const Vehicle(
      id: 'veh_4',
      companyId: 'comp_2',
      brand: 'Toyota',
      model: 'Corolla 1.8 Hybrid e-CVT',
      year: 2024,
      transmission: TransmissionType.automatic,
      fuel: FuelType.hybrid,
      seats: 5,
      dailyRate: 195000, // 1.950 ₺
      images: [
        'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=600',
      ],
      pickupLocation: 'Beşiktaş Merkez / İstanbul HL',
      isActive: true,
      minDriverAge: 23,
      minLicenceYears: 2,
    ),
    const Vehicle(
      id: 'veh_5',
      companyId: 'comp_2',
      brand: 'Volkswagen',
      model: 'Golf 1.5 eTSI R-Line',
      year: 2023,
      transmission: TransmissionType.automatic,
      fuel: FuelType.gasoline,
      seats: 5,
      dailyRate: 210000, // 2.100 ₺
      images: [
        'https://images.unsplash.com/photo-1471444668988-5520625466f3?w=600',
      ],
      pickupLocation: 'Beşiktaş Merkez',
      isActive: true,
      minDriverAge: 24,
      minLicenceYears: 2,
    ),
    const Vehicle(
      id: 'veh_6',
      companyId: 'comp_2',
      brand: 'BMW',
      model: '320i Sedan M Sport',
      year: 2024,
      transmission: TransmissionType.automatic,
      fuel: FuelType.gasoline,
      seats: 5,
      dailyRate: 380000, // 3.800 ₺
      images: [
        'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=600',
      ],
      pickupLocation: 'Beşiktaş Merkez / VIP Vale',
      isActive: true,
      minDriverAge: 26,
      minLicenceYears: 3,
    ),
  ];

  static List<Campaign> get initialCampaigns => [
    Campaign(
      id: 'camp_1',
      companyId: 'comp_1',
      title: 'Bahar İndirimi %15',
      description:
          'Ege Filo tüm araçlarında geçerli %15 anında kiralama indirimi!',
      discountPercent: 15,
      validFrom: DateTime(2026, 1, 1),
      validTo: DateTime(2026, 12, 31),
      active: true,
    ),
    Campaign(
      id: 'camp_2',
      companyId: 'comp_2',
      title: 'Hibrit Avantajı %20',
      description: 'Çevre dostu Toyota Corolla Hybrid modelimizde geçerli %20 özel indirim fırsatı.',
      discountPercent: 20,
      eligibleVehicleIds: const ['veh_4'],
      validFrom: DateTime(2026, 1, 1),
      validTo: DateTime(2026, 12, 31),
      active: true,
    ),
  ];

  static List<Reservation> get initialReservations => [
    Reservation(
      id: 'res_1',
      vehicleId: 'veh_1',
      companyId: 'comp_1',
      customerId: 'user_cust_1',
      startAt: DateTime(2026, 11, 1, 10, 0),
      endAt: DateTime(2026, 11, 4, 10, 0),
      pickupLocation: 'Kadıköy Ofis',
      returnLocation: 'Kadıköy Ofis',
      dayCount: 3,
      basePrice: 330000,
      discountAmount: 49500,
      totalPrice: 280500,
      appliedCampaignId: 'camp_1',
      status: ReservationStatus.confirmed,
      createdAt: DateTime(2026, 10, 15, 14, 0),
    ),
  ];
}
