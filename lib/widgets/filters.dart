import 'package:Spesa/blocs/filters/filters.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Spesa/models/models.dart';

class _FilterChip extends StatelessWidget {
  final String labelText;
  final bool selected;
  final ValueChanged<bool> onSelected;

  _FilterChip({
    @required this.labelText,
    @required this.selected,
    @required this.onSelected
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      //backgroundColor: Color(0xFF18D191),
      selectedColor: Color(0xFF18D191),
      shape: StadiumBorder(
        side: BorderSide(

          color:selected
            ? Color(0xFF18D191)
            : Colors.grey
        )
      ),
      showCheckmark: false,
      label: Text(
        labelText,
        style: TextStyle(
          color: selected
            ? Colors.black
            : Colors.black38
        ),
      ),
      selected: selected,
      onSelected: onSelected
    );
  }
}

class Filters extends StatelessWidget {
   // final VisibilityFilter activeFilter;
  @override
  Widget build(BuildContext context) {
      FiltersBloc filtersBloc = BlocProvider.of<FiltersBloc>(context);

      return BlocBuilder<FiltersBloc, FiltersState>(
      bloc: filtersBloc,
      builder: (context, state) =>
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: new Card(
                borderOnForeground: false,
                color: Colors.grey,
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: IconButton(
                        icon: Icon(Icons.close),
                        tooltip: 'Close',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 20),
                      child: Text("Filtrare"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Wrap(
                        spacing: 10.0, // gap between adjacent chips
                        runSpacing: 8.0, // gap between lines
                        children: <Widget>[
                          _FilterChip(
                            labelText: "supermercato",
                            selected: (state as FilteredItemsLoaded).showSupermercato,
                            onSelected: (bool value) {
                                //BlocProvider.of<FilteredItemsBloc>(context).add(UpdateFilter(filter));
                                 filtersBloc.add(new ChangeSupermercatoFilterEvent(value));
                            }
                          ),
                          _FilterChip(
                            labelText: "Urgente",
                            selected: (state as FilteredItemsLoaded).showUrgent,
                            onSelected: (bool value) {
                                filtersBloc.add(
                                    new ChangeUrgentFilterEvent(value));
                            }
                          ),
                          _FilterChip(
                            labelText: "Igiene e Pulizia",
                            selected: (state as FilteredItemsLoaded).showPersonalCare,
                            onSelected: (bool value) {
                                filtersBloc.add(new ChangePersonalCareFilterEvent(value));
                                //filtersBloc.add(UpdateFilter(VisibilityFilter.active));
                            } ,
                          ),
                            _FilterChip(
                                labelText: "brico",
                                selected: (state as FilteredItemsLoaded).showBrico,
                                onSelected: (bool value) {
                                    //BlocProvider.of<FilteredItemsBloc>(context).add(UpdateFilter(filter));
                                    filtersBloc.add(new ChangeBricoFilterEvent(value));
                                }
                            ),
                            _FilterChip(
                                labelText: "in offerta",
                                selected: (state as FilteredItemsLoaded).showOnOffer,
                                onSelected: (bool value) {
                                    //BlocProvider.of<FilteredItemsBloc>(context).add(UpdateFilter(filter));
                                    filtersBloc.add(new ChangeOnOfferFilterEvent(value));
                                }
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}
