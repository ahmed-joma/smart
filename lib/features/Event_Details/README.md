# Event Details Feature

## Overview
This feature displays detailed information about events, including images, descriptions, dates, locations, and organizer information.

## Features
- **Event Details View**: Full-screen event information display
- **Scrollable Content**: Long content with smooth scrolling
- **Navigation**: Back button to return to previous screen
- **Bookmarking**: Save events for later viewing
- **Responsive Design**: Adapts to different screen sizes

## Architecture
- **Clean Architecture**: Follows feature-based folder structure
- **State Management**: Uses Cubit for state management
- **Repository Pattern**: Abstract data layer for API calls
- **Model Classes**: Strongly typed data models

## File Structure
```
Event_Details/
├── data/
│   ├── models/
│   │   └── event_model.dart
│   └── repos/
│       └── event_repository.dart
├── presentation/
│   ├── manager/
│   │   └── event_cubit.dart
│   └── views/
│       ├── Event_Details_view.dart
│       └── widgets/
│           └── Event_Details_body.dart
└── Event_Details.dart
```

## Usage

### Navigation
```dart
// Navigate to Event Details
context.push('/eventDetailsView', extra: eventData);

// Example event data
final eventData = {
  'id': 'event_123',
  'title': 'City Walk event',
  'date': '14 December, 2025',
  'day': 'Tuesday',
  'time': '4:00PM - 9:00PM',
  'location': 'Jeddah King Abdulaziz Road',
  'country': 'KSA',
  'organizer': 'Entertainment Authority',
  'organizerCountry': 'SA',
  'about': 'Event description...',
  'attendees': '+20 Going',
  'price': 'SR120',
  'image': 'assets/images/citywaikevents.svg',
};
```

### State Management
```dart
// Listen to state changes
BlocBuilder<EventCubit, EventState>(
  builder: (context, state) {
    if (state is EventLoading) {
      return CircularProgressIndicator();
    } else if (state is EventLoaded) {
      return EventDetailsBody(event: state.event);
    } else if (state is EventError) {
      return Text(state.message);
    }
    return Container();
  },
);

// Trigger actions
context.read<EventCubit>().loadEvent('event_123');
context.read<EventCubit>().bookmarkEvent('event_123');
```

## API Integration
The feature is ready for API integration. Update the `EventRepositoryImpl` class to make actual HTTP requests:

```dart
@override
Future<EventModel> getEventById(String eventId) async {
  // TODO: Replace with actual API call
  final response = await http.get('/api/events/$eventId');
  return EventModel.fromJson(response.data);
}
```

## Customization
- **Colors**: Update `AppColors` for theme consistency
- **Images**: Replace placeholder images with actual event images
- **Layout**: Modify `Event_Details_body.dart` for different layouts
- **Data**: Extend `EventModel` for additional fields

## Dependencies
- `flutter_bloc`: State management
- `equatable`: Value equality
- `go_router`: Navigation
- `flutter_svg`: SVG image support
