class Implant {
  final int? id;
  final double? radius;
  final double? width;
  final double? height;
  final int? quantity;
  final String? brand;
  final String? description;
  final String? imagePath;
  final int? kitId;

  Implant({
    this.id,
    this.radius,
    this.width,
    this.height,
    this.quantity,
    this.brand,
    this.description,
    this.imagePath,
    this.kitId,
  });

  factory Implant.fromJson(Map<String, dynamic> json) {
    try {
      return Implant(
        id: json['id'] as int? ?? 0,
        radius: (json['radius'] as num?)?.toDouble() ?? 0.0,
        width: (json['width'] as num?)?.toDouble() ?? 0.0,
        height: (json['height'] as num?)?.toDouble() ?? 0.0,
        quantity: json['quantity'] as int? ?? 0,
        brand: json['brand'] as String? ?? '',
        description: json['description'] as String? ?? '',
        imagePath: json['imagePath'] as String? ?? '',
        kitId: json['kitId'] as int? ?? 0,
      );
    } catch (e) {
      print('Error parsing implant: $e\nJSON: $json');

      return Implant(
        id: 0,
        radius: 0.0,
        width: 0.0,
        height: 0.0,
        quantity: 0,
        brand: 'Error Implant',
        description: 'Error parsing implant data',
        imagePath: null,
        kitId: 0,
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'radius': radius,
    'width': width,
    'height': height,
    'quantity': quantity,
    'brand': brand,
    'description': description,
    'imagePath': imagePath,
    'kitId': kitId,
  };

  String get displayImage {
    if (imagePath == null || imagePath!.isEmpty) {
      return 'assets/images/default_implant.png';
    }
    return imagePath!;
  }

  String get displayInfo {
    return '${brand ?? "No Brand"} - Size: ${width} x ${height} - Qty: $quantity';
  }
}