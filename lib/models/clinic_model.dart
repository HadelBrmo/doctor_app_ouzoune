class Clinic {
  final int id;
  final String name;
  final String address;
  final double longitude;
  final double latitude;
  final double? rate;

  Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
    this.rate,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      longitude: (json['longtitude'] as num?)?.toDouble() ?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      rate: (json['rate'] as num?)?.toDouble(),
    );
  }
}