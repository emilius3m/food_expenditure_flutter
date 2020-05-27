// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final bool complete;
  final String id;
  final String note;
  final String product;
  final String quantity;
  final String imageurl;
  final String type;

  const ItemEntity(this.product, this.id, this.note, this.complete, this.quantity, this.imageurl, this.type);


  Map<String, Object> toJson() {
    return {
        "type": type,
        "imageurl": imageurl,
        "quantity": quantity,
        "complete": complete,
        "product": product,
        "note": note,
        "id": id,
    };
  }

  @override
  List<Object> get props => [complete, id, note, product,quantity,type];

  @override
  String toString() {
    return 'ItemEntity { complete: $complete, product: $product, note: $note,quantity: $quantity, imageurl: $imageurl, id: $id }';
  }

  static ItemEntity fromJson(Map<String, Object> json) {
    return ItemEntity(
        json["product"] as String,
        json["id"] as String,
        json["note"] as String,
        json["complete"] as bool,
        json["quantity"] as String,
        json["imageurl"] as String,
        json["type"] as String,
    );
  }

  static ItemEntity fromSnapshot(DocumentSnapshot snap) {
    return ItemEntity(
        snap.data['product'],
        snap.documentID,
        snap.data['note'],
        snap.data['complete'],
        snap.data['quantity'],
        snap.data['imageurl'],
        snap.data['type'],
    );
  }

  Map<String, Object> toDocument() {
    return {
        "complete": complete,
        "product": product,
        "note": note,
        "quantity": quantity,
        "imageurl": imageurl,
        "type": type,
    };
  }
}


