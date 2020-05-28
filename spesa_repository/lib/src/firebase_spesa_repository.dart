// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spesa_repository/spesa_repository.dart';
import 'entities/entities.dart';

class FirebaseSpesaRepository implements SpesaRepository {
  final spesaCollection = Firestore.instance.collection('spesa');
  final String _uid;

  FirebaseSpesaRepository(String uid)
      : _uid = uid ?? uid;


  @override
  Future<void> addNewItem(Item item) async {
      /*spesaCollection.add({
          "name": "john",
          "age": 50,
          "email": "example@example.com",
          "address": {"street": "street 24", "city": "new york"}
      }).then((value) {
          print(value.documentID);
          spesaCollection
              .document(value.documentID)
              .collection("pets")
              .add({"petName": "blacky", "petType": "dog", "petAge": 1});
      });
        */
      Firestore.instance.runTransaction((Transaction transaction) async {
          spesaCollection.document(_uid).collection('mylist').add(
              item.toEntity().toDocument());
          });
         // .then((_){
         // print("success!");
      //});
  }

  @override
  Future<void> deleteItem(Item item) async {
      return spesaCollection.document(_uid)
          .collection('mylist')
          .document(item.id).delete();
  }

  @override
  Stream<List<Item>> spesa()  {
    return spesaCollection.document(_uid).collection('mylist').orderBy('product', descending: false).snapshots().map((snapshot) {
          return snapshot.documents.map((doc) =>
              Item.fromEntity(ItemEntity.fromSnapshot(doc))
          ).toList();
    });
  }

  @override
  Future<void> updateItem(Item update) {
    return spesaCollection.document(_uid)
        .collection('mylist')
        .document(update.id)
        .updateData(update.toEntity().toDocument());
  }
}
