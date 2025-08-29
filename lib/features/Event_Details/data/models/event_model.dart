class EventModel {
  final String id;
  final String title;
  final String date;
  final String day;
  final String time;
  final String location;
  final String country;
  final String organizer;
  final String organizerCountry;
  final String about;
  final String attendees;
  final String price;
  final String image;
  final bool isBookmarked;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.day,
    required this.time,
    required this.location,
    required this.country,
    required this.organizer,
    required this.organizerCountry,
    required this.about,
    required this.attendees,
    required this.price,
    required this.image,
    this.isBookmarked = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      country: json['country'] ?? '',
      organizer: json['organizer'] ?? '',
      organizerCountry: json['organizerCountry'] ?? '',
      about: json['about'] ?? '',
      attendees: json['attendees'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'day': day,
      'time': time,
      'location': location,
      'country': country,
      'organizer': organizer,
      'organizerCountry': organizerCountry,
      'about': about,
      'attendees': attendees,
      'price': price,
      'image': image,
      'isBookmarked': isBookmarked,
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? date,
    String? day,
    String? time,
    String? location,
    String? country,
    String? organizer,
    String? organizerCountry,
    String? about,
    String? attendees,
    String? price,
    String? image,
    bool? isBookmarked,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      day: day ?? this.day,
      time: time ?? this.time,
      location: location ?? this.location,
      country: country ?? this.country,
      organizer: organizer ?? this.organizer,
      organizerCountry: organizerCountry ?? this.organizerCountry,
      about: about ?? this.about,
      attendees: attendees ?? this.attendees,
      price: price ?? this.price,
      image: image ?? this.image,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
