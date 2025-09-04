import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/index.dart';

class HotelBookingView extends StatefulWidget {
  final Map<String, dynamic>? hotelData;

  const HotelBookingView({super.key, this.hotelData});

  @override
  State<HotelBookingView> createState() => _HotelBookingViewState();
}

class _HotelBookingViewState extends State<HotelBookingView> {
  int _selectedRooms = 1;
  int _selectedBeds = 1;
  int _selectedGuests = 2;
  int _selectedNights = 1;
  double _basePrice = 200.7;
  double _totalPrice = 200.7;

  @override
  void initState() {
    super.initState();
    if (widget.hotelData != null && widget.hotelData!['price'] != null) {
      String priceStr = widget.hotelData!['price'].toString();
      priceStr = priceStr.replaceAll('SR', '').trim();
      _basePrice = double.tryParse(priceStr) ?? 200.7;
    }
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    _totalPrice = _basePrice * _selectedRooms * _selectedBeds * _selectedNights;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Book Hotel',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Info Card
                  SectionHotelInfoCard(hotelData: widget.hotelData),
                  const SizedBox(height: 24),

                  // Room Selection
                  SectionBookingSelection(
                    title: "Select Rooms",
                    label: "Number of Rooms",
                    value: _selectedRooms,
                    onAdd: () {
                      setState(() {
                        _selectedRooms++;
                        _calculateTotalPrice();
                      });
                    },
                    onRemove: () {
                      if (_selectedRooms > 1) {
                        setState(() {
                          _selectedRooms--;
                          _calculateTotalPrice();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bed Selection
                  SectionBookingSelection(
                    title: "Select Beds",
                    label: "Beds per Room",
                    value: _selectedBeds,
                    onAdd: () {
                      setState(() {
                        _selectedBeds++;
                        _calculateTotalPrice();
                      });
                    },
                    onRemove: () {
                      if (_selectedBeds > 1) {
                        setState(() {
                          _selectedBeds--;
                          _calculateTotalPrice();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Guests Selection
                  SectionBookingSelection(
                    title: "Select Guests",
                    label: "Number of Guests",
                    value: _selectedGuests,
                    onAdd: () {
                      setState(() {
                        _selectedGuests++;
                        _calculateTotalPrice();
                      });
                    },
                    onRemove: () {
                      if (_selectedGuests > 1) {
                        setState(() {
                          _selectedGuests--;
                          _calculateTotalPrice();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Nights Selection
                  SectionBookingSelection(
                    title: "Select Nights",
                    label: "Number of Nights",
                    value: _selectedNights,
                    onAdd: () {
                      setState(() {
                        _selectedNights++;
                        _calculateTotalPrice();
                      });
                    },
                    onRemove: () {
                      if (_selectedNights > 1) {
                        setState(() {
                          _selectedNights--;
                          _calculateTotalPrice();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Price Summary
                  SectionPriceSummary(
                    basePrice: _basePrice,
                    selectedRooms: _selectedRooms,
                    selectedBeds: _selectedBeds,
                    selectedGuests: _selectedGuests,
                    selectedNights: _selectedNights,
                    totalPrice: _totalPrice,
                  ),
                ],
              ),
            ),
          ),

          // Book Button
          SectionBookHotelButton(
            totalPrice: _totalPrice,
            hotelData: widget.hotelData,
            selectedRooms: _selectedRooms,
            selectedBeds: _selectedBeds,
            selectedGuests: _selectedGuests,
            selectedNights: _selectedNights,
          ),
        ],
      ),
    );
  }
}
