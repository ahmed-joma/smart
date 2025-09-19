import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../shared/shared.dart';
import '../../../../../../core/utils/cubits/order_cubit.dart';
import '../../../../../../core/utils/models/order_models.dart';
import '../../../../../../core/utils/service_locator.dart';

class SectionBookHotelButton extends StatelessWidget {
  final double totalPrice;
  final Map<String, dynamic>? hotelData;
  final int selectedRooms;
  final int selectedBeds;
  final int selectedGuests;
  final int selectedNights;

  const SectionBookHotelButton({
    super.key,
    required this.totalPrice,
    required this.hotelData,
    required this.selectedRooms,
    required this.selectedBeds,
    required this.selectedGuests,
    required this.selectedNights,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _showHotelBookingConfirmation(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7F2F3A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              'BOOK HOTEL SR ${totalPrice.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  void _showHotelBookingConfirmation(BuildContext context) {
    final totalWithTax = totalPrice + 18.0;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.hotel, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'Confirm Hotel Booking',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotelData?['title'] ?? 'Four Points by Sheraton',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      hotelData?['location'] ?? 'Jeddah Corniche',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Booking Details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Rooms:', '$selectedRooms'),
                    _buildDetailRow('Beds per Room:', '$selectedBeds'),
                    _buildDetailRow('Guests:', '$selectedGuests'),
                    _buildDetailRow('Nights:', '$selectedNights'),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              // Price Breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Hotel Price:'),
                  Text(
                    'SR ${totalPrice.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tax & Fees:'),
                  Text(
                    'SR 18.0',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'SR ${totalWithTax.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _proceedToPayment(context, totalWithTax);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Confirm & Pay'),
            ),
          ],
        );
      },
    );
  }

  // Get hotel ID from hotelData
  int? _getHotelId() {
    if (hotelData == null) return null;

    if (hotelData!['id'] is int) {
      return hotelData!['id'] as int;
    } else if (hotelData!['id'] is String) {
      return int.tryParse(hotelData!['id']);
    }
    return null;
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _bookHotelWithAPI(BuildContext context, double totalWithTax) {
    final hotelId = _getHotelId();

    if (hotelId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hotel ID not found. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print(
      '🏨 Booking hotel ID: $hotelId for SR${totalWithTax.toStringAsFixed(1)}',
    );

    // Create OrderCubit instance
    print('🔧 Creating OrderCubit instance...');
    final orderCubit = OrderCubit();
    print('✅ OrderCubit created successfully');

    // Show loading dialog with the OrderCubit
    print('📱 Showing loading dialog...');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext loadingContext) {
        return BlocProvider.value(
          value: orderCubit,
          child: BlocConsumer<OrderCubit, OrderState>(
            listener: (context, state) {
              print('🔄 OrderCubit state changed: ${state.runtimeType}');

              if (state is OrderSuccess) {
                print('✅ OrderSuccess received!');
                Navigator.of(loadingContext).pop(); // Close loading dialog

                if (state.orderData.booking != null) {
                  print(
                    '✅ Hotel booking successful: ${state.orderData.booking!.orderNumber}',
                  );
                  _showBookingSuccess(context, state.orderData.booking!);
                } else {
                  print('⚠️ No booking data in response');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Booking successful but no booking data received',
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } else if (state is OrderError) {
                print('❌ OrderError received: ${state.message}');
                Navigator.of(loadingContext).pop(); // Close loading dialog

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking failed: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              print('🏗️ Building dialog for state: ${state.runtimeType}');

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      state is OrderLoading
                          ? 'Processing your booking...'
                          : 'Initializing booking...',
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    // Start booking process immediately after showing dialog
    print('🚀 Starting booking process...');
    orderCubit.bookHotel(hotelId: hotelId, totalPrice: totalWithTax);
  }

  void _showBookingSuccess(BuildContext context, HotelBooking booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext successContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              const Text('Booking Confirmed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.hotelName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text('Order Number: ${booking.orderNumber}'),
              Text('Check-in: ${booking.bookingCheckIn}'),
              Text('Check-out: ${booking.bookingCheckOut}'),
              Text('Total: SR ${booking.orderPrice}'),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: booking.barcodeImage.isNotEmpty
                    ? Image.network(
                        booking.barcodeImage,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text('Barcode will be sent via email'),
                          );
                        },
                      )
                    : const Center(
                        child: Text('Barcode will be sent via email'),
                      ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(successContext).pop();
                // Navigate back to hotel details or home
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _proceedToPayment(BuildContext context, double totalWithTax) {
    final hotelId = _getHotelId();

    if (hotelId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hotel ID not found. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to payment page with hotel booking data
    final orderData = {
      'title': hotelData?['title'] ?? 'Four Points by Sheraton',
      'date': hotelData?['date'] ?? 'Nov 15 2025',
      'location':
          '${hotelData?['location'] ?? 'Jeddah Corniche'}, ${hotelData?['country'] ?? 'KSA'}',
      'price': 'SR ${totalPrice.toStringAsFixed(1)}',
      'tax': 'SR 18',
      'total': 'SR ${totalWithTax.toStringAsFixed(1)}',
      'type': 'hotel',
      'image': hotelData?['image'] ?? 'assets/images/hotel.svg',
      'rooms': selectedRooms,
      'beds': selectedBeds,
      'guests': selectedGuests,
      'nights': selectedNights,
      // Add API integration data
      'hotel_id': hotelId,
      'total_price': totalWithTax,
      'api_integration': true, // Flag to indicate API integration
    };

    context.push('/orderSummary', extra: orderData);
  }
}
