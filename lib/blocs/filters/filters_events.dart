import 'package:equatable/equatable.dart';
import 'package:spesa_repository/spesa_repository.dart';
import 'package:Spesa/models/models.dart';

abstract class FiltersEvent extends Equatable {
  const FiltersEvent();


  @override
  List<Object> get props => [];
}

class ChangeSupermercatoFilterEvent extends FiltersEvent {
  final bool newValue;

  const ChangeSupermercatoFilterEvent(
    this.newValue,
  );

  @override
  List<Object> get props => [
    newValue,
  ];

  @override
  String toString() => 'ChangeSupermercatoFilterEvent { newValue: $newValue }';
}

class ChangeUrgentFilterEvent extends FiltersEvent {
  final bool newValue;

  const ChangeUrgentFilterEvent(
      this.newValue,
      );

  @override
  List<Object> get props => [
    newValue,
  ];

  @override
  String toString() => 'ChangeUrgentFilterEvent { newValue: $newValue }';
}

class ChangePersonalCareFilterEvent extends FiltersEvent {
  final bool newValue;

  const ChangePersonalCareFilterEvent(
      this.newValue,
      );

  @override
  List<Object> get props => [
    newValue,
  ];

  @override
  String toString() => 'ChangePersonalCareFilterEvent { newValue: $newValue }';
}

class ChangeOnOfferFilterEvent extends FiltersEvent {
    final bool newValue;

    const ChangeOnOfferFilterEvent(
        this.newValue,
        );

    @override
    List<Object> get props => [
        newValue,
    ];

    @override
    String toString() => 'ChangeOnOfferFilterEvent { newValue: $newValue }';
}

class ChangeBricoFilterEvent extends FiltersEvent {
    final bool newValue;

    const ChangeBricoFilterEvent(
        this.newValue,
        );

    @override
    List<Object> get props => [
        newValue,
    ];

    @override
    String toString() => 'ChangeBricoFilterEvent { newValue: $newValue }';
}

class UpdateItems extends FiltersEvent {
    final List<Item> items;

    const UpdateItems(this.items);

    @override
    List<Object> get props => [items];

    @override
    String toString() => 'UpdateItems_event { items: $items }';
}

class UpdateFilter extends FiltersEvent {
    final VisibilityFilter filter;

    const UpdateFilter(this.filter);

    @override
    List<Object> get props => [filter];

    @override
    String toString() => 'UpdateFilter { filter: $filter }';
}


class UpdateListGrid extends FiltersEvent {
    final bool listgrid;

    const UpdateListGrid(this.listgrid);

    @override
    List<Object> get props => [listgrid];

    @override
    String toString() => 'UpdateListGrid { filter: $listgrid }';
}
