class Pizza {
  int id;
  String pizzaName;
  String description;
  double price;
  String imageUrl;

  Pizza({
    required this.id,
    required this.pizzaName,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  // Constructor fromJson dengan error handling
  Pizza.fromJson(Map<String, dynamic> json)
      : id = int.tryParse(json['id'].toString()) ?? 0,
        pizzaName = json['pizzaName']?.toString() ?? '',
        description = json['description']?.toString() ?? '',
        price = double.tryParse(json['price'].toString()) ?? 0.0,
        imageUrl = json['imageUrl']?.toString() ?? '';

  // Method toJson untuk serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pizzaName': pizzaName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}