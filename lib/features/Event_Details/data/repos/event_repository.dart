import '../models/event_model.dart';
import '../models/event_details_model.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../../../../core/utils/service_locator.dart';

abstract class EventRepository {
  Future<EventModel> getEventById(String eventId);
  Future<EventDetailsModel> getEventDetailsById(int eventId);
  Future<List<EventModel>> getAllEvents();
  Future<bool> bookmarkEvent(String eventId);
  Future<bool> unbookmarkEvent(String eventId);
}

class EventRepositoryImpl implements EventRepository {
  final ApiService _apiService = sl<ApiService>();

  @override
  Future<EventModel> getEventById(String eventId) async {
    // TODO: Implement API call
    // This is a mock implementation for now
    await Future.delayed(const Duration(milliseconds: 500));

    return EventModel(
      id: eventId,
      title: 'City Walk event',
      date: '14 December, 2025',
      day: 'Tuesday',
      time: '4:00PM - 9:00PM',
      location: 'Jeddah King Abdulaziz Road',
      country: 'KSA',
      organizer: 'Entertainment Authority',
      organizerCountry: 'SA',
      about:
          'The best event in Jeddah, unique and wonderful, with many restaurants, events and games.',
      attendees: '+20 Going',
      price: 'SR120',
      image: 'assets/images/citywaikevents.svg',
      isBookmarked: false,
    );
  }

  @override
  Future<EventDetailsModel> getEventDetailsById(int eventId) async {
    try {
      print('🔍 EventRepository: Fetching event details for ID: $eventId');

      // Ensure token is loaded before making the request
      await _apiService.loadToken();

      // Check if we have a valid token
      if (_apiService.token == null) {
        throw Exception(
          'No authentication token available. Please login again.',
        );
      }

      print('🔑 EventRepository: Using token for authentication');

      final response = await _apiService.get<EventDetailsResponse>(
        '${ApiConstants.eventDetails}/$eventId',
        fromJson: (json) {
          print('🔍 Repository: Raw JSON received: $json');
          return EventDetailsResponse.fromJson(json);
        },
      );

      print('✅ EventRepository: Event details fetched successfully');
      print('📊 Response status: ${response.status}');
      print('📦 Response data: ${response.data}');

      if (!response.status || response.data == null) {
        throw Exception('Invalid response from server');
      }

      // ApiService returns ApiResponse<EventDetailsResponse>, so response.data is EventDetailsResponse
      final eventDetailsResponse = response.data!;
      print('📦 Event title: ${eventDetailsResponse.event.title}');

      return eventDetailsResponse.event;
    } catch (e) {
      print('❌ EventRepository: Error fetching event details: $e');

      String errorMessage;
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        errorMessage = 'Authentication failed. Please login again.';
      } else if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
      } else if (e.toString().contains('404') ||
          e.toString().contains('Not Found')) {
        errorMessage = 'Event not found.';
      } else if (e.toString().contains('Connection')) {
        errorMessage = 'Network connection error. Please check your internet.';
      } else {
        errorMessage = 'Failed to load event details. Please try again.';
      }

      throw Exception(errorMessage);
    }
  }

  @override
  Future<List<EventModel>> getAllEvents() async {
    // TODO: Implement API call
    // This is a mock implementation for now
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      EventModel(
        id: '1',
        title: 'City Walk event',
        date: '14 December, 2025',
        day: 'Tuesday',
        time: '4:00PM - 9:00PM',
        location: 'Jeddah King Abdulaziz Road',
        country: 'KSA',
        organizer: 'Entertainment Authority',
        organizerCountry: 'SA',
        about:
            'The best event in Jeddah, unique and wonderful, with many restaurants, events and games.',
        attendees: '+20 Going',
        price: 'SR120',
        image: 'assets/images/citywaikevents.svg',
        isBookmarked: false,
      ),
      EventModel(
        id: '2',
        title: 'Art Promenade',
        date: '20 December, 2025',
        day: 'Monday',
        time: '6:00PM - 10:00PM',
        location: 'Riyadh Art District',
        country: 'KSA',
        organizer: 'Arts Council',
        organizerCountry: 'SA',
        about:
            'A beautiful art exhibition showcasing local and international artists.',
        attendees: '+15 Going',
        price: 'SR80',
        image: 'assets/images/Art Promenade.svg',
        isBookmarked: true,
      ),
    ];
  }

  @override
  Future<bool> bookmarkEvent(String eventId) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> unbookmarkEvent(String eventId) async {
    // TODO: Implement API call
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
