class Venue {
  final int id;
  final String name;
  final String? description;
  final String? address;
  final String? image;
  final Map<String, dynamic>? sport;
  final int sportId;
  final double pricePerHour;
  final double? rating;
  final bool? isAvailable;
  final double? latitude;
  final double? longitude;

  Venue({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.image,
    this.sport,
    required this.sportId,
    required this.pricePerHour,
    this.rating,
    this.isAvailable,
    this.latitude,
    this.longitude,
  });

  Null get reviews => null;

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      image: json['image'],
      sport: json['sport'],
      sportId: json['sport_id'] ?? 0,
      pricePerHour: double.parse(json['price_per_hour'].toString()),
      rating: json['rating'] != null
          ? double.parse(json['rating'].toString())
          : null,
      isAvailable: json['is_available'] == 1 ? true : false,
      latitude: json['latitude'] != null
          ? double.parse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.parse(json['longitude'].toString())
          : null,
    );
  }
}
