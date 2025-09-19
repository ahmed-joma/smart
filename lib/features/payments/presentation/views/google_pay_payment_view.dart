import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/cubits/order_cubit.dart';

class GooglePayPaymentView extends StatefulWidget {
  final String totalAmount;
  final String orderTitle;
  final Map<String, dynamic>? orderData;

  const GooglePayPaymentView({
    super.key,
    required this.totalAmount,
    required this.orderTitle,
    this.orderData,
  });

  @override
  State<GooglePayPaymentView> createState() => _GooglePayPaymentViewState();
}

class _GooglePayPaymentViewState extends State<GooglePayPaymentView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  bool _isProcessing = false;
  bool _isAuthenticated = false;
  String _selectedCard = 'Chase Visa';

  final List<Map<String, dynamic>> _cards = [
    {
      'name': 'Chase Visa',
      'last4': '1234',
      'color': const Color(0xFF1E3A8A),
      'icon': '💳',
    },
    {
      'name': 'Wells Fargo',
      'last4': '5678',
      'color': const Color(0xFFDC2626),
      'icon': '🏦',
    },
    {
      'name': 'Bank of America',
      'last4': '9012',
      'color': const Color(0xFF059669),
      'icon': '🏛️',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _authenticate() {
    setState(() => _isAuthenticated = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.fingerprint, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            const Text('Authenticated with Google Pay'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _processPayment() {
    setState(() => _isProcessing = true);

    // Check if API integration is enabled
    final orderData = widget.orderData;
    final isApiIntegration = orderData?['api_integration'] == true;

    if (isApiIntegration) {
      _processAPIPayment();
    } else {
      _processSimulatedPayment();
    }
  }

  void _processSimulatedPayment() {
    // محاكاة عملية الدفع (الطريقة القديمة)
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Text('Google Pay payment successful!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      // العودة للصفحة السابقة
      context.pop();
    });
  }

  void _processAPIPayment() {
    final orderData = widget.orderData!;
    final orderType = orderData['type'];

    print('🚀 Google Pay: Processing API payment for $orderType');

    final orderCubit = OrderCubit();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: orderCubit,
          child: BlocConsumer<OrderCubit, OrderState>(
            listener: (context, state) {
              if (state is OrderSuccess) {
                Navigator.of(dialogContext).pop();
                setState(() => _isProcessing = false);

                if (orderType == 'hotel' && state.orderData.booking != null) {
                  context.go(
                    '/bookingSuccess',
                    extra: {
                      'type': 'hotel',
                      'booking': state.orderData.booking!.toJson(),
                    },
                  );
                } else if (orderType == 'event' &&
                    state.orderData.ticket != null) {
                  context.go(
                    '/ticketSuccess',
                    extra: {
                      'type': 'event',
                      'ticket': state.orderData.ticket!.toJson(),
                    },
                  );
                }
              } else if (state is OrderError) {
                Navigator.of(dialogContext).pop();
                setState(() => _isProcessing = false);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Payment failed: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text('Processing Google Pay payment...'),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    // Start API order process
    if (orderType == 'hotel') {
      final hotelId = orderData['hotel_id'] as int?;
      final totalPrice = orderData['total_price'] as double?;

      if (hotelId != null && totalPrice != null) {
        orderCubit.bookHotel(hotelId: hotelId, totalPrice: totalPrice);
      }
    } else if (orderType == 'event') {
      final eventId = orderData['event_id'] as int?;
      final totalPrice = orderData['total_price'] as double?;

      if (eventId != null && totalPrice != null) {
        orderCubit.buyEventTicket(eventId: eventId, totalPrice: totalPrice);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Google Pay',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 30 * (1 - _slideAnimation.value)),
            child: Opacity(
              opacity: _slideAnimation.value,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Google Pay Header
                    _buildGooglePayHeader(),
                    const SizedBox(height: 24),

                    // Order Summary
                    _buildOrderSummary(),
                    const SizedBox(height: 24),

                    // Card Selection
                    _buildCardSelection(),
                    const SizedBox(height: 24),

                    // Authentication or Payment
                    _isAuthenticated
                        ? _buildPaymentSection()
                        : _buildAuthentication(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGooglePayHeader() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF4285F4),
                  const Color(0xFF34A853),
                  const Color(0xFFFBBC05),
                  const Color(0xFFEA4335),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4285F4).withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Google Pay Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4285F4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Google Pay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fast, simple, secure',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderSummary() {
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4285F4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Color(0xFF4285F4),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.orderTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Google Pay',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                widget.totalAmount,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4285F4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardSelection() {
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
            'Select Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ..._cards.map((card) => _buildCardOption(card)).toList(),
        ],
      ),
    );
  }

  Widget _buildCardOption(Map<String, dynamic> card) {
    final isSelected = _selectedCard == card['name'];

    return GestureDetector(
      onTap: () {
        setState(() => _selectedCard = card['name']);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4285F4).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4285F4) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: card['color'],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(card['icon'], style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '•••• ${card['last4']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF4285F4),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthentication() {
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
        children: [
          const Text(
            'Authenticate Payment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Use fingerprint or PIN to authenticate',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Fingerprint Button
          GestureDetector(
            onTap: _authenticate,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF4285F4),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4285F4).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.fingerprint, size: 40, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            'Tap to authenticate',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
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
        children: [
          // Selected Card Info
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _cards.firstWhere(
                    (card) => card['name'] == _selectedCard,
                  )['color'],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _cards.firstWhere(
                      (card) => card['name'] == _selectedCard,
                    )['icon'],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedCard,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Authenticated',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pay Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'G',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Pay ${widget.totalAmount}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
