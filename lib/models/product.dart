class Product {
  final String name;
  final double price;
  final String image;
  final String description;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  // Convert from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      description: json['description'],
      category: json['category'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}