import 'package:equatable/equatable.dart';


import 'package:Spesa/models/models.dart';
import 'package:spesa_repository/spesa_repository.dart';

class FiltersState extends Equatable {
    final bool activeFilter;
    final bool showSupermercato;
  final bool showUrgent;
  final bool showPersonalCare;
  final bool showOnOffer;
  final bool showBrico;
  final bool listgrid;




  const FiltersState({
      this.activeFilter = true,
    this.showSupermercato = true,
    this.showUrgent = true,
    this.showPersonalCare = true,
      this.showOnOffer = true,
      this.showBrico = true,
      this.listgrid= true
  });

  get isEnabled {
    return props.contains(false);
  }

  @override
  List<Object> get props => [
      showSupermercato,
      showUrgent,
      showPersonalCare,
      showOnOffer,
      showBrico,
  ];

  @override
  String toString() => 'FiltersState { showSupermercato: $showSupermercato, showUrgent: $showUrgent, showPersonalCare: $showPersonalCare }';
}

class FilteredItemsLoading extends FiltersState {


}
class FilteredMode extends FiltersState {
    final bool listgrid;
    const FilteredMode(
        {
            this.listgrid=true,
        }
        );

    @override
    List<Object> get props => [
        listgrid,

    ];

}

class FilteredItemsLoaded extends FiltersState {
    final List<Item> filteredItems;
    //final VisibilityFilter activeFilter;
    final bool showSupermercato;
    final bool showUrgent;
    final bool showPersonalCare;
    final bool showOnOffer;
    final bool showBrico;
    final bool activeFilter;

    const FilteredItemsLoaded(
        this.filteredItems,
        this.activeFilter,
        {
            this.showSupermercato=true,
            this.showUrgent=true,
            this.showPersonalCare=true,
            this.showOnOffer=true,
            this.showBrico=true,
        }
        );

    @override
    List<Object> get props => [filteredItems, activeFilter,showSupermercato,showUrgent,showPersonalCare,showOnOffer,showBrico];

    @override
    String toString() {
        return 'FilteredItemsLoaded {activeFilter: $activeFilter,$showSupermercato:$showUrgent:$showPersonalCare:$showOnOffer,$showBrico - filteredItems: $filteredItems,  }';
    }
}

