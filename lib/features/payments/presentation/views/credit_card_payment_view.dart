import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/cubits/order_cubit.dart';
import '../../../../core/utils/models/order_models.dart';

class CreditCardPaymentView extends StatefulWidget {
  final String totalAmount;
  final String orderTitle;
  final Map<String, dynamic>? orderData;

  const CreditCardPaymentView({
    super.key,
    required this.totalAmount,
    required this.orderTitle,
    this.orderData,
  });

  @override
  State<CreditCardPaymentView> createState() => _CreditCardPaymentViewState();
}

class _CreditCardPaymentViewState extends State<CreditCardPaymentView>
    with TickerProviderStateMixin {
  late AnimationController _cardAnimationController;
  late Animation<double> _cardRotationAnimation;
  late Animation<double> _slideAnimation;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _isCardFlipped = false;
  bool _isProcessing = false;
  String _cardType = '';

  // Validation states
  bool _isCardNumberValid = false;
  bool _isCardHolderValid = false;
  bool _isExpiryValid = false;
  bool _isCvvValid = false;

  // Show validation errors only after user tries to submit
  bool _showValidationErrors = false;

  @override
  void initState() {
    super.initState();
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardRotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _detectCardType(String number) {
    // Remove spaces for card type detection
    final cleanNumber = number.replaceAll(' ', '');

    if (cleanNumber.startsWith('4')) {
      setState(() => _cardType = 'visa');
    } else if (cleanNumber.startsWith('5')) {
      setState(() => _cardType = 'mastercard');
    } else if (cleanNumber.startsWith('3')) {
      setState(() => _cardType = 'amex');
    } else {
      setState(() => _cardType = '');
    }

    // Format the card number
    _formatCardNumber(number);
  }

  void _validateCardNumber(String number) {
    // Remove spaces and check if it's a valid card number
    final cleanNumber = number.replaceAll(' ', '');
    setState(() {
      _isCardNumberValid = cleanNumber.length == 16; // Exactly 16 digits
    });
  }

  void _formatCardNumber(String value) {
    // Remove all non-digits
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Limit to 16 digits
    final limitedDigits = digitsOnly.length > 16
        ? digitsOnly.substring(0, 16)
        : digitsOnly;

    // Format with spaces every 4 digits
    String formatted = '';
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += limitedDigits[i];
    }

    // Update controller if different
    if (_cardNumberController.text != formatted) {
      _cardNumberController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    // Validate the formatted value
    _validateCardNumber(formatted);
  }

  void _validateCardHolder(String name) {
    setState(() {
      _isCardHolderValid = name.trim().length >= 2 && name.trim().contains(' ');
    });
  }

  void _validateExpiryDate(String expiry) {
    if (expiry.length == 4) {
      final month = int.tryParse(expiry.substring(0, 2));
      final year = int.tryParse(expiry.substring(2, 4));

      setState(() {
        _isExpiryValid =
            month != null &&
            year != null &&
            month >= 1 &&
            month <= 12 &&
            year >= 24; // Assuming current year is 2024+
      });
    } else {
      setState(() => _isExpiryValid = false);
    }
  }

  void _validateCvv(String cvv) {
    setState(() {
      _isCvvValid = cvv.length == 3 && RegExp(r'^\d{3}$').hasMatch(cvv);
    });
  }

  void _formatExpiryDate(String value) {
    // Remove all non-digits
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Limit to 4 digits
    final limitedDigits = digitsOnly.length > 4
        ? digitsOnly.substring(0, 4)
        : digitsOnly;

    // Format with "/" after 2 digits
    String formatted = limitedDigits;
    if (limitedDigits.length >= 2) {
      formatted =
          '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2)}';
    }

    // Update controller if different
    if (_expiryController.text != formatted) {
      _expiryController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    // Validate the formatted value
    _validateExpiryDate(limitedDigits);
  }

  bool get _isFormValid {
    return _isCardNumberValid &&
        _isCardHolderValid &&
        _isExpiryValid &&
        _isCvvValid;
  }

  void _processPayment() {
    // Show validation errors when user tries to submit
    setState(() => _showValidationErrors = true);

    // Check if form is valid before processing
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all card details correctly'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

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
              const Text('Payment successful!'),
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
    final orderType = orderData['type']; // 'hotel' or 'event'

    print('🚀 Processing API payment for $orderType');
    print('📦 Order data: $orderData');

    // Create OrderCubit for API integration
    final orderCubit = OrderCubit();

    // Show API processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: orderCubit,
          child: BlocConsumer<OrderCubit, OrderState>(
            listener: (context, state) {
              if (state is OrderSuccess) {
                Navigator.of(dialogContext).pop(); // Close loading dialog
                setState(() => _isProcessing = false);

                if (orderType == 'hotel' && state.orderData.booking != null) {
                  _showHotelBookingSuccess(state.orderData.booking!);
                } else if (orderType == 'event' &&
                    state.orderData.ticket != null) {
                  _showEventTicketSuccess(state.orderData.ticket!);
                } else {
                  _showGenericSuccess();
                }
              } else if (state is OrderError) {
                Navigator.of(dialogContext).pop(); // Close loading dialog
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      state is OrderLoading
                          ? 'Processing your payment...'
                          : 'Initializing payment...',
                    ),
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
      } else {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing hotel booking data')),
        );
      }
    } else if (orderType == 'event') {
      final eventId = orderData['event_id'] as int?;
      final totalPrice = orderData['total_price'] as double?;

      print('🎫 Event ID: $eventId');
      print('💰 Total Price: $totalPrice');

      if (eventId != null && totalPrice != null) {
        print(
          '✅ Calling buyEventTicket with ID: $eventId and price: $totalPrice',
        );
        orderCubit.buyEventTicket(eventId: eventId, totalPrice: totalPrice);
      } else {
        setState(() => _isProcessing = false);
        print(
          '❌ Missing event data - Event ID: $eventId, Total Price: $totalPrice',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Missing event ticket data - Event ID: $eventId, Price: $totalPrice',
            ),
            backgroundColor: Colors.red,
          ),
        );
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
          'Credit Card Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 30 * (1 - _slideAnimation.value)),
            child: Opacity(
              opacity: _slideAnimation.value,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Order Summary Card
                    _buildOrderSummaryCard(),
                    const SizedBox(height: 24),

                    // Credit Card Display
                    _buildCreditCardDisplay(),
                    const SizedBox(height: 32),

                    // Payment Form
                    _buildPaymentForm(),
                    const SizedBox(height: 32),

                    // Pay Button
                    _buildPayButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF7F2F3A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_cart,
              color: Color(0xFF7F2F3A),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
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
                  'Total Amount',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            widget.totalAmount,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7F2F3A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardDisplay() {
    return AnimatedBuilder(
      animation: _cardRotationAnimation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_cardRotationAnimation.value * 3.14159),
          alignment: Alignment.center,
          child: _isCardFlipped ? _buildCardBack() : _buildCardFront(),
        );
      },
    );
  }

  Widget _buildCardFront() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF7F2F3A),
            const Color(0xFF9B4B5A),
            const Color(0xFFB85C6B),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F2F3A).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Credit Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_cardType.isNotEmpty)
                  Image.asset(
                    'assets/images/${_cardType}_logo.png',
                    height: 30,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            _cardType.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7F2F3A),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
            const Spacer(),
            Text(
              _cardNumberController.text.isEmpty
                  ? '**** **** **** ****'
                  : _cardNumberController.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CARD HOLDER',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _cardHolderController.text.isEmpty
                          ? 'YOUR NAME'
                          : _cardHolderController.text.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EXPIRES',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _expiryController.text.isEmpty
                          ? 'MM/YY'
                          : _expiryController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF7F2F3A),
            const Color(0xFF9B4B5A),
            const Color(0xFFB85C6B),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7F2F3A).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(width: double.infinity, height: 40, color: Colors.black),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      _cvvController.text.isEmpty ? 'CVV' : _cvvController.text,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7F2F3A),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (_cardType.isNotEmpty)
                  Image.asset(
                    'assets/images/${_cardType}_logo.png',
                    height: 30,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            _cardType.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7F2F3A),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
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
            'Card Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Card Number
          _buildTextField(
            controller: _cardNumberController,
            label: 'Card Number',
            hint: '1234 5678 9012 3456',
            icon: Icons.credit_card,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(
                19,
              ), // Allow for spaces (16 digits + 3 spaces)
            ],
            onChanged: _detectCardType,
            isValid: _isCardNumberValid,
            errorText: _showValidationErrors && !_isCardNumberValid
                ? 'Enter exactly 16 digits'
                : null,
          ),
          const SizedBox(height: 16),

          // Card Holder Name
          _buildTextField(
            controller: _cardHolderController,
            label: 'Card Holder Name',
            hint: 'John Doe',
            icon: Icons.person,
            textCapitalization: TextCapitalization.words,
            onChanged: _validateCardHolder,
            isValid: _isCardHolderValid,
            errorText: _showValidationErrors && !_isCardHolderValid
                ? 'Enter first and last name'
                : null,
          ),
          const SizedBox(height: 16),

          // Expiry Date and CVV
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _expiryController,
                  label: 'Expiry Date',
                  hint: 'MM/YY',
                  icon: Icons.calendar_today,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                      5,
                    ), // Allow for "/" character
                  ],
                  onChanged: _formatExpiryDate,
                  isValid: _isExpiryValid,
                  errorText: _showValidationErrors && !_isExpiryValid
                      ? 'Enter MM/YY format'
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _cvvController,
                  label: 'CVV',
                  hint: '123',
                  icon: Icons.security,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  onChanged: _validateCvv,
                  isValid: _isCvvValid,
                  errorText: _showValidationErrors && !_isCvvValid
                      ? 'Enter 3-digit CVV'
                      : null,
                  onTap: () {
                    setState(() => _isCardFlipped = true);
                  },
                  onEditingComplete: () {
                    setState(() => _isCardFlipped = false);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization? textCapitalization,
    VoidCallback? onTap,
    VoidCallback? onEditingComplete,
    Function(String)? onChanged,
    bool? isValid,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: Icon(
              icon,
              color: isValid == true
                  ? Colors.green
                  : (_showValidationErrors && isValid == false)
                  ? Colors.red
                  : Colors.grey.shade600,
            ),
            filled: true,
            fillColor: isValid == true
                ? Colors.green.shade50
                : (_showValidationErrors && isValid == false)
                ? Colors.red.shade50
                : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isValid == true
                    ? Colors.green
                    : (_showValidationErrors && isValid == false)
                    ? Colors.red
                    : const Color(0xFF7F2F3A),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
          ),
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          onTap: onTap,
          onEditingComplete: onEditingComplete,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (_isProcessing || !_isFormValid) ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid
              ? const Color(0xFF7F2F3A)
              : Colors.grey.shade400,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
                  Icon(_isFormValid ? Icons.payment : Icons.lock, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _isFormValid
                        ? 'Pay ${widget.totalAmount}'
                        : 'Fill card details to pay',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showHotelBookingSuccess(HotelBooking booking) {
    // Navigate to a success page showing the hotel booking details
    context.go(
      '/bookingSuccess',
      extra: {'type': 'hotel', 'booking': booking.toJson()},
    );
  }

  void _showEventTicketSuccess(EventTicket ticket) {
    // Navigate to a success page showing the event ticket details
    print('🎫 EventTicket Success Data:');
    print('🎫 Ticket ID: ${ticket.ticketId}');
    print('🎫 Event Title: ${ticket.eventTitle}');
    print('🎫 Event Image URL: ${ticket.eventImageUrl}');
    print('🎫 Event City: ${ticket.eventCity}');
    print('🎫 Event Venue: ${ticket.eventVenue}');
    print('🎫 Order Number: ${ticket.orderNumber}');
    print('🎫 User Name: ${ticket.userName}');

    context.go(
      '/ticketSuccess',
      extra: {'type': 'event', 'ticket': ticket.toJson()},
    );
  }

  void _showGenericSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment successful!'),
        backgroundColor: Colors.green,
      ),
    );
    context.pop();
  }
}
