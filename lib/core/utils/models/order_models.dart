class Order {
  final int id;
  final String status;
  final double totalAmount;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'SAR',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'total_amount': totalAmount,
      'currency': currency,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int id;
  final String type; // 'event' or 'hotel'
  final int itemId;
  final String itemName;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.type,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      itemId: json['item_id'] ?? 0,
      itemName: json['item_name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'item_id': itemId,
      'item_name': itemName,
      'price': price,
      'quantity': quantity,
    };
  }
}

class CreateOrderRequest {
  final List<OrderItemRequest> items;
  final String paymentMethod;
  final String? notes;

  CreateOrderRequest({
    required this.items,
    required this.paymentMethod,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
    };
  }
}

class OrderItemRequest {
  final String type; // 'event' or 'hotel'
  final int itemId;
  final int quantity;

  OrderItemRequest({
    required this.type,
    required this.itemId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {'type': type, 'item_id': itemId, 'quantity': quantity};
  }
}
