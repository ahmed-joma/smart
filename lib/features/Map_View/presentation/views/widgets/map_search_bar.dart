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
  String _selectedSearchType = 'all'; // نوع البحث المحدد

  // الأماكن المميزة في الرياض (Priority Places)
  // هذه الأسماء مؤقتة - سيتم تحديثها بالأسماء الرسمية من Mapbox
  final List<Map<String, dynamic>> _featuredPlaces = [
    {
      'name': 'JAX District', // الاسم الرسمي لواجهة روشن في Mapbox
      'nameAr': 'جاكس ديستركت',
      'searchTerms': ['JAX', 'Roshan', 'روشن', 'واجهة'], // مصطلحات البحث
      'lat': 24.8153,
      'lng': 46.6346,
      'description':
          'A modern area in Riyadh known for its beautiful architecture, restaurants, and art spaces. It\'s a new destination for culture and entertainment.',
    },
    {
      'name': 'Diriyah', // الاسم الرسمي
      'nameAr': 'الدرعية',
      'searchTerms': ['Diriyah', 'الدرعية', 'Ad Diriyah'],
      'lat': 24.7324,
      'lng': 46.5749,
      'description':
          'A historic city and UNESCO World Heritage site. It\'s famous for its traditional Najdi architecture and the story of Saudi Arabia\'s beginnings.',
    },
    {
      'name': 'Bujairi Terrace', // الاسم الرسمي
      'nameAr': 'حي البجيري',
      'searchTerms': ['Bujairi', 'البجيري', 'Al Bujairi'],
      'lat': 24.7331,
      'lng': 46.5771,
      'description':
          'Located in Diriyah, it\'s a charming area with cafes, restaurants, and a stunning view of At-Turaif. Perfect for dining and walking.',
    },
    {
      'name': 'King Abdullah Financial District', // الاسم الرسمي
      'nameAr': 'مركز الملك عبدالله المالي',
      'searchTerms': ['KAFD', 'Financial District', 'المالي'],
      'lat': 24.7706,
      'lng': 46.6384,
      'description':
          'A modern business area with skyscrapers, luxury hotels, and fine dining. It\'s one of the most futuristic parts of Riyadh.',
    },
    {
      'name': 'Riyadh Boulevard', // الاسم الرسمي
      'nameAr': 'بوليفارد الرياض',
      'searchTerms': ['Boulevard', 'بوليفارد', 'Boulevard City'],
      'lat': 24.7519,
      'lng': 46.6289,
      'description':
          'A large entertainment zone filled with restaurants, shows, shops, and seasonal events. It\'s a top spot for tourists and families.',
    },
    {
      'name': 'Boulevard Riyadh City', // الاسم الرسمي
      'nameAr': 'بوليفارد رياض سيتي',
      'searchTerms': ['Boulevard World', 'بوليفارد العالم', 'World'],
      'lat': 24.8073,
      'lng': 46.6738,
      'description':
          'A theme park style area with international pavilions, games, and global food bringing cultures from around the world to Riyadh.',
    },
    {
      'name': 'Souq Al Zal', // الاسم الرسمي للمعيقلية
      'nameAr': 'سوق الزل',
      'searchTerms': ['Muaiqelia', 'المعيقلية', 'Zal', 'الزل'],
      'lat': 24.6340,
      'lng': 46.7146,
      'description':
          'A traditional market in the old part of Riyadh, known for its perfumes, clothes, and gifts great for local shopping and heritage vibes.',
    },
  ];

  // أنواع البحث المتاحة مع تركيز على السعودية
  final Map<String, String> _searchTypes = {
    'all': 'All Places',
    'saudi': 'Saudi Arabia',
    'cities': 'Cities',
    'landmarks': 'Landmarks',
  };

  // قائمة بالمدن السعودية الشهيرة للبحث السريع
  final List<String> _saudiCities = [
    'الرياض',
    'Riyadh',
    'جدة',
    'Jeddah',
    'مكة المكرمة',
    'Mecca',
    'المدينة المنورة',
    'Medina',
    'الدمام',
    'Dammam',
    'الخبر',
    'Khobar',
    'الظهران',
    'Dhahran',
    'الطائف',
    'Taif',
    'بريدة',
    'Buraydah',
    'تبوك',
    'Tabuk',
    'حائل',
    'Hail',
    'أبها',
    'Abha',
    'نجران',
    'Najran',
    'جازان',
    'Jazan',
    'سكاكا',
    'Sakaka',
    'عرعر',
    'Arar',
  ];

  // قائمة بالمعالم السعودية الشهيرة
  final List<String> _saudiLandmarks = [
    'الكعبة المشرفة',
    'Kaaba',
    'المسجد الحرام',
    'Grand Mosque',
    'المسجد النبوي',
    'Prophet Mosque',
    'برج المملكة',
    'Kingdom Tower',
    'برج الفيصلية',
    'Faisaliah Tower',
    'قصر المصمك',
    'Masmak Fortress',
    'منطقة البلد',
    'Al Balad',
    'وادي الرمة',
    'Wadi Al Rumah',
    'جبل النور',
    'Mount Noor',
    'غار حراء',
    'Hira Cave',
    'جبل أحد',
    'Mount Uhud',
    'مدائن صالح',
    'Mada\'in Saleh',
    'قلعة تبوك',
    'Tabuk Castle',
    'قصر خزام',
    'Khuzam Palace',
    'متحف الرياض',
    'Riyadh Museum',
    'حديقة الملك عبدالله',
    'King Abdullah Park',
  ];

  @override
  void initState() {
    super.initState();
    // إضافة اقتراحات المدن السعودية عند بدء الكتابة
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
    await Future.delayed(const Duration(milliseconds: 300));

    if (_searchController.text == query) {
      List<MapboxPlace> results = [];

      // إضافة الأماكن المميزة أولاً إذا كانت مطابقة للبحث
      final matchingFeaturedPlaces = _featuredPlaces.where((place) {
        final queryLower = query.toLowerCase();

        // البحث في الاسم الرسمي
        if (place['name'].toString().toLowerCase().contains(queryLower)) {
          return true;
        }

        // البحث في الاسم العربي
        if (place['nameAr'].toString().toLowerCase().contains(queryLower)) {
          return true;
        }

        // البحث في مصطلحات البحث الإضافية
        if (place['searchTerms'] != null) {
          final searchTerms = place['searchTerms'] as List;
          for (var term in searchTerms) {
            if (term.toString().toLowerCase().contains(queryLower)) {
              return true;
            }
          }
        }

        return false;
      }).toList();

      // تحويل الأماكن المميزة إلى MapboxPlace
      for (var place in matchingFeaturedPlaces) {
        final featuredPlace = MapboxPlace(
          id: 'featured_${place['name']}',
          placeName:
              '${place['nameAr']} - ${place['name']}, Riyadh, Saudi Arabia',
          text: place['name'],
          longitude: place['lng'],
          latitude: place['lat'],
          bbox: [place['lng'], place['lat'], place['lng'], place['lat']],
          placeType: 'poi',
          description: place['description'], // إضافة الوصف
        );
        results.add(featuredPlace);
      }

      // البحث السريع في المدن والمعالم السعودية أولاً
      final matchingCities = _saudiCities
          .where(
            (city) =>
                city.toLowerCase().contains(query.toLowerCase()) ||
                city.contains(query),
          )
          .toList();

      final matchingLandmarks = _saudiLandmarks
          .where(
            (landmark) =>
                landmark.toLowerCase().contains(query.toLowerCase()) ||
                landmark.contains(query),
          )
          .toList();

      // البحث حسب النوع المحدد
      switch (_selectedSearchType) {
        case 'saudi':
          results = await _geocodingService.searchSaudiPlaces(query);
          break;
        case 'cities':
          results = await _geocodingService.searchSaudiCities(query);
          break;
        case 'landmarks':
          results = await _geocodingService.searchSaudiLandmarks(query);
          break;
        default:
          results = await _geocodingService.searchPlaces(query);
      }

      // إضافة المدن والمعالم المطابقة في البداية
      if (matchingCities.isNotEmpty && _selectedSearchType == 'cities') {
        // إضافة المدن المطابقة كأولوية
        for (String city in matchingCities) {
          final cityPlace = MapboxPlace(
            id: 'saudi_city_${city}',
            placeName: city,
            text: city,
            longitude: 46.6753, // إحداثيات الرياض كمرجع
            latitude: 24.7136,
            bbox: [46.6753, 24.7136, 46.6753, 24.7136],
            placeType: 'place',
          );
          results.insert(0, cityPlace);
        }
      }

      if (matchingLandmarks.isNotEmpty && _selectedSearchType == 'landmarks') {
        // إضافة المعالم المطابقة كأولوية
        for (String landmark in matchingLandmarks) {
          final landmarkPlace = MapboxPlace(
            id: 'saudi_landmark_${landmark}',
            placeName: landmark,
            text: landmark,
            longitude: 39.8262, // إحداثيات مكة كمرجع
            latitude: 21.3891,
            bbox: [39.8262, 21.3891, 39.8262, 21.3891],
            placeType: 'poi',
          );
          results.insert(0, landmarkPlace);
        }
      }

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

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _isSearching = false;
    });
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
              Stack(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade600, size: 24),
                  if (_selectedSearchType == 'saudi')
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7F2F3A),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search Saudi cities, landmarks, streets...',
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
                  onPressed: _clearSearch,
                  icon: Icon(Icons.clear, color: Colors.grey.shade600),
                ),
            ],
          ),
        ),

        // Search Type Selector
        if (_searchController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: _searchTypes.entries.map((entry) {
                final isSelected = _selectedSearchType == entry.key;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSearchType = entry.key;
                      });
                      _onSearchChanged(_searchController.text);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF7F2F3A).withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF7F2F3A)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],

        // Search Results
        if (_searchResults.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
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
                    child: Icon(
                      _getPlaceIcon(place.placeType),
                      color: const Color(0xFF7F2F3A),
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.placeName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (place.placeType != null)
                        Text(
                          _getPlaceTypeLabel(place.placeType!),
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF7F2F3A).withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  onTap: () => _onPlaceSelected(place),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  IconData _getPlaceIcon(String? placeType) {
    switch (placeType) {
      case 'place':
        return Icons.location_city;
      case 'country':
        return Icons.flag; // علم السعودية
      case 'poi':
        return Icons.place; // معلم سياحي
      case 'address':
        return Icons.home;
      case 'neighborhood':
        return Icons.location_on;
      default:
        return Icons.location_on;
    }
  }

  String _getPlaceTypeLabel(String placeType) {
    switch (placeType) {
      case 'place':
        return 'مدينة';
      case 'country':
        return 'دولة';
      case 'poi':
        return 'معلم سياحي';
      case 'address':
        return 'عنوان';
      case 'neighborhood':
        return 'حي';
      default:
        return 'مكان';
    }
  }
}
