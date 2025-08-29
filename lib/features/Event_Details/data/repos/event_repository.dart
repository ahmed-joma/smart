import '../models/event_model.dart';

abstract class EventRepository {
  Future<EventModel> getEventById(String eventId);
  Future<List<EventModel>> getAllEvents();
  Future<bool> bookmarkEvent(String eventId);
  Future<bool> unbookmarkEvent(String eventId);
}

class EventRepositoryImpl implements EventRepository {
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
