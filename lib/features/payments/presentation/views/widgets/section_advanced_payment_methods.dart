import 'package:flutter/material.dart';

class SectionAdvancedPaymentMethods extends StatefulWidget {
  final String selectedMethod;
  final Function(String) onMethodSelected;

  const SectionAdvancedPaymentMethods({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  State<SectionAdvancedPaymentMethods> createState() =>
      _SectionAdvancedPaymentMethodsState();
}

class _SectionAdvancedPaymentMethodsState
    extends State<SectionAdvancedPaymentMethods>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _expandController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _expandAnimation;

  bool _showAdditionalMethods = false;

  final List<Map<String, dynamic>> _additionalPaymentMethods = [
    {
      'id': 'card',
      'name': 'Credit Card',
      'icon': Icons.credit_card,
      'color': const Color(0xFF7F2F3A),
      'description': 'Visa, Mastercard, American Express',
    },
    {
      'id': 'apple_pay',
      'name': 'Apple Pay',
      'icon': Icons.apple,
      'color': Colors.black,
      'description': 'Fast and secure',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _expandController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_animationController, _expandController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _slideAnimation.value)),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
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
                          color: const Color(0xFF7F2F3A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.payment,
                          color: Color(0xFF7F2F3A),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Payment Methods',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // PayPal as Primary Payment Method
                  _buildPayPalCard(),

                  const SizedBox(height: 16),

                  // More Payment Options Button
                  _buildMoreOptionsButton(),

                  // Additional Payment Methods (Collapsible)
                  SizeTransition(
                    sizeFactor: _expandAnimation,
                    child: FadeTransition(
                      opacity: _expandAnimation,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildPaymentMethodCard(
                                  _additionalPaymentMethods[0],
                                  widget.selectedMethod ==
                                      _additionalPaymentMethods[0]['id'],
                                  0,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildPaymentMethodCard(
                                  _additionalPaymentMethods[1],
                                  widget.selectedMethod ==
                                      _additionalPaymentMethods[1]['id'],
                                  1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Security Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Colors.green.shade700,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'All payments are secured with SSL encryption',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPayPalCard() {
    final isSelected = widget.selectedMethod == 'paypal';

    return GestureDetector(
      onTap: () {
        widget.onMethodSelected('paypal');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0070BA), // PayPal Blue
                    const Color(0xFF009CDE), // PayPal Light Blue
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.grey.shade50],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0070BA).withOpacity(0.3)
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF0070BA).withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: isSelected ? 2 : 1,
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // PayPal Logo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFF0070BA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withOpacity(0.3)
                      : const Color(0xFF0070BA).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: isSelected ? Colors.white : const Color(0xFF0070BA),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PayPal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.black87,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pay with your PayPal account',
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Selection Indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Color(0xFF0070BA), size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOptionsButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showAdditionalMethods = !_showAdditionalMethods;
          if (_showAdditionalMethods) {
            _expandController.forward();
          } else {
            _expandController.reverse();
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _showAdditionalMethods
                  ? 'Hide other options'
                  : 'More payment options',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: _showAdditionalMethods ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    Map<String, dynamic> method,
    bool isSelected,
    int index,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () {
          widget.onMethodSelected(method['id']);

          // تأثير النقر
          _animationController.reset();
          _animationController.forward();
        },
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [method['color'], method['color'].withOpacity(0.8)],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? method['color'].withOpacity(0.3)
                  : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? method['color'].withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                spreadRadius: isSelected ? 2 : 1,
                blurRadius: isSelected ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with enhanced design
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : method['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withOpacity(0.3)
                          : method['color'].withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    method['icon'],
                    color: isSelected ? Colors.white : method['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),

                // Name with better typography
                Text(
                  method['name'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : Colors.black87,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 3),

                // Description with improved styling
                Flexible(
                  child: Text(
                    method['description'],
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
