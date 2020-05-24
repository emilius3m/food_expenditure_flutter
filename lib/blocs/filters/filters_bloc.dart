import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Spesa/blocs/list/todos.dart';
import 'filters_events.dart';
import 'filters_states.dart';

import 'package:meta/meta.dart';
import 'package:Spesa/models/models.dart';
import 'package:spesa_repository/spesa_repository.dart';

class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {

    final ListBloc _listBloc;
    StreamSubscription _todosSubscription;

    FiltersBloc({@required ListBloc listBloc})
        : assert(listBloc != null),

            _listBloc = listBloc {
            _todosSubscription = listBloc.listen((state) {
                if (state is ListLoaded) {
                    add(UpdateItems((listBloc.state as ListLoaded).lista));
                }
               }
            );
    }

  //@override
  //FiltersState get initialState => FiltersState();


    @override
    FiltersState get initialState {
        final currentState = _listBloc.state;
        return currentState is ListLoaded
            ? FilteredItemsLoaded(currentState.lista, true)
            : FilteredItemsLoading();
    }




  @override
  Stream<FiltersState> mapEventToState(FiltersEvent event) async* {
    if (event is ChangeSupermercatoFilterEvent) {
      yield* _onSupermercatoFilterChange(event);
    } else if (event is ChangeUrgentFilterEvent) {
      yield* _onUrgentFilterChange(event);
    } else if (event is ChangePersonalCareFilterEvent) {
      yield* _onPersonalCareFilterChange(event);
    } else if (event is ChangeOnOfferFilterEvent) {
        yield* _onOnOfferFilterChange(event);
    } else if (event is ChangeBricoFilterEvent) {
        yield* _onBricoFilterChange(event);
    } else if (event is UpdateListGrid) {
            yield* _mapUpdateFilterToState(event);
    } else if (event is UpdateItems) {
            yield* _mapItemsUpdatedToState(event);
        }
    }



    Stream<FiltersState> _onSupermercatoFilterChange(ChangeSupermercatoFilterEvent event) async* {


        final currentState = _listBloc.state;
        if (currentState is ListLoaded) {
        //    add(UpdateItems((_listBloc.state as ListLoaded).lista));
            yield FilteredItemsLoaded(
                _mapListToTypeList(currentState.lista,  event.newValue,  state.showUrgent, state.showPersonalCare,state.showOnOffer,state.showBrico),
                state.activeFilter,
                showSupermercato: event.newValue, showUrgent: state.showUrgent,
                showPersonalCare: state.showPersonalCare, showOnOffer: state.showOnOffer, showBrico: state.showBrico
            );
        }
  }

  Stream<FiltersState> _onUrgentFilterChange(ChangeUrgentFilterEvent event) async* {
          final currentState = _listBloc.state;
      if (currentState is ListLoaded) {

          yield FilteredItemsLoaded(
              _mapListToTypeList(currentState.lista,  state.showSupermercato,   event.newValue,  state.showPersonalCare, state.showOnOffer, state.showBrico),
              state.activeFilter,
              showSupermercato: state.showSupermercato, showUrgent: event.newValue,
              showPersonalCare: state.showPersonalCare, showOnOffer: state.showOnOffer, showBrico: state.showBrico
          );
      }
  }

  Stream<FiltersState> _onPersonalCareFilterChange(ChangePersonalCareFilterEvent event) async* {

   final currentState = _listBloc.state;
    if (currentState is ListLoaded) {

        yield FilteredItemsLoaded(
            _mapListToTypeList(currentState.lista,  state.showSupermercato,  state.showUrgent, event.newValue,state.showOnOffer,state.showBrico),
            state.activeFilter,
            showSupermercato: state.showSupermercato, showUrgent: state.showUrgent,showPersonalCare: event.newValue,
            showOnOffer: state.showOnOffer,showBrico: state.showBrico
        );
    }
  }

    Stream<FiltersState> _onOnOfferFilterChange(ChangeOnOfferFilterEvent event) async* {

        final currentState = _listBloc.state;
        if (currentState is ListLoaded) {

            yield FilteredItemsLoaded(
                _mapListToTypeList(currentState.lista,  state.showSupermercato,  state.showUrgent,state.showPersonalCare, event.newValue,state.showBrico),
                state.activeFilter,
                showSupermercato: state.showSupermercato, showUrgent: state.showUrgent,showPersonalCare:state.showPersonalCare,
                showOnOffer: event.newValue,showBrico: state.showBrico

            );
        }
    }

    Stream<FiltersState> _onBricoFilterChange(ChangeBricoFilterEvent event) async* {

        final currentState = _listBloc.state;
        if (currentState is ListLoaded) {

            yield FilteredItemsLoaded(
                _mapListToTypeList(currentState.lista, state.showSupermercato, state.showUrgent, state.showPersonalCare, state.showOnOffer, event.newValue),
                state.activeFilter,
                showSupermercato: state.showSupermercato, showUrgent: state.showUrgent,
                showPersonalCare: state.showPersonalCare, showOnOffer: state.showOnOffer,showBrico: event.newValue
            );
        }
    }


    Stream<FiltersState> _mapUpdateFilterToState(UpdateListGrid event,) async* {

        final currentState = _listBloc.state;
        if (currentState is ListLoaded) {

            yield FilteredItemsLoaded(
                _mapListToTypeList(currentState.lista, state.showSupermercato, state.showUrgent, state.showPersonalCare, state.showOnOffer, state.showBrico),
                event.listgrid,
                showSupermercato: state.showSupermercato, showUrgent: state.showUrgent,
                showPersonalCare: state.showPersonalCare, showOnOffer: state.showOnOffer,showBrico: state.showBrico
            );
        }

    }

    List<Item> _mapListToFilteredList(List<Item> lista) {
        return lista.where((item) {
            return true;
            /*if (filter == VisibilityFilter.all) {
                return true;
            } else if (filter == VisibilityFilter.active) {

                return !item.complete;
            } else {
                return item.complete;
            }*/
        }).toList();
    }

    List<Item> _mapListToTypeList(List<Item> lista,bool showSupermercato, bool showUrgent,bool showPersonalCare, bool showOnOffer, bool showBrico) {
        return lista.where((item) {

            //var grade = item.type;
            switch(item.type) {
                case "supermercato": {
                    if (showSupermercato)
                        return true;
                }
                break;
                case "urgente finito!": {
                    if (showUrgent)
                         return true;
                }
                break;
                case "Brico": {
                    if (showBrico)
                        return true;
                }
                break;
                case "solo se in offerta": {
                    if (showOnOffer)
                    return true;
                }
                break;
                case "igiene e pulizia": {
                      if (showPersonalCare)
                           return true;
                }
                break;

                default: {
                    return true;


                break;
            }
        }

            //if (item.type != "supermercato")
            //    return true;
            //if (item.type == "supermercato" && showSupermercato)  {
            //    return true;
            //} else return false;
        return false;
        }
        ).toList();
    }

    Stream<FiltersState> _mapItemsUpdatedToState(UpdateItems event,) async* {
        final visibilityFilter = state is FilteredItemsLoaded
            ? (state as FilteredItemsLoaded).activeFilter
            : true;
        yield FilteredItemsLoaded(
            _mapListToFilteredList(
                (_listBloc.state as ListLoaded).lista,
            ),
            visibilityFilter,
        );
    }

    @override
    Future<void> close() {
        _todosSubscription?.cancel();
        return super.close();
    }
}
