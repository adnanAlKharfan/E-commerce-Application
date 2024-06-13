class Order {
  String id;
  String productId;
  double total;
  int number;
  String productName;
  String status;
  String feedback;
  Order(
      {required String this.productId,
      required String this.id,
      required double this.total,
      required String this.productName,
      String this.status = "pending",
      required int this.number,
      String this.feedback = ""});
}
