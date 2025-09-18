import 'package:flutter/material.dart';
import '../../../../../../shared/shared.dart';

class SectionEventDetails extends StatelessWidget {
  final Map<String, dynamic> event;

  const SectionEventDetails({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50, // مساحة فوق للـ floating container
        ),
        child: Column(
          children: [
            // Event Details Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    event['title']?.toString() ?? 'Event Title',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date and Time
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: AppColors.primary,
                    title: event['date']?.toString() ?? 'Date',
                    subtitle:
                        '${event['day']?.toString() ?? 'Day'}, ${event['time']?.toString() ?? 'Time'}',
                  ),
                  const SizedBox(height: 20),

                  // Location
                  _buildDetailRow(
                    icon: Icons.location_on,
                    iconColor: AppColors.primary,
                    title: event['location']?.toString() ?? 'Location',
                    subtitle: event['country']?.toString() ?? 'Country',
                  ),
                  const SizedBox(height: 20),

                  // Organizer
                  _buildOrganizerRow(
                    organizer: event['organizer']?.toString() ?? 'Organizer',
                    country: event['organizerCountry']?.toString() ?? 'Country',
                  ),
                  const SizedBox(height: 32),

                  // About Event
                  const Text(
                    'About Event',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event['about']?.toString() ?? 'Event description',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
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

  Widget _buildOrganizerRow({
    required String organizer,
    required String country,
  }) {
    return Row(
      children: [
        // Organizer Logo
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.palette, color: Colors.orange, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                organizer,
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
