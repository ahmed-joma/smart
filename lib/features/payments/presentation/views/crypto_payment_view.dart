import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CryptoPaymentView extends StatefulWidget {
  final String totalAmount;
  final String orderTitle;

  const CryptoPaymentView({
    super.key,
    required this.totalAmount,
    required this.orderTitle,
  });

  @override
  State<CryptoPaymentView> createState() => _CryptoPaymentViewState();
}

class _CryptoPaymentViewState extends State<CryptoPaymentView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  final TextEditingController _walletController = TextEditingController();
  String _selectedCrypto = 'bitcoin';
  bool _isProcessing = false;
  bool _isWalletConnected = false;

  final Map<String, Map<String, dynamic>> _cryptocurrencies = {
    'bitcoin': {
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'color': const Color(0xFFF7931A),
      'icon': '₿',
      'exchangeRate': 45000.0,
    },
    'ethereum': {
      'name': 'Ethereum',
      'symbol': 'ETH',
      'color': const Color(0xFF627EEA),
      'icon': 'Ξ',
      'exchangeRate': 2800.0,
    },
    'cardano': {
      'name': 'Cardano',
      'symbol': 'ADA',
      'color': const Color(0xFF0033AD),
      'icon': '₳',
      'exchangeRate': 0.45,
    },
    'solana': {
      'name': 'Solana',
      'symbol': 'SOL',
      'color': const Color(0xFF00FFA3),
      'icon': '◎',
      'exchangeRate': 95.0,
    },
  };

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
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  void _connectWallet() {
    if (_walletController.text.isNotEmpty) {
      setState(() => _isWalletConnected = true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Text('Wallet connected successfully!'),
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
    }
  }

  void _processPayment() {
    setState(() => _isProcessing = true);

    // محاكاة عملية الدفع
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

  double _getCryptoAmount() {
    final usdAmount =
        double.tryParse(widget.totalAmount.replaceAll('SR ', '')) ?? 0.0;
    final exchangeRate =
        _cryptocurrencies[_selectedCrypto]!['exchangeRate'] as double;
    return usdAmount / exchangeRate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Crypto Payment',
          style: TextStyle(
            color: Colors.white,
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
                    // Crypto Header
                    _buildCryptoHeader(),
                    const SizedBox(height: 24),

                    // Order Summary
                    _buildOrderSummary(),
                    const SizedBox(height: 24),

                    // Crypto Selection
                    _buildCryptoSelection(),
                    const SizedBox(height: 24),

                    // Wallet Connection
                    _isWalletConnected
                        ? _buildPaymentSection()
                        : _buildWalletConnection(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCryptoHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1A1F35), const Color(0xFF2D3748)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A5568), width: 1),
      ),
      child: Column(
        children: [
          // Animated Crypto Icon
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _cryptocurrencies[_selectedCrypto]!['color'],
                        _cryptocurrencies[_selectedCrypto]!['color']
                            .withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: _cryptocurrencies[_selectedCrypto]!['color']
                            .withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _cryptocurrencies[_selectedCrypto]!['icon'],
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Pay with ${_cryptocurrencies[_selectedCrypto]!['name']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fast, secure, and decentralized',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A5568), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _cryptocurrencies[_selectedCrypto]!['color']
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: _cryptocurrencies[_selectedCrypto]!['color'],
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_cryptocurrencies[_selectedCrypto]!['name']} Payment',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.totalAmount,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${_getCryptoAmount().toStringAsFixed(6)} ${_cryptocurrencies[_selectedCrypto]!['symbol']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _cryptocurrencies[_selectedCrypto]!['color'],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A5568), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Cryptocurrency',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _cryptocurrencies.length,
            itemBuilder: (context, index) {
              final cryptoKey = _cryptocurrencies.keys.elementAt(index);
              final crypto = _cryptocurrencies[cryptoKey]!;
              final isSelected = _selectedCrypto == cryptoKey;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCrypto = cryptoKey);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? crypto['color'].withOpacity(0.2)
                        : const Color(0xFF2D3748),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? crypto['color']
                          : const Color(0xFF4A5568),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        crypto['icon'],
                        style: TextStyle(
                          fontSize: 32,
                          color: crypto['color'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        crypto['name'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        crypto['symbol'],
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWalletConnection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A5568), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connect Wallet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Wallet Address Field
          _buildTextField(
            controller: _walletController,
            label: 'Wallet Address',
            hint: '0x1234...5678',
            icon: Icons.account_balance_wallet,
          ),
          const SizedBox(height: 24),

          // Connect Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _connectWallet,
              style: ElevatedButton.styleFrom(
                backgroundColor: _cryptocurrencies[_selectedCrypto]!['color'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.link, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Connect Wallet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Demo Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D3748),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF4A5568)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade400, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Demo Wallet',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Address: 0x1234567890abcdef\nUse any address to test',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A5568), width: 1),
      ),
      child: Column(
        children: [
          // Wallet Info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _cryptocurrencies[_selectedCrypto]!['color']
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: _cryptocurrencies[_selectedCrypto]!['color'],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _walletController.text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Connected Wallet',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
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
                backgroundColor: _cryptocurrencies[_selectedCrypto]!['color'],
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
                        Text(
                          _cryptocurrencies[_selectedCrypto]!['icon'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Pay ${_getCryptoAmount().toStringAsFixed(6)} ${_cryptocurrencies[_selectedCrypto]!['symbol']}',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: Icon(icon, color: Colors.grey.shade400),
            filled: true,
            fillColor: const Color(0xFF2D3748),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _cryptocurrencies[_selectedCrypto]!['color'],
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
