import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Item {
  final bool complete;
  final String id;
  final String note;
  final String product;
  final String imageurl;
  final String quantity;
  final String type;

  String uid;

  Item(this.product, {this.complete = false, String note = '', String id,String uid,String imageurl,String quantity, String type})
      :   this.note = note ?? '',
          this.quantity = quantity ?? '',
          this.imageurl = imageurl ?? '',
          this.type = type ?? '',
          this.id = id,
          this.uid = uid;

  Item copyWith({bool complete, String id, String note, String product, String uid, String quantity, String imageurl, String type }) {
    return Item(
        product ?? this.product,
        complete: complete ?? this.complete,
        id: id ?? this.id,
        note: note ?? this.note,
        uid: uid ?? this.uid,
        imageurl: imageurl ?? this.imageurl,
        quantity: quantity ?? this.quantity,
        type: type ?? this.type,
    );
  }

  @override
  int get hashCode =>
      complete.hashCode ^ product.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          product == other.product &&
          note == other.note &&
          id == other.id &&
          imageurl == other.imageurl &&
          quantity == other.quantity &&
          type == other.type;



  @override
  String toString() {
    return 'Item{complete: $complete, product: $product, type:$type, note: $note,quantity: $quantity, imageurl: $imageurl,  id: $id}';
  }

  ItemEntity toEntity() {
    return ItemEntity(product, id, note, complete, quantity,imageurl,type);
  }

  static Item fromEntity(ItemEntity entity) {
    return Item(
        entity.product,
        complete: entity.complete ?? false,
        note: entity.note,
        id: entity.id,
        quantity: entity.quantity,
        imageurl: entity.imageurl,
        type: entity.type,
    );
  }
}
