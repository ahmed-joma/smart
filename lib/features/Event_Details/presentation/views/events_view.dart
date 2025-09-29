import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../shared/shared.dart';
import '../../../../../core/utils/cubits/order_cubit.dart';
import '../../../../../core/utils/models/order_models.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> with WidgetsBindingObserver {
  String _selectedTab = 'CURRENT'; // Default selected tab

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('🔄 App resumed, refreshing orders...');
      // Refresh orders when app comes back to foreground
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.read<OrderCubit>().refreshUserOrders();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Force refresh when page is opened
    print('🔄 Page opened, refreshing orders...');
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        context.read<OrderCubit>().refreshUserOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()..getUserOrders(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Segmented Control
              _buildSegmentedControl(),

              // Main Content
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back Arrow
          GestureDetector(
            onTap: () => context.go('/homeView'),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Title
          const Expanded(
            child: Text(
              'My Orders',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Menu Icon
          const Icon(Icons.more_vert, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }

  void _onTabChanged(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  Widget _buildSegmentedControl() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // CURRENT Tab
          Expanded(
            child: GestureDetector(
              onTap: () => _onTabChanged('CURRENT'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 'CURRENT'
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _selectedTab == 'CURRENT'
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'CURRENT',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _selectedTab == 'CURRENT'
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: _selectedTab == 'CURRENT'
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // PAST Tab
          Expanded(
            child: GestureDetector(
              onTap: () => _onTabChanged('PAST'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 'PAST'
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _selectedTab == 'PAST'
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'PAST',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _selectedTab == 'PAST'
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: _selectedTab == 'PAST'
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (state is UserOrdersLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is UserOrdersError) {
          return _buildErrorState(state.message);
        }

        if (state is UserOrdersSuccess) {
          return _buildOrdersList(state.userOrders);
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildOrdersList(UserOrdersData userOrders) {
    List<dynamic> currentOrders = [];
    List<dynamic> pastOrders = [];

    if (_selectedTab == 'CURRENT') {
      currentOrders.addAll(userOrders.events.upcoming);
      currentOrders.addAll(userOrders.hotels.current);
    } else {
      pastOrders.addAll(userOrders.events.past);
      pastOrders.addAll(userOrders.hotels.past);
    }

    final ordersToShow = _selectedTab == 'CURRENT' ? currentOrders : pastOrders;

    if (ordersToShow.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        print('🔄 Pull-to-refresh triggered');
        context.read<OrderCubit>().refreshUserOrders();
        // Wait for the refresh to complete
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: ordersToShow.length,
        itemBuilder: (context, index) {
          final order = ordersToShow[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(dynamic order) {
    bool isHotel = order is OrderedHotel;

    // Debug: Print order data to understand what we're getting
    print('🏷️ Order Card Debug:');
    print('🏷️ Order Type: ${isHotel ? 'Hotel' : 'Event'}');
    if (isHotel) {
      print('🏷️ Hotel Name: ${order.name}');
      print('🏷️ Hotel City: ${order.city}');
      print('🏷️ Hotel Image: ${order.coverUrl}');
    } else {
      print('🏷️ Event ID: ${order.id}');
      print('🏷️ Event City: ${order.cityName}');
      print('🏷️ Event Image: ${order.imageUrl}');
      print('🏷️ Event Venue: ${order.venue}');
      print('🏷️ Event Formatted Start: ${order.formattedStartAt}');
      print('🏷️ Event Is Favorite: ${order.isFavorite}');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(isHotel ? order.coverUrl : order.imageUrl),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  print('❌ Image load error: $exception');
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHotel ? order.name : order.venue,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  isHotel ? order.city : order.cityName,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isHotel ? 'Hotel' : 'Event',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isHotel ? 'SR ${order.pricePerNight}' : 'View Details',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button
          IconButton(
            onPressed: () => _showOrderDetails(order),
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox(height: 100),

          // Orders Illustration
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Shopping Bag Icon
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.primary,
                    size: 60,
                  ),
                ),

                // Check Icon (overlapping)
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Primary Message
          Text(
            _selectedTab == 'CURRENT' ? 'No Current Orders' : 'No Past Orders',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Secondary Message
          Text(
            _selectedTab == 'CURRENT'
                ? 'You don\'t have any active bookings or upcoming events'
                : 'You haven\'t completed any bookings or events yet',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 20),
            Text(
              'Error Loading Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.read<OrderCubit>().getUserOrders();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(dynamic order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(order is OrderedHotel ? order.name : order.venue),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${order is OrderedHotel ? 'Hotel' : 'Event'}'),
            Text(
              'City: ${order is OrderedHotel ? order.city : order.cityName}',
            ),
            if (order is OrderedHotel) ...[
              Text('Price per night: SR ${order.pricePerNight}'),
              Text('Rating: ${order.rate} stars'),
              Text('Venue: ${order.venue}'),
            ] else ...[
              Text('Venue: ${order.venue}'),
              Text('Date: ${order.formattedStartAt}'),
              Text('Attendees: ${order.attendeesImages.length}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
