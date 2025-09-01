abstract class HotelRepository {
  Future<Map<String, dynamic>> getHotelDetails(String hotelId);
}

class HotelRepositoryImpl implements HotelRepository {
  @override
  Future<Map<String, dynamic>> getHotelDetails(String hotelId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data
    return {
      'id': hotelId,
      'title': 'Four Points by Sheraton',
      'date': '14 December, 2025',
      'day': 'Tuesday',
      'time': 'Check-in: 3:00PM',
      'location': 'Jeddah Corniche',
      'country': 'KSA',
      'organizer': 'Marriott International',
      'organizerCountry': 'USA',
      'about':
          'Luxury hotel with stunning sea views, world-class amenities, and exceptional service in the heart of Jeddah.',
      'guests': '+50 Guests',
      'price': 'SR165.3',
      'image': 'assets/images/hotel.svg',
    };
  }
}
