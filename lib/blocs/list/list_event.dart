import 'package:equatable/equatable.dart';


import 'package:spesa_repository/spesa_repository.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class LoadaList extends ListEvent {}

class AddItem extends ListEvent {
  final Item item;

  const AddItem(this.item);

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'AddItem { item_event: $item }';
}

class UpdateItem extends ListEvent {
  final Item updatedItem;

  const UpdateItem(this.updatedItem);

  @override
  List<Object> get props => [updatedItem];

  @override
  String toString() => 'UpdateItem_event { UpdateItem: $UpdateItem }';
}

class DeleteItem extends ListEvent {
  final Item item;

  const DeleteItem(this.item);

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'DeleteItem_event { item: $item }';
}

class ClearCompleted extends ListEvent {}

class ToggleAll extends ListEvent {}

class ListUpdated extends ListEvent {
  final List<Item> lista;

  const ListUpdated(this.lista);

  @override
  List<Object> get props => [lista];
}
