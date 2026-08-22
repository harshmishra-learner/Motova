/// Status of a single vehicle booking.
enum BookingStatus { upcoming, completed, cancelled }

extension BookingStatusLabel on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// A single vehicle booking/rental entry shown on the Vehicles screen.
///
/// TODO: replace mock data (see [kMockBookings] below) with a real
/// API-backed model/repository once a bookings endpoint exists on the
/// backend. Follow the same data/{api_service,repository} pattern used
/// by `features/auth/data/`.
class Booking {
  final String id;
  final String carName;
  final String imageAsset;
  final BookingStatus status;
  final DateTime pickupDate;
  final String pickupLocation;
  final double totalPrice;
  final String bookingCode;

  const Booking({
    required this.id,
    required this.carName,
    required this.imageAsset,
    required this.status,
    required this.pickupDate,
    required this.pickupLocation,
    required this.totalPrice,
    required this.bookingCode,
  });
}

/// TODO: mock bookings — replace with real data from the backend.
final List<Booking> kMockBookings = [
  Booking(
    id: 'bk_1',
    carName: 'Tesla Model 3',
    imageAsset: 'assets/images/onboarding_car2.png',
    status: BookingStatus.upcoming,
    pickupDate: DateTime.now().add(const Duration(days: 2)),
    pickupLocation: 'Downtown Hub',
    totalPrice: 267,
    bookingCode: 'MTV-20481',
  ),
  Booking(
    id: 'bk_2',
    carName: 'BMW X5',
    imageAsset: 'assets/images/onboarding_car.png',
    status: BookingStatus.upcoming,
    pickupDate: DateTime.now().add(const Duration(days: 9)),
    pickupLocation: 'Airport Terminal',
    totalPrice: 440,
    bookingCode: 'MTV-20502',
  ),
  Booking(
    id: 'bk_3',
    carName: 'Porsche 911',
    imageAsset: 'assets/images/onboarding_car2.png',
    status: BookingStatus.completed,
    pickupDate: DateTime.now().subtract(const Duration(days: 12)),
    pickupLocation: 'Downtown Hub',
    totalPrice: 630,
    bookingCode: 'MTV-19870',
  ),
  Booking(
    id: 'bk_4',
    carName: 'Toyota Camry',
    imageAsset: 'assets/images/onboarding_car2.png',
    status: BookingStatus.completed,
    pickupDate: DateTime.now().subtract(const Duration(days: 30)),
    pickupLocation: 'City Center',
    totalPrice: 186,
    bookingCode: 'MTV-19340',
  ),
];
