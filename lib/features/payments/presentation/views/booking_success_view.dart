import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/shared.dart';

class BookingSuccessView extends StatelessWidget {
  final Map<String, dynamic>? successData;

  const BookingSuccessView({super.key, this.successData});

  @override
  Widget build(BuildContext context) {
    print('🎫 BookingSuccessView - Success Data: $successData');

    final type = successData?['type'] ?? 'unknown';
    final bookingData = successData?['booking'] as Map<String, dynamic>?;
    final ticketData = successData?['ticket'] as Map<String, dynamic>?;

    print('🎫 Type: $type');
    print('🎫 Booking Data: $bookingData');
    print('🎫 Ticket Data: $ticketData');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Success Icon with Animation Effect
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 70,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              // Success Title
              Text(
                type == 'hotel' ? 'Booking Confirmed!' : 'Ticket Purchased!',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                type == 'hotel'
                    ? 'Your hotel reservation has been confirmed'
                    : 'Your event ticket has been purchased successfully',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Booking/Ticket Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: type == 'hotel'
                    ? _buildHotelBookingDetails(bookingData)
                    : _buildEventTicketDetails(ticketData),
              ),

              const SizedBox(height: 40),

              // Go Home Button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => context.go('/homeView'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.home_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Go to Home',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelBookingDetails(Map<String, dynamic>? booking) {
    if (booking == null) {
      return const Center(
        child: Text(
          'No booking details available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hotel Image
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade100,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: booking['hotel_cover_url']?.toString().isNotEmpty == true
                ? Image.network(
                    booking['hotel_cover_url'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.1),
                              AppColors.primary.withOpacity(0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.hotel,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.primary.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.hotel,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 24),

        // Hotel Name with Icon
        Row(
          children: [
            Icon(Icons.hotel, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                booking['hotel_name'] ?? 'Unknown Hotel',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Details in Cards
        _buildDetailCard(
          icon: Icons.confirmation_number,
          label: 'Order Number',
          value: booking['order_number']?.toString() ?? 'N/A',
          isHighlight: true,
        ),

        _buildDetailCard(
          icon: Icons.tag,
          label: 'Booking ID',
          value: '#${booking['id']?.toString() ?? 'N/A'}',
        ),

        _buildDetailCard(
          icon: Icons.person,
          label: 'Guest Name',
          value: booking['user_name']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.location_city,
          label: 'Hotel City',
          value: booking['hotel_city']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.location_on,
          label: 'Hotel Address',
          value:
              booking['hotel_venue']?.toString().replaceAll('\n', ', ') ??
              'N/A',
        ),

        _buildDetailCard(
          icon: Icons.login,
          label: 'Check-in',
          value: booking['booking_check_in']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.logout,
          label: 'Check-out',
          value: booking['booking_check_out']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.calendar_today,
          label: 'Booking Date',
          value:
              '${booking['order_created_at']?.toString() ?? 'N/A'} at ${booking['time']?.toString() ?? 'N/A'}',
        ),

        _buildDetailCard(
          icon: Icons.payment,
          label: 'Total Price',
          value: 'SR ${booking['order_price'] ?? '0'}',
          isPrice: true,
        ),

        const SizedBox(height: 24),

        // Barcode Section
        if (booking['barcode_image']?.toString().isNotEmpty == true) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Your Booking Barcode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Image.network(
                    booking['barcode_image'],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'Barcode will be sent via email',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Present this barcode at hotel check-in',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEventTicketDetails(Map<String, dynamic>? ticket) {
    print('🎫 Building Event Ticket Details:');
    print('🎫 Ticket data: $ticket');

    if (ticket == null) {
      print('❌ No ticket data available');
      return const Center(
        child: Text(
          'No ticket details available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    print('🎫 Building Column widget with ${ticket.length} ticket fields');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event Image
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade100,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Builder(
              builder: (context) {
                final imageUrl = ticket['event_image_url']?.toString();
                print('🎫 Event Image URL: "$imageUrl"');
                print(
                  '🎫 Image URL is not empty: ${imageUrl?.isNotEmpty == true}',
                );

                return imageUrl?.isNotEmpty == true
                    ? Builder(
                        builder: (context) {
                          print(
                            '🎫 Building Image.network widget with URL: "$imageUrl"',
                          );
                          return Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                print('✅ Image loaded successfully');
                                return child;
                              }
                              print(
                                '🔄 Image loading... ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes}',
                              );
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.1),
                                      AppColors.primary.withOpacity(0.2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('❌ Image loading error: $error');
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withOpacity(0.1),
                                      AppColors.primary.withOpacity(0.2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Icon(
                                  Icons.event,
                                  size: 60,
                                  color: AppColors.primary,
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Builder(
                        builder: (context) {
                          print(
                            '🎫 Building fallback Container (no image URL)',
                          );
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.1),
                                  AppColors.primary.withOpacity(0.2),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Icon(
                              Icons.event,
                              size: 60,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Event Name with Icon
        Row(
          children: [
            Icon(Icons.event, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Builder(
                builder: (context) {
                  final title = ticket['event_title'] ?? 'Unknown Event';
                  print('🎫 Building Text Widget with title: "$title"');
                  return Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
          ],
        ),

        // Debug: Print the actual title being displayed
        Builder(
          builder: (context) {
            final title = ticket['event_title'] ?? 'Unknown Event';
            print('🎫 Displaying Event Title: "$title"');
            return const SizedBox.shrink();
          },
        ),

        const SizedBox(height: 20),

        // Details in Cards
        _buildDetailCard(
          icon: Icons.confirmation_number,
          label: 'Order Number',
          value: ticket['order_number']?.toString() ?? 'N/A',
          isHighlight: true,
        ),

        _buildDetailCard(
          icon: Icons.tag,
          label: 'Ticket ID',
          value: '#${ticket['ticket_id']?.toString() ?? 'N/A'}',
        ),

        _buildDetailCard(
          icon: Icons.person,
          label: 'Guest Name',
          value: ticket['user_name']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.location_city,
          label: 'Event City',
          value: ticket['event_city']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.location_on,
          label: 'Event Venue',
          value: ticket['event_venue']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.schedule,
          label: 'Event Start',
          value: ticket['event_start_at']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.schedule_outlined,
          label: 'Event End',
          value: ticket['event_end_at']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.door_front_door,
          label: 'Gate',
          value: ticket['gate']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.chair,
          label: 'Seat',
          value: ticket['seat']?.toString() ?? 'N/A',
        ),

        _buildDetailCard(
          icon: Icons.calendar_today,
          label: 'Purchase Date',
          value:
              '${ticket['order_created_at']?.toString() ?? 'N/A'} at ${ticket['time']?.toString() ?? 'N/A'}',
        ),

        _buildDetailCard(
          icon: Icons.payment,
          label: 'Total Price',
          value: 'SR ${ticket['order_price'] ?? '0'}',
          isPrice: true,
        ),

        _buildDetailCard(
          icon: Icons.qr_code_scanner,
          label: 'Barcode Number',
          value: ticket['barcode_number']?.toString() ?? 'N/A',
        ),

        const SizedBox(height: 24),

        // Barcode Section
        if (ticket['barcode_image']?.toString().isNotEmpty == true) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Your Event Ticket',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Image.network(
                    ticket['barcode_image'],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'Barcode will be sent via email',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Scan your barcode at the entry gate.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
    bool isPrice = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.primary.withOpacity(0.05)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight
              ? AppColors.primary.withOpacity(0.2)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHighlight
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isHighlight ? AppColors.primary : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isPrice ? AppColors.primary : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
