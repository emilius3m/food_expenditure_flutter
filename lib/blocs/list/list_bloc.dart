import 'dart:async';
///import 'package:Spesa/models/item1.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:Spesa/blocs/list/todos.dart';
//import 'package:Spesa/repository/item_repository.dart';
import 'package:spesa_repository/spesa_repository.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  //final ItemRepository _itemRepository;
  final SpesaRepository _spesaRepository;
  StreamSubscription _todosSubscription;

  ListBloc({@required FirebaseSpesaRepository itemRepository})
      : assert(itemRepository != null),
          _spesaRepository = itemRepository;

  @override
  ListState get initialState => ListLoading();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is LoadaList) {
      yield* _mapLoadListToState();
    } else if (event is AddItem) {
      yield* _mapAddItemToState(event);
    } else if (event is UpdateItem) {
      yield* _mapUpdateItemToState(event);
    } else if (event is DeleteItem) {
      yield* _mapDeleteItemToState(event);
    } else if (event is ListUpdated) {
      yield* _mapListUpdateToState(event);
    }
  }




  Stream<ListState> _mapLoadListToState() async* {
      _todosSubscription?.cancel();
      _todosSubscription = _spesaRepository.spesa().listen(
              (spesa) => add(ListUpdated(spesa)),
      );
      /*try {
          ///final todos = await this._itemRepository.loadTodos();
          List<Item> lista = await this._itemRepository.fetchAllItem("1");
          yield ListLoaded(lista
              /////todos.map(Todo.fromEntity).toList(),
          );
      } catch (_) {
          yield ListNotLoaded();
      }*/
  }


  Stream<ListState> _mapAddItemToState(AddItem event) async* {
      _spesaRepository.addNewItem(event.item);
  }

  Stream<ListState> _mapUpdateItemToState(UpdateItem event) async* {
     _spesaRepository.updateItem(event.updatedItem);
  }

  Stream<ListState> _mapDeleteItemToState(DeleteItem event) async* {
    _spesaRepository.deleteItem(event.item);
  }

  Stream<ListState> _mapListUpdateToState(ListUpdated event) async* {
    yield ListLoaded(event.lista);
  }

  @override
  Future<void> close() {
      _todosSubscription?.cancel();
    return super.close();
  }
}
