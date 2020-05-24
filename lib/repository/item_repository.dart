import 'dart:async';
import 'package:Spesa/models/item1.dart';
import 'package:Spesa/models/itemRepo.dart';
import 'item_provider.dart';

class ItemRepository{

  final itemProvider = ItemProvider();

  Future<List<Item>> fetchAllItem(idUser) => itemProvider.fetchItemList(idUser);
  Future<List<ItemRepo>> fetchAllRepo() => itemProvider.fetchRepoList();

//---------------------------------------------------------

}
