
import 'dart:convert';

List<Item> itemFromJson(String str) {
  final jsonData = json.decode(str);
  //if (jsonData['message'] == "no products found" )
  //    return new List<Item>();
  return new List<Item>.from(jsonData.map((x) => Item.fromJson(x)));
}

String itemToJson(List<Item> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class Item {
  String idItem;
  String product;
  String uri;
  String imageName;

  Item({
    this.idItem,
    this.product,
    this.uri,
      this.imageName ,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return new Item(
        idItem: json["idItem"] as String,
        product: json["product"] as String,
        uri: json["uri"] as String,
        imageName: json["imagename"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    "idItem": idItem,
    "product": product,
    "uri": uri,
      "imagename": imageName,
  };
}
