import "dart:io";

class Product {
  File? updatedImage;
  String id;
  String image;
  String name;
  double price;
  String description;
  int count;

  Product(
      {required this.id,
      required this.count,
      required this.image,
      required this.name,
      required this.price,
      required this.description,
      this.updatedImage});
}
