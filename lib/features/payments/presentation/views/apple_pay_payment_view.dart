import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/cubits/order_cubit.dart';

class ApplePayPaymentView extends StatefulWidget {
  final String totalAmount;
  final String orderTitle;
  final Map<String, dynamic>? orderData;

  const ApplePayPaymentView({
    super.key,
    required this.totalAmount,
    required this.orderTitle,
    this.orderData,
  });

  @override
  State<ApplePayPaymentView> createState() => _ApplePayPaymentViewState();
}

class _ApplePayPaymentViewState extends State<ApplePayPaymentView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  bool _isProcessing = false;
  bool _isAuthenticated = false;
  String _selectedCard = 'Apple Card';

  final List<Map<String, dynamic>> _cards = [
    {
      'name': 'Apple Card',
      'last4': '1234',
      'color': Colors.black,
      'icon': Icons.apple,
    },
    {
      'name': 'Chase Visa',
      'last4': '5678',
      'color': const Color(0xFF1E3A8A),
      'icon': '💳',
    },
    {
      'name': 'Wells Fargo',
      'last4': '9012',
      'color': const Color(0xFFDC2626),
      'icon': '🏦',
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
            const Text('Authenticated with Face ID'),
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
              const Text('Apple Pay payment successful!'),
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

    print('🚀 Apple Pay: Processing API payment for $orderType');

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
                    const Text('Processing Apple Pay payment...'),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Apple Pay',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
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
                    // Apple Pay Header
                    _buildApplePayHeader(),
                    const SizedBox(height: 32),

                    // Order Summary
                    _buildOrderSummary(),
                    const SizedBox(height: 32),

                    // Card Selection
                    _buildCardSelection(),
                    const SizedBox(height: 32),

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

  Widget _buildApplePayHeader() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey.shade900, Colors.black],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade800, width: 1),
            ),
            child: Column(
              children: [
                // Apple Logo
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
                    child: Icon(Icons.apple, size: 40, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Apple Pay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The easiest way to pay',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Apple Pay',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                widget.totalAmount,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
              ? Colors.white.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey.shade800,
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
                child: card['icon'] is IconData
                    ? Icon(
                        card['icon'] as IconData,
                        size: 20,
                        color: Colors.white,
                      )
                    : Text(
                        card['icon'] as String,
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
                    card['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '•••• ${card['last4']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthentication() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        children: [
          const Text(
            'Authenticate Payment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Use Face ID or Touch ID to authenticate',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Face ID Button
          GestureDetector(
            onTap: _authenticate,
            child: Container(
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
                child: Icon(Icons.fingerprint, size: 40, color: Colors.black),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            'Double tap to authenticate',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade800, width: 1),
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
                  child:
                      _cards.firstWhere(
                            (card) => card['name'] == _selectedCard,
                          )['icon']
                          is IconData
                      ? Icon(
                          _cards.firstWhere(
                                (card) => card['name'] == _selectedCard,
                              )['icon']
                              as IconData,
                          size: 20,
                          color: Colors.white,
                        )
                      : Text(
                          _cards.firstWhere(
                                (card) => card['name'] == _selectedCard,
                              )['icon']
                              as String,
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Authenticated',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade400,
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
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
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
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.apple, size: 20, color: Colors.black),
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
