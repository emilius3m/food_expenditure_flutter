import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
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

class Item extends Equatable {
    final bool complete;
  String idItem;
  String product;
  String uri;
  String imageName;
  final bool isDeleting;

  Item({
    this.idItem,
    this.product,
    this.uri,
    this.imageName ,
	this.isDeleting = false,
      this.complete = false
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return new Item(
        idItem: json["idItem"] as String,
        product: json["product"] as String,
        uri: json["uri"] as String,
        imageName: json["imagename"] as String,
    );
  }


  Item copyWith({
      String idItem,
      String product,
	  String uri,
	  String imageName,
      bool isDeleting,
      bool complete
  }) {
      return Item(
          idItem: idItem ?? this.idItem,
          product: product ?? this.product,
		  uri: uri ?? this.uri,
		  imageName: imageName ?? this.imageName,
          isDeleting: isDeleting ?? this.isDeleting,
          complete: complete ?? this.complete,
      );
  }


  @override
  List<Object> get props => [idItem, product,uri,imageName, isDeleting];

  @override
  String toString() =>
      'Item { id: $idItem, value: $product, uri: $uri, imagename: $imageName, isDeleting: $isDeleting }';

  Map<String, dynamic> toJson() => {
    "idItem": idItem,
    "product": product,
    "uri": uri,
    "imagename": imageName,
  };
}
