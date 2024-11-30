class LocationModel {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String url;

  LocationModel({
    required this.id,
    required this.name,
    required this.region,
    this.country = '',
    this.lat = 0.0,
    this.lon = 0.0,
    this.url = '',
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['city'] ?? '',
      region: json['region'] ?? '',
      country: json['country'] ?? json['country_name'] ?? '',
      lat: json['lat'] ?? 0.0,
      lon: json['lon'] ?? 0.0,
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'country': country,
      'lat': lat,
      'lon': lon,
      'url': url,
    };
  }

// empty factory constructor for the LocationModel
  factory LocationModel.empty() {
    return LocationModel(
      id: 0,
      name: '',
      region: '',
      country: '',
      lat: 0.0,
      lon: 0.0,
      url: '',
    );
  }

  @override
  String toString() {
    return 'LocationModel{id: $id, name: $name, region: $region, country: $country, lat: $lat, lon: $lon, url: $url}';
  }
}
