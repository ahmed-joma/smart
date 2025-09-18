import 'package:flutter/material.dart';
import '../../../../../../shared/shared.dart';

class SectionHotelDetails extends StatelessWidget {
  final Map<String, dynamic> hotel;

  const SectionHotelDetails({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50, // مساحة فوق للـ floating container
        ),
        child: Column(
          children: [
            // Hotel Details Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Title
                  Text(
                    hotel['title']?.toString() ?? 'Hotel Name',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Check-in Date and Time
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: AppColors.primary,
                    title: hotel['date']?.toString() ?? 'Check-in Date',
                    subtitle:
                        '${hotel['day']?.toString() ?? 'Day'}, ${hotel['time']?.toString() ?? 'Time'}',
                  ),
                  const SizedBox(height: 20),

                  // Location
                  _buildDetailRow(
                    icon: Icons.location_on,
                    iconColor: AppColors.primary,
                    title: hotel['location']?.toString() ?? 'Location',
                    subtitle: hotel['country']?.toString() ?? 'Country',
                  ),
                  const SizedBox(height: 20),

                  // Hotel Chain
                  _buildHotelChainRow(
                    chain: hotel['organizer']?.toString() ?? 'Hotel Management',
                    country: hotel['organizerCountry']?.toString() ?? 'KSA',
                  ),
                  const SizedBox(height: 32),

                  // Hotel Services (if available)
                  if (hotel['services'] != null &&
                      (hotel['services'] as List).isNotEmpty) ...[
                    const Text(
                      'Hotel Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (hotel['services'] as List<String>).map((
                        service,
                      ) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                service,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // About Hotel
                  const Text(
                    'About Hotel',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hotel['about']?.toString() ?? 'No description available',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0x337F2F3A), // #7F2F3A - 80% شفافية
            borderRadius: BorderRadius.circular(15.31),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHotelChainRow({required String chain, required String country}) {
    return Row(
      children: [
        // Hotel Chain Logo
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.hotel, color: Colors.blue, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chain,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Text(
                country,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        // Follow Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 230, 231, 239),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Text(
            'Follow',
            style: TextStyle(
              color: Color(0xFF7F2F3A),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
