import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/cubits/order_cubit.dart';

class PayPalPaymentView extends StatefulWidget {
  final String totalAmount;
  final String orderTitle;
  final Map<String, dynamic> orderData;

  const PayPalPaymentView({
    super.key,
    required this.totalAmount,
    required this.orderTitle,
    required this.orderData,
  });

  @override
  State<PayPalPaymentView> createState() => _PayPalPaymentViewState();
}

class _PayPalPaymentViewState extends State<PayPalPaymentView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _loadingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    // Start pulsing animation
    _loadingController.repeat(reverse: true);

    // Check if API integration is enabled
    final orderData = widget.orderData;
    final isApiIntegration = orderData['api_integration'] == true;

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
      _loadingController.stop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Text('PayPal payment successful!'),
            ],
          ),
          backgroundColor: const Color(0xFF0070BA),
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
    final orderData = widget.orderData;
    final orderType = orderData['type'];

    print('🚀 PayPal: Processing API payment for $orderType');

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
                _loadingController.stop();

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
                _loadingController.stop();

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
                    const Text('Processing PayPal payment...'),
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // Navigate back to Order Summary page instead of PayPal Login
            context.go('/orderSummary');
          },
        ),
        title: const Text(
          'PayPal Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PayPal Header Card
                    _buildPayPalHeaderCard(),

                    const SizedBox(height: 24),

                    // Order Summary Card
                    _buildOrderSummaryCard(),

                    const SizedBox(height: 24),

                    // Payment Details Card
                    _buildPaymentDetailsCard(),

                    const SizedBox(height: 32),

                    // PayPal Pay Button
                    _buildPayPalButton(),

                    const SizedBox(height: 20),

                    // Security Notice
                    _buildSecurityNotice(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPayPalHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0070BA), // PayPal Blue
            Color(0xFF009CDE), // PayPal Light Blue
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0070BA).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // PayPal Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'PayPal',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Pay securely with your PayPal account',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      width: double.infinity,
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
          const Row(
            children: [
              Icon(Icons.shopping_bag, color: Color(0xFF7F2F3A), size: 24),
              SizedBox(width: 12),
              Text(
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

          // Order Item
          Row(
            children: [
              // Hotel/Event Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildOrderImage(),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.orderTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${widget.orderData['date'] ?? 'N/A'}',
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
                  fontSize: 18,
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

  Widget _buildPaymentDetailsCard() {
    return Container(
      width: double.infinity,
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
          const Row(
            children: [
              Icon(Icons.payment, color: Color(0xFF0070BA), size: 24),
              SizedBox(width: 12),
              Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildPaymentRow('Payment Method', 'PayPal Account'),
          _buildPaymentRow('Total Amount', widget.totalAmount),
          _buildPaymentRow('Processing Fee', 'Free'),
          const Divider(height: 24),
          _buildPaymentRow('Final Amount', widget.totalAmount, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? const Color(0xFF0070BA) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayPalButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isProcessing ? _pulseAnimation.value : 1.0,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0070BA),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: const Color(0xFF0070BA).withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isProcessing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Processing Payment...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.account_balance_wallet, size: 24),
                        const SizedBox(width: 12),
                        const Text(
                          'Pay with PayPal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.security, color: Colors.green.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Payment',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your payment information is encrypted and secure',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderImage() {
    final orderData = widget.orderData;
    final imageUrl =
        orderData['image'] ?? orderData['cover_url'] ?? orderData['imageUrl'];
    final orderType = orderData['type'] ?? 'unknown';

    // If we have an image URL, display it
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade100,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackIcon(orderType);
        },
      );
    }

    // Fallback to icon if no image URL
    return _buildFallbackIcon(orderType);
  }

  Widget _buildFallbackIcon(String orderType) {
    IconData iconData;
    Color iconColor;

    if (orderType == 'hotel') {
      iconData = Icons.hotel;
      iconColor = const Color(0xFF7F2F3A);
    } else if (orderType == 'event') {
      iconData = Icons.event;
      iconColor = const Color(0xFF0070BA);
    } else {
      iconData = Icons.shopping_bag;
      iconColor = Colors.grey.shade600;
    }

    return Container(
      width: 60,
      height: 60,
      color: Colors.grey.shade100,
      child: Icon(iconData, color: iconColor, size: 30),
    );
  }
}
