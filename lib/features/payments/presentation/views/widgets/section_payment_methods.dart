import 'package:flutter/material.dart';

class SectionPaymentMethods extends StatefulWidget {
  final bool isCardSelected;
  final bool isCryptoSelected;
  final Function(bool) onCardSelected;
  final Function(bool) onCryptoSelected;

  const SectionPaymentMethods({
    super.key,
    required this.isCardSelected,
    required this.isCryptoSelected,
    required this.onCardSelected,
    required this.onCryptoSelected,
  });

  @override
  State<SectionPaymentMethods> createState() => _SectionPaymentMethodsState();
}

class _SectionPaymentMethodsState extends State<SectionPaymentMethods>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _cryptoController;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _cryptoScaleAnimation;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cryptoController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _cardScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );

    _cryptoScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _cryptoController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    _cryptoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: const Color(0xFF7F2F3A), size: 24),
              const SizedBox(width: 12),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Card Payment Option
          _buildCardPaymentOption(),
          const SizedBox(height: 16),

          // Crypto Payment Option
          _buildCryptoPaymentOption(),
        ],
      ),
    );
  }

  Widget _buildCardPaymentOption() {
    return GestureDetector(
      onTapDown: (_) => _cardController.forward(),
      onTapUp: (_) {
        _cardController.reverse();
        widget.onCardSelected(true);
      },
      onTapCancel: () => _cardController.reverse(),
      child: AnimatedBuilder(
        animation: _cardScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _cardScaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: widget.isCardSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF7F2F3A).withOpacity(0.1),
                          const Color(0xFF9B4B5A).withOpacity(0.05),
                        ],
                      )
                    : null,
                border: Border.all(
                  color: widget.isCardSelected
                      ? const Color(0xFF7F2F3A)
                      : Colors.grey[300]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: widget.isCardSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF7F2F3A).withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  // Radio button with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.isCardSelected
                          ? const Color(0xFF7F2F3A)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isCardSelected
                            ? const Color(0xFF7F2F3A)
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: widget.isCardSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 16),

                  // Card icons
                  Row(
                    children: [
                      _buildCardIcon('visa'),
                      const SizedBox(width: 8),
                      _buildCardIcon('mastercard'),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Card details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Credit/Debit Card',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Card ending in 3455',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildCardIcon(String type) {
    Color primaryColor;
    Color secondaryColor;
    String text;

    switch (type) {
      case 'visa':
        primaryColor = const Color(0xFF1A1F71);
        secondaryColor = const Color(0xFFF7B600);
        text = 'VISA';
        break;
      case 'mastercard':
        primaryColor = const Color(0xFFEB001B);
        secondaryColor = const Color(0xFFF79E1B);
        text = 'MC';
        break;
      default:
        primaryColor = Colors.grey;
        secondaryColor = Colors.grey[300]!;
        text = 'CARD';
    }

    return Container(
      width: 45,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, secondaryColor],
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildCryptoPaymentOption() {
    return GestureDetector(
      onTapDown: (_) => _cryptoController.forward(),
      onTapUp: (_) {
        _cryptoController.reverse();
        widget.onCryptoSelected(true);
      },
      onTapCancel: () => _cryptoController.reverse(),
      child: AnimatedBuilder(
        animation: _cryptoScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _cryptoScaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: widget.isCryptoSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF7F2F3A).withOpacity(0.1),
                          const Color(0xFF9B4B5A).withOpacity(0.05),
                        ],
                      )
                    : null,
                border: Border.all(
                  color: widget.isCryptoSelected
                      ? const Color(0xFF7F2F3A)
                      : Colors.grey[300]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: widget.isCryptoSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF7F2F3A).withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  // Radio button with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.isCryptoSelected
                          ? const Color(0xFF7F2F3A)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isCryptoSelected
                            ? const Color(0xFF7F2F3A)
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: widget.isCryptoSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 16),

                  // Crypto icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF7931A), Color(0xFFFFD700)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF7931A).withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.currency_bitcoin,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Crypto details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pay With Crypto',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bitcoin, Ethereum & more',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Wallet balance
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7931A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFF7931A).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SR567',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF7931A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: const Color(0xFFF7931A),
                          size: 12,
                        ),
                      ],
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
}
