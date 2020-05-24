// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:spesa_repository/spesa_repository.dart';

abstract class SpesaRepository {
  Future<void> addNewItem(Item todo);

  Future<void> deleteItem(Item todo);

  Stream<List<Item>> spesa();

  Future<void> updateItem(Item todo);
}
