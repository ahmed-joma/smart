class HomeData {
  final List<dynamic> featuredEvents;
  final List<dynamic> featuredHotels;
  final List<dynamic> categories;
  final List<dynamic> recommendations;

  HomeData({
    required this.featuredEvents,
    required this.featuredHotels,
    required this.categories,
    required this.recommendations,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      featuredEvents: json['featured_events'] ?? [],
      featuredHotels: json['featured_hotels'] ?? [],
      categories: json['categories'] ?? [],
      recommendations: json['recommendations'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'featured_events': featuredEvents,
      'featured_hotels': featuredHotels,
      'categories': categories,
      'recommendations': recommendations,
    };
  }
}
