import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'widgets/section_order_header.dart';
import 'widgets/section_payment_button.dart';
import 'widgets/section_coupon_discount.dart';
import 'widgets/section_advanced_payment_methods.dart';

class OrderSummaryView extends StatefulWidget {
  final Map<String, dynamic>? orderData;

  const OrderSummaryView({super.key, this.orderData});

  @override
  State<OrderSummaryView> createState() => _OrderSummaryViewState();
}

class _OrderSummaryViewState extends State<OrderSummaryView> {
  String _selectedPaymentMethod = 'card';
  String _currentTotalPrice = '';
  double _originalPrice = 0.0;
  String _userEmail = 'guest@example.com';
  String _userName = 'Guest User';

  @override
  void initState() {
    super.initState();
    _loadPriceData();
    _loadUserData();
  }

  void _loadPriceData() {
    // تحويل السعر إلى رقم
    final orderData = widget.orderData;
    if (orderData != null) {
      final priceStr = orderData['total'] ?? 'SR 138';
      _originalPrice = double.tryParse(priceStr.replaceAll('SR ', '')) ?? 138.0;
      _currentTotalPrice = orderData['total'] ?? 'SR 138';
    }
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');

      if (userDataString != null) {
        final userData = json.decode(userDataString);
        setState(() {
          _userEmail = userData['email']?.toString() ?? 'guest@example.com';
          _userName = userData['full_name']?.toString() ?? 'Guest User';
        });
        print('✅ User data loaded: $_userName ($_userEmail)');
      } else {
        print('⚠️ No user data found in SharedPreferences');
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get order data (use passed data directly - it already contains API data when needed)
    final orderData = widget.orderData ?? _getDefaultOrderData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Order summary',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced Order Header (shows API data)
                  SectionOrderHeader(orderData: orderData),
                  const SizedBox(height: 24),

                  // Recipients Section
                  _buildRecipientsSection(),
                  const SizedBox(height: 24),

                  // Price Details Section
                  _buildPriceDetailsSection(orderData),
                  const SizedBox(height: 24),

                  // Coupon Discount Section
                  SectionCouponDiscount(
                    originalPrice: _originalPrice,
                    onCouponApplied: (discountedPrice) {
                      setState(() {
                        _currentTotalPrice = discountedPrice;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Advanced Payment Methods
                  SectionAdvancedPaymentMethods(
                    selectedMethod: _selectedPaymentMethod,
                    onMethodSelected: (method) {
                      setState(() {
                        _selectedPaymentMethod = method;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Enhanced Payment Button
          SectionPaymentButton(
            totalPrice: _currentTotalPrice.isNotEmpty
                ? _currentTotalPrice
                : (orderData['total'] ?? 'SR 138'),
            onPressed: () {
              // توجيه للصفحة المناسبة حسب طريقة الدفع المختارة
              switch (_selectedPaymentMethod) {
                case 'card':
                  context.push(
                    '/creditCardPayment',
                    extra: {
                      'totalAmount': _currentTotalPrice.isNotEmpty
                          ? _currentTotalPrice
                          : (orderData['total'] ?? 'SR 138'),
                      'orderTitle': orderData['title'] ?? 'Order',
                      'orderData':
                          orderData, // Pass full order data with API info
                    },
                  );
                  break;
                case 'apple_pay':
                  context.push(
                    '/applePayPayment',
                    extra: {
                      'totalAmount': _currentTotalPrice.isNotEmpty
                          ? _currentTotalPrice
                          : (orderData['total'] ?? 'SR 138'),
                      'orderTitle': orderData['title'] ?? 'Order',
                      'orderData':
                          orderData, // Pass full order data with API info
                    },
                  );
                  break;
                default:
                  // افتراضياً بطاقة ائتمان
                  context.push(
                    '/creditCardPayment',
                    extra: {
                      'totalAmount': _currentTotalPrice.isNotEmpty
                          ? _currentTotalPrice
                          : (orderData['total'] ?? 'SR 138'),
                      'orderTitle': orderData['title'] ?? 'Order',
                      'orderData':
                          orderData, // Pass full order data with API info
                    },
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getDefaultOrderData() {
    return {
      'title': 'City Walk event',
      'date': '14 December, 2025',
      'location': 'Jeddah King Abdulaziz Road',
      'image': 'assets/images/citywaikevents.svg',
      'price': 'SR 120',
      'tax': 'SR 18',
      'total': 'SR 138',
      'type': 'event',
    };
  }

  Widget _buildRecipientsSection() {
    // Use real user data loaded from SharedPreferences

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recipients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Add recipient functionality
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.orderData?['type'] == 'hotel'
                ? 'Primary guest for this hotel booking'
                : 'Add other recipients of this event ticket',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // User Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7F2F3A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person,
                      color: const Color(0xFF7F2F3A),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userEmail,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // TODO: Edit recipient functionality
                },
                child: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetailsSection(Map<String, dynamic> orderData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            orderData['type'] == 'hotel' ? 'Hotel Booking' : 'Event Ticket',
            orderData['price'] ?? 'SR 120',
          ),
          const SizedBox(height: 8),
          _buildPriceRow('TAX', orderData['tax'] ?? 'SR 18'),
          const SizedBox(height: 8),
          _buildPriceRow('Discounts', '000'),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                orderData['total'] ?? 'SR 138',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7F2F3A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.black)),
      ],
    );
  }
}
