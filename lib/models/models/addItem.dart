
class NewItem {
  String product;
  String idItemRepo;

  NewItem({
    this.product,
    this.idItemRepo,
  });

  factory NewItem.fromJson(Map<String, dynamic> json) {
    return new NewItem(
        product: json["product"] as String,
      idItemRepo: json["idItemRepo"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    "product": product,
    "idItemRepo": idItemRepo,
  };
}
