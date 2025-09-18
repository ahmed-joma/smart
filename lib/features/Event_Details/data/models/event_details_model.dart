class EventDetailsModel {
  final int id;
  final String imageUrl;
  final List<String> attendeesImages;
  final int attendeesCount;
  final String title;
  final String startAt;
  final String endAt;
  final String venue;
  final String city;
  final String organizer;
  final String price;
  final String eventStatus;
  final String description;
  final bool isFavorite;
  final String favoritableType;

  EventDetailsModel({
    required this.id,
    required this.imageUrl,
    required this.attendeesImages,
    required this.attendeesCount,
    required this.title,
    required this.startAt,
    required this.endAt,
    required this.venue,
    required this.city,
    required this.organizer,
    required this.price,
    required this.eventStatus,
    required this.description,
    required this.isFavorite,
    required this.favoritableType,
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) {
    print('🔍 EventDetailsModel.fromJson: $json');

    // Extract and validate each field safely
    final id = json['id'] ?? 0;
    final imageUrl = json['image_url']?.toString() ?? '';
    final attendeesImages =
        (json['get_attendees_images_attribute'] as List<dynamic>?)
            ?.map((e) => e?.toString() ?? '')
            .where((url) => url.isNotEmpty)
            .toList() ??
        [];
    final attendeesCount = json['attendees_count'] ?? 0;
    final title = json['title']?.toString() ?? '';
    final startAt = json['start_at']?.toString() ?? '';
    final endAt = json['end_at']?.toString() ?? '';
    final venue = json['venue']?.toString() ?? '';
    final city = json['city']?.toString() ?? '';
    final organizer = json['organizer']?.toString() ?? '';
    final price = json['price']?.toString() ?? '0';
    final eventStatus = json['event_status']?.toString() ?? '';
    final description = json['description']?.toString() ?? '';
    final isFavorite = json['is_favorite'] ?? false;
    final favoritableType = json['favoritable_type']?.toString() ?? '';

    print('✅ Parsed Event: ID=$id, Title=$title, Venue=$venue');

    return EventDetailsModel(
      id: id,
      imageUrl: imageUrl,
      attendeesImages: attendeesImages,
      attendeesCount: attendeesCount,
      title: title,
      startAt: startAt,
      endAt: endAt,
      venue: venue,
      city: city,
      organizer: organizer,
      price: price,
      eventStatus: eventStatus,
      description: description,
      isFavorite: isFavorite,
      favoritableType: favoritableType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'get_attendees_images_attribute': attendeesImages,
      'attendees_count': attendeesCount,
      'title': title,
      'start_at': startAt,
      'end_at': endAt,
      'venue': venue,
      'city': city,
      'organizer': organizer,
      'price': price,
      'event_status': eventStatus,
      'description': description,
      'is_favorite': isFavorite,
      'favoritable_type': favoritableType,
    };
  }

  // Convert to format that existing UI expects
  Map<String, dynamic> toEventData() {
    print('🔄 Converting EventDetailsModel to EventData...');
    print('📊 Original data: title=$title, venue=$venue, city=$city');

    final eventData = {
      'title': title.isNotEmpty ? title : 'Event Title',
      'date': _formatDate(
        startAt.isNotEmpty ? startAt : '1st Jan - Mon - 12:00 AM',
      ),
      'day': _extractDay(
        startAt.isNotEmpty ? startAt : '1st Jan - Mon - 12:00 AM',
      ),
      'time': _extractTime(
        startAt.isNotEmpty ? startAt : '1st Jan - Mon - 12:00 AM',
        endAt.isNotEmpty ? endAt : '1st Jan - Mon - 11:59 PM',
      ),
      'location': venue.isNotEmpty ? venue : 'Venue',
      'country': city.isNotEmpty ? city : 'City',
      'organizer': organizer.isNotEmpty ? organizer : 'Organizer',
      'organizerCountry': 'KSA', // Default value
      'about': description.isNotEmpty ? description : 'Event description',
      'attendees': '+$attendeesCount Going',
      'price': 'SR$price',
      'image': imageUrl.isNotEmpty ? imageUrl : '',
      'isBookmarked': isFavorite,
    };

    print('✅ Converted EventData: ${eventData.keys.toList()}');
    print('🎯 Final image URL: ${eventData['image']}');

    return eventData;
  }

  String _formatDate(String startAt) {
    // Convert "26th Sep - Fri - 12:00 AM" to "26 September, 2025"
    if (startAt.isEmpty) return 'Date';

    try {
      final parts = startAt.split(' ');
      if (parts.length >= 2) {
        final day = parts[0].replaceAll(RegExp(r'[^\d]'), '');
        final month = _getFullMonth(parts[1]);
        return '$day $month, 2025'; // Assuming current year
      }
    } catch (e) {
      print('❌ Error formatting date: $e');
    }
    return startAt;
  }

  String _extractDay(String startAt) {
    // Extract "Tuesday" from "26th Sep - Fri - 12:00 AM"
    if (startAt.isEmpty) return 'Day';

    try {
      final parts = startAt.split(' - ');
      if (parts.length >= 2) {
        return parts[1];
      }
    } catch (e) {
      print('❌ Error extracting day: $e');
    }
    return 'Day';
  }

  String _extractTime(String startAt, String endAt) {
    // Extract time from both dates
    if (startAt.isEmpty || endAt.isEmpty) return '12:00 AM - 11:59 PM';

    try {
      final startParts = startAt.split(' - ');
      final endParts = endAt.split(' - ');

      if (startParts.length >= 3 && endParts.length >= 3) {
        final startTime = startParts[2];
        final endTime = endParts[2];
        return '$startTime - $endTime';
      }
    } catch (e) {
      print('❌ Error extracting time: $e');
    }
    return '12:00 AM - 11:59 PM';
  }

  String _getFullMonth(String shortMonth) {
    const monthMap = {
      'Jan': 'January',
      'Feb': 'February',
      'Mar': 'March',
      'Apr': 'April',
      'May': 'May',
      'Jun': 'June',
      'Jul': 'July',
      'Aug': 'August',
      'Sep': 'September',
      'Oct': 'October',
      'Nov': 'November',
      'Dec': 'December',
    };
    return monthMap[shortMonth] ?? shortMonth;
  }
}

class EventDetailsResponse {
  final bool status;
  final int code;
  final String message;
  final EventDetailsModel event;

  EventDetailsResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.event,
  });

  factory EventDetailsResponse.fromJson(Map<String, dynamic> json) {
    print('🔍 EventDetailsResponse.fromJson: $json');
    print('📊 Data keys: ${json.keys.toList()}');

    // First priority: Check for wrapped format (status, code, msg, data)
    if (json.containsKey('status') &&
        json.containsKey('data') &&
        json['data'] != null) {
      print('📦 Using wrapped response format (Postman style)');
      final data = json['data'] as Map<String, dynamic>;
      print('📦 Data content: $data');

      if (data.containsKey('event')) {
        return EventDetailsResponse(
          status: json['status'] ?? false,
          code: json['code'] ?? 0,
          message: json['msg'] ?? '',
          event: EventDetailsModel.fromJson(data['event']),
        );
      } else {
        throw Exception('Event data not found in response');
      }
    }
    // Second priority: Direct event format
    else if (json.containsKey('event')) {
      print('📦 Using direct response format');
      return EventDetailsResponse(
        status: true,
        code: 200,
        message: 'Success',
        event: EventDetailsModel.fromJson(json['event']),
      );
    }
    // Unknown format
    else {
      print('❌ Unknown response format');
      print('📄 Available keys: ${json.keys.toList()}');
      throw Exception(
        'Invalid response format: Expected "status+data" or "event" key',
      );
    }
  }
}
