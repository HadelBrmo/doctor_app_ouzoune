class AdditionalTool {
  final int? id;
  final String? name;
  final double? width;
  final double? height;
  final double? thickness;
  final int? quantity;
  final int? kitId;
  final int? categoryId;
  final String? imagePath;

  AdditionalTool({
    required this.id,
    required this.name,
    required this.width,
    required this.height,
    required this.thickness,
    required this.quantity,
    this.kitId,
    required this.categoryId,
    required this.imagePath,
  });

  factory AdditionalTool.fromJson(Map<String, dynamic> json) {
    return AdditionalTool(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      thickness: (json['thickness'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      kitId: json['kitId'] as int?,
      categoryId: json['categoryId'] as int? ?? 0,
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'width': width,
    'height': height,
    'thickness': thickness,
    'quantity': quantity,
    'kitId': kitId,
    'categoryId': categoryId,
    'imagePath': imagePath,
  };

  factory AdditionalTool.empty() => AdditionalTool(
    id: 0,
    name: 'Unnamed Tool',
    width: 0,
    height: 0,
    thickness: 0,
    quantity: 0,
    kitId: null,
    categoryId: 0,
    imagePath: null,
  );
}