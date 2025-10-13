import 'package:flutter/material.dart';
import '../../../data/services/mapbox_geocoding_service.dart';

class MapSearchBar extends StatefulWidget {
  final Function(MapboxPlace) onPlaceSelected;

  const MapSearchBar({super.key, required this.onPlaceSelected});

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final MapboxGeocodingService _geocodingService = MapboxGeocodingService();
  bool _isSearching = false;
  List<MapboxPlace> _searchResults = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Add delay for better UX (debounce)
    await Future.delayed(const Duration(milliseconds: 500));

    if (_searchController.text == query) {
      final results = await _geocodingService.searchPlaces(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    }
  }

  void _onPlaceSelected(MapboxPlace place) {
    _searchController.text = place.placeName;
    _focusNode.unfocus();
    setState(() {
      _searchResults = [];
    });
    widget.onPlaceSelected(place);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search Bar
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.search, color: Colors.grey.shade600, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search cities, hotels, events...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              if (_isSearching)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade600),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults = [];
                    });
                  },
                ),
              const SizedBox(width: 8),
            ],
          ),
        ),

        // Search Results
        if (_searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final place = _searchResults[index];
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7F2F3A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xFF7F2F3A),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    place.text ?? place.placeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    place.placeName,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _onPlaceSelected(place),
                );
              },
            ),
          ),
      ],
    );
  }
}
