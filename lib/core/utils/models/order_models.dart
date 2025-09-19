// Order Models for API Integration

// Store Order Request
class OrderRequest {
  final String orderableType; // "App\\Models\\Event" or "App\\Models\\Hotel"
  final int orderableId;
  final double totalPrice;

  OrderRequest({
    required this.orderableType,
    required this.orderableId,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderable_type': orderableType,
      'orderable_id': orderableId,
      'total_price': totalPrice,
    };
  }
}

// Store Order Response
class OrderResponse {
  final bool status;
  final int code;
  final String msg;
  final OrderData data;

  OrderResponse({
    required this.status,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: OrderData.fromJson(json['data'] ?? {}),
    );
  }
}

class OrderData {
  final HotelBooking? booking; // For hotel bookings
  final EventTicket? ticket; // For event tickets

  OrderData({this.booking, this.ticket});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      booking: json['booking'] != null
          ? HotelBooking.fromJson(json['booking'])
          : null,
      ticket: json['ticket'] != null
          ? EventTicket.fromJson(json['ticket'])
          : null,
    );
  }
}

// Hotel Booking Model
class HotelBooking {
  final int id;
  final String hotelCoverUrl;
  final String hotelName;
  final String hotelCity;
  final String hotelVenue;
  final String bookingCheckIn;
  final String bookingCheckOut;
  final String orderPrice;
  final String userName;
  final String orderCreatedAt;
  final String time;
  final String barcodeImage;
  final String orderNumber;

  HotelBooking({
    required this.id,
    required this.hotelCoverUrl,
    required this.hotelName,
    required this.hotelCity,
    required this.hotelVenue,
    required this.bookingCheckIn,
    required this.bookingCheckOut,
    required this.orderPrice,
    required this.userName,
    required this.orderCreatedAt,
    required this.time,
    required this.barcodeImage,
    required this.orderNumber,
  });

  factory HotelBooking.fromJson(Map<String, dynamic> json) {
    return HotelBooking(
      id: json['id'] ?? 0,
      hotelCoverUrl: json['hotel_cover_url']?.toString() ?? '',
      hotelName: json['hotel_name']?.toString() ?? '',
      hotelCity: json['hotel_city']?.toString() ?? '',
      hotelVenue: json['hotel_venue']?.toString() ?? '',
      bookingCheckIn: json['booking_check_in']?.toString() ?? '',
      bookingCheckOut: json['booking_check_out']?.toString() ?? '',
      orderPrice: json['order_price']?.toString() ?? '0',
      userName: json['user_name']?.toString() ?? '',
      orderCreatedAt: json['order_created_at']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      barcodeImage: json['barcode_image']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_cover_url': hotelCoverUrl,
      'hotel_name': hotelName,
      'hotel_city': hotelCity,
      'hotel_venue': hotelVenue,
      'booking_check_in': bookingCheckIn,
      'booking_check_out': bookingCheckOut,
      'order_price': orderPrice,
      'user_name': userName,
      'order_created_at': orderCreatedAt,
      'time': time,
      'barcode_image': barcodeImage,
      'order_number': orderNumber,
    };
  }
}

// Event Ticket Model
class EventTicket {
  final int ticketId;
  final String eventImageUrl;
  final String eventTitle;
  final String eventStartAt;
  final String eventEndAt;
  final String eventCity;
  final String eventVenue;
  final String userName;
  final String orderNumber;
  final String orderCreatedAt;
  final String orderPrice;
  final String time;
  final String gate;
  final String seat;
  final String barcodeImage;
  final String barcodeNumber;

  EventTicket({
    required this.ticketId,
    required this.eventImageUrl,
    required this.eventTitle,
    required this.eventStartAt,
    required this.eventEndAt,
    required this.eventCity,
    required this.eventVenue,
    required this.userName,
    required this.orderNumber,
    required this.orderCreatedAt,
    required this.orderPrice,
    required this.time,
    required this.gate,
    required this.seat,
    required this.barcodeImage,
    required this.barcodeNumber,
  });

