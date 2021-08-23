class Item {
  String? cmId;
  String? sku;
  String? name;
  String? imgUrl;
  double? basePrice;
  double? price;
  int quantity;
  int? stock;
  String? cond;
  String? size;

  /// TODO: Add "color"

  Item(
      {this.cmId,
      this.sku,
      this.name,
      this.imgUrl,
      this.basePrice,
      this.price,
      required this.quantity,
      this.stock,
      this.cond,
      this.size});
}
