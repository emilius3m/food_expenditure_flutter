import 'package:equatable/equatable.dart';

import 'package:spesa_repository/spesa_repository.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListLoading extends ListState {}

class ListLoaded extends ListState {
  final List<Item> lista;

  const ListLoaded([this.lista = const []]);

  @override
  List<Object> get props => [lista];

  @override
  String toString() => 'ListaLoaded { listastati: $lista }';
}

class ListNotLoaded extends ListState {}