  factory EventTicket.fromJson(Map<String, dynamic> json) {
    return EventTicket(
      ticketId: json['ticket_id'] ?? 0,
      eventImageUrl: json['event_image_url']?.toString() ?? '',
      eventTitle: json['event_title']?.toString() ?? '',
      eventStartAt: json['event_start_at']?.toString() ?? '',
      eventEndAt: json['event_end_at']?.toString() ?? '',
      eventCity: json['event_city']?.toString() ?? '',
      eventVenue: json['event_venue']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      orderNumber: json['order_number']?.toString() ?? '',
      orderCreatedAt: json['order_created_at']?.toString() ?? '',
      orderPrice: json['order_price']?.toString() ?? '0',
      time: json['time']?.toString() ?? '',
      gate: json['gate']?.toString() ?? '',
      seat: json['seat']?.toString() ?? '',
      barcodeImage: json['barcode_image']?.toString() ?? '',
      barcodeNumber: json['barcode_number']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'event_image_url': eventImageUrl,
      'event_title': eventTitle,
      'event_start_at': eventStartAt,
      'event_end_at': eventEndAt,
      'event_city': eventCity,
      'event_venue': eventVenue,
      'user_name': userName,
      'order_number': orderNumber,
      'order_created_at': orderCreatedAt,
      'order_price': orderPrice,
      'time': time,
      'gate': gate,
      'seat': seat,
      'barcode_image': barcodeImage,
      'barcode_number': barcodeNumber,
    };
  }
}

// User Orders Response (for GET /order/showUserOrders)
class UserOrdersResponse {
  final bool status;
  final int code;
  final String msg;
  final UserOrdersData data;

  UserOrdersResponse({
    required this.status,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory UserOrdersResponse.fromJson(Map<String, dynamic> json) {
    return UserOrdersResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: UserOrdersData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserOrdersData {
  final EventOrders events;
  final HotelOrders hotels;

  UserOrdersData({required this.events, required this.hotels});

  factory UserOrdersData.fromJson(Map<String, dynamic> json) {
    return UserOrdersData(
      events: EventOrders.fromJson(json['events'] ?? {}),
      hotels: HotelOrders.fromJson(json['hotels'] ?? {}),
    );
  }
}

class EventOrders {
  final List<OrderedEvent> upcoming;
  final List<OrderedEvent> past;

  EventOrders({required this.upcoming, required this.past});

  factory EventOrders.fromJson(Map<String, dynamic> json) {
    return EventOrders(
      upcoming:
          (json['upcoming'] as List<dynamic>?)
              ?.map((e) => OrderedEvent.fromJson(e))
              .toList() ??
          [],
      past:
          (json['past'] as List<dynamic>?)
              ?.map((e) => OrderedEvent.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class HotelOrders {
  final List<OrderedHotel> current;
  final List<OrderedHotel> past;

  HotelOrders({required this.current, required this.past});

  factory HotelOrders.fromJson(Map<String, dynamic> json) {
    return HotelOrders(
      current:
          (json['current'] as List<dynamic>?)
              ?.map((e) => OrderedHotel.fromJson(e))
              .toList() ??
          [],
      past:
          (json['past'] as List<dynamic>?)
              ?.map((e) => OrderedHotel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OrderedEvent {
  final int id;
  final String formattedStartAt;
  final String imageUrl;
  final List<String> attendeesImages;
  final String cityName;
  final String venue;
  final bool isFavorite;
  final String favoritableType;

  OrderedEvent({
    required this.id,
    required this.formattedStartAt,
    required this.imageUrl,
    required this.attendeesImages,
    required this.cityName,
    required this.venue,
    required this.isFavorite,
    required this.favoritableType,
  });

  factory OrderedEvent.fromJson(Map<String, dynamic> json) {
    return OrderedEvent(
      id: json['id'] ?? 0,
      formattedStartAt: json['formatted_start_at']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      attendeesImages:
          (json['attendees_images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      cityName: json['city_name']?.toString() ?? '',
      venue: json['venue']?.toString() ?? '',
      isFavorite: json['is_favorite'] ?? false,
      favoritableType: json['favoritable_type']?.toString() ?? '',
    );
  }
}

class OrderedHotel {
  final int id;
  final String coverUrl;
  final String name;
  final int rate;
  final String city;
  final String venue;
  final String pricePerNight;
  final bool isFavorite;
  final String favoritableType;

  OrderedHotel({
    required this.id,
    required this.coverUrl,
    required this.name,
    required this.rate,
    required this.city,
    required this.venue,
    required this.pricePerNight,
    required this.isFavorite,
    required this.favoritableType,
  });

  factory OrderedHotel.fromJson(Map<String, dynamic> json) {
    return OrderedHotel(
      id: json['id'] ?? 0,
      coverUrl: json['cover_url']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      rate: json['rate'] ?? 0,
      city: json['city']?.toString() ?? '',
      venue: json['venue']?.toString() ?? '',
      pricePerNight: json['price_per_night']?.toString() ?? '0',
      isFavorite: json['is_favorite'] ?? false,
      favoritableType: json['favoritable_type']?.toString() ?? '',
    );
  }
}
