import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapStyleButton extends StatelessWidget {
  final String currentStyle;
  final Function(String) onStyleChanged;

  const MapStyleButton({
    super.key,
    required this.currentStyle,
    required this.onStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.layers, color: Color(0xFF7F2F3A)),
        onPressed: () {
          _showStyleDialog(context);
        },
      ),
    );
  }

  void _showStyleDialog(BuildContext context) {
    final List<Map<String, dynamic>> styles = [
      {
        'id': MapboxStyles.STANDARD,
        'label': 'Standard',
        'icon': Icons.map,
        'description': 'Default map style',
      },
      {
        'id': MapboxStyles.SATELLITE,
        'label': 'Satellite',
        'icon': Icons.satellite_alt,
        'description': 'Satellite imagery',
      },
      {
        'id': MapboxStyles.SATELLITE_STREETS,
        'label': 'Satellite Streets',
        'icon': Icons.terrain,
        'description': 'Satellite with streets',
      },
      {
        'id': MapboxStyles.DARK,
        'label': 'Dark',
        'icon': Icons.dark_mode,
        'description': 'Dark theme',
      },
      {
        'id': MapboxStyles.LIGHT,
        'label': 'Light',
        'icon': Icons.light_mode,
        'description': 'Light theme',
      },
      {
        'id': MapboxStyles.OUTDOORS,
        'label': 'Outdoors',
        'icon': Icons.hiking,
        'description': 'Outdoor activities',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Map Style',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Style Options
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: styles.length,
                  itemBuilder: (context, index) {
                    final style = styles[index];
                    final isSelected = currentStyle == style['id'];

                    return GestureDetector(
                      onTap: () {
                        onStyleChanged(style['id']);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF7F2F3A).withOpacity(0.1)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF7F2F3A)
                                : Colors.grey.shade200,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF7F2F3A)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                style['icon'],
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    style['label'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? const Color(0xFF7F2F3A)
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    style['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF7F2F3A),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }
}
