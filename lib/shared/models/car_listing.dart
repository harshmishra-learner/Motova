/// Vehicle categories used for filtering on Home and Search.
enum CarCategory { suv, sedan, sports, electric, luxury }

extension CarCategoryLabel on CarCategory {
  String get label {
    switch (this) {
      case CarCategory.suv:
        return 'SUV';
      case CarCategory.sedan:
        return 'Sedan';
      case CarCategory.sports:
        return 'Sports';
      case CarCategory.electric:
        return 'Electric';
      case CarCategory.luxury:
        return 'Luxury';
    }
  }
}

/// A single car available to browse/rent.
///
/// TODO: replace mock catalog data (see [kMockCarListings] below) with a
/// real API-backed model/repository once a `GET /cars` (or similar)
/// endpoint exists on the backend. Follow the same
/// data/{api_service,repository} pattern used by `features/auth/data/`.
class CarListing {
  final String id;
  final String name;
  final CarCategory category;
  final String imageAsset;
  final double pricePerDay;
  final double rating;
  final int seats;
  final String transmission;
  final String location;

  const CarListing({
    required this.id,
    required this.name,
    required this.category,
    required this.imageAsset,
    required this.pricePerDay,
    required this.rating,
    required this.seats,
    required this.transmission,
    required this.location,
  });
}

/// TODO: mock catalog — replace with real data from the backend.
final List<CarListing> kMockCarListings = [
  const CarListing(
    id: 'car_1',
    name: 'Tesla Model 3',
    category: CarCategory.electric,
    imageAsset: 'assets/images/onboarding_car2.png',
    pricePerDay: 89,
    rating: 4.9,
    seats: 5,
    transmission: 'Automatic',
    location: 'Downtown Hub',
  ),
  const CarListing(
    id: 'car_2',
    name: 'Jaguar F-Type',
    category: CarCategory.sports,
    imageAsset: 'assets/images/onboarding_car.png',
    pricePerDay: 145,
    rating: 4.8,
    seats: 2,
    transmission: 'Automatic',
    location: 'Airport Terminal',
  ),
  const CarListing(
    id: 'car_3',
    name: 'BMW X5',
    category: CarCategory.suv,
    imageAsset: 'assets/images/onboarding_car.png',
    pricePerDay: 110,
    rating: 4.7,
    seats: 7,
    transmission: 'Automatic',
    location: 'Downtown Hub',
  ),
  const CarListing(
    id: 'car_4',
    name: 'Toyota Camry',
    category: CarCategory.sedan,
    imageAsset: 'assets/images/onboarding_car2.png',
    pricePerDay: 62,
    rating: 4.6,
    seats: 5,
    transmission: 'Automatic',
    location: 'City Center',
  ),
  const CarListing(
    id: 'car_5',
    name: 'Range Rover Evoque',
    category: CarCategory.luxury,
    imageAsset: 'assets/images/onboarding_car.png',
    pricePerDay: 168,
    rating: 4.9,
    seats: 5,
    transmission: 'Automatic',
    location: 'Airport Terminal',
  ),
  const CarListing(
    id: 'car_6',
    name: 'Porsche 911',
    category: CarCategory.sports,
    imageAsset: 'assets/images/onboarding_car2.png',
    pricePerDay: 210,
    rating: 5.0,
    seats: 2,
    transmission: 'Automatic',
    location: 'Downtown Hub',
  ),
  const CarListing(
    id: 'car_7',
    name: 'Audi Q7',
    category: CarCategory.suv,
    imageAsset: 'assets/images/onboarding_car2.png',
    pricePerDay: 132,
    rating: 4.7,
    seats: 7,
    transmission: 'Automatic',
    location: 'City Center',
  ),
  const CarListing(
    id: 'car_8',
    name: 'Mercedes C-Class',
    category: CarCategory.sedan,
    imageAsset: 'assets/images/onboarding_car.png',
    pricePerDay: 98,
    rating: 4.8,
    seats: 5,
    transmission: 'Automatic',
    location: 'Downtown Hub',
  ),
];
