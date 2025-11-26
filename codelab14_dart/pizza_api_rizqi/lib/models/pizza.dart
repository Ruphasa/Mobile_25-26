// Konstanta untuk kunci JSON
const String keyId = 'id';
const String keyPizzaName = 'pizzaName';
const String keyDescription = 'description';
const String keyPrice = 'price';
const String keyImageUrl = 'imageUrl';

class Pizza {
  int? id;
  String? pizzaName;
  String? description;
  double? price;
  String? imageUrl;

  Pizza({
    this.id,
    this.pizzaName,
    this.description,
    this.price,
    this.imageUrl,
  });

  // Constructor fromJson menggunakan konstanta
  Pizza.fromJson(Map<String, dynamic> json)
      : id = json[keyId] != null ? int.tryParse(json[keyId].toString()) : null,
        pizzaName = json[keyPizzaName]?.toString(),
        description = json[keyDescription]?.toString(),
        price = json[keyPrice] != null ? double.tryParse(json[keyPrice].toString()) : null,
        imageUrl = json[keyImageUrl]?.toString();

  // Method toJson menggunakan konstanta
  Map<String, dynamic> toJson() {
    return {
      if (id != null) keyId: id,
      if (pizzaName != null) keyPizzaName: pizzaName,
      if (description != null) keyDescription: description,
      if (price != null) keyPrice: price,
      if (imageUrl != null) keyImageUrl: imageUrl,
    };
  }
}