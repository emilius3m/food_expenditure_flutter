import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Spesa/blocs/blocs.dart';
import 'package:Spesa/widgets/widgets.dart';
import 'package:Spesa/screens/screens.dart';
import 'package:spesa_repository/spesa_repository.dart';


class FilteredItems extends StatelessWidget {
  FilteredItems({Key key}) : super(key: key);
  bool grid=true;




  @override
  Widget build(BuildContext context) {

      return BlocBuilder<FiltersBloc, FiltersState>(
      builder: (context, state) {
        if (state is FilteredItemsLoading) {
          return LoadingIndicator();
        }


        else if (state is FilteredItemsLoaded) {
          final spesa = state.filteredItems;
          grid = state.activeFilter;
          //print ("grid"+ state.listgrid.toString());
          //  print ("activeFilter"+state.activeFilter.toString());

          if (grid==true ) {
              return GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: spesa.length,
                  shrinkWrap: true,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                      final item = spesa[index];
                      return SpesaCard(item:item,
                          onLongPress: () async {
                              BlocProvider.of<ListBloc>(context).add(
                                  DeleteItem(item));
                              Scaffold.of(context).showSnackBar(
                                  DeleteItemSnackBar(
                                      item: item,
                                      onUndo: () =>
                                          BlocProvider.of<ListBloc>(context)
                                              .add(AddItem(item)),
                                  )
                              );
                          },
                          onTap: () async {
                              final removedItem = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) {
                                              return AddEditScreen(
                                                  onSave: (product, note,quantity,fileName,selectedType) {
                                                      //print ("$product $note $quantity $fileName $selectedType");
                                                      //BlocProvider.of<ListBloc>(context).add(UpdateItem(item.copyWith(
                                                      //    product:product,note:note,quantity:quantity,imageurl:fileName,type:selectedType
                                                      //)));
                                                  },
                                                  isEditing: true,
                                                  item: item,
                                              );
                                          },
                                      ),
                                  );

                              if (removedItem != null) {
                                  Scaffold.of(context).showSnackBar(
                                      DeleteItemSnackBar(
                                          item: item,
                                          onUndo: () =>
                                              BlocProvider.of<ListBloc>(context)
                                                  .add(AddItem(item)),
                                      ),
                                  );
                              }
                          },
                      );
                      /*
                      return InkResponse(
                          enableFeedback: true,
                          child: Card(
                              child: new Stack(
                                  children: <Widget>[
                                      //new Image.network(snapshot.data[index].uri, fit: BoxFit.contain ),
                                      ListTile(
                                          leading: Text (" "),
                                          title:  new Image.network(item.imageurl, fit: BoxFit.cover ),
                                          subtitle:  item.type == ""
                                              ? Text( item.type)
                                              : Text( item.type)
                                          //new Image.network('http://ha.e3m.ovh/testApi/images/'+snapshot.data[index].imageName, fit: BoxFit.contain ),

                                      ),
                                      Padding(padding: EdgeInsets.only(top: 100, left: 15), child: new Text(item.product, style: new TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold))),

                                  ],
                              ),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.all(18),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 3,
                          ),


                                  BlocProvider.of<ListBloc>(context).add(
                                      DeleteItem(item));
                                  Scaffold.of(context).showSnackBar(
                                      DeleteItemSnackBar(
                                          item: item,
                                          onUndo: () =>
                                              BlocProvider.of<ListBloc>(context)
                                                  .add(AddItem(item)),
                                      ));


                          }

                          ,
                          //onLongPress: ()=>  viewItem(snapshot.data[index]),
                      );*/
                  },
              );
          }
          else {
              return ListView.builder(
                  //shrinkWrap: true,
                  //scrollDirection: Axis.vertical,
                  //itemExtent: 120,
                  //padding: const EdgeInsets.all(8.0),

                  itemCount: spesa.length,
                  itemBuilder: (context, index) {
                      final item = spesa[index];

                      ///return Container();
                      //return InkResponse(
                      return ListItem(
                          item: item,
                          onDismissed: (direction) {
                              BlocProvider.of<ListBloc>(context).add(
                                  DeleteItem(item));
                              Scaffold.of(context).showSnackBar(
                                  DeleteItemSnackBar(
                                      item: item,
                                      onUndo: () =>
                                          BlocProvider.of<ListBloc>(context)
                                              .add(AddItem(item)),
                                  ));
                          },
                          onLongPress: () async {
                              final removedItem = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) {
                                                return AddEditScreen(
                                                    onSave: (product, note,quantity,fileName,selectedType) {
                                                        //print ("$product $note $quantity $fileName $selectedType");
                                                        //BlocProvider.of<ListBloc>(context).add(UpdateItem(item.copyWith(
                                                        //    product:product,note:note,quantity:quantity,imageurl:fileName,type:selectedType
                                                        //)));
                                                        },
                                                    isEditing: true,
                                                    item: item,
                                                );
                                                },
                                        ),
                              );
                              if (removedItem != null) {
                                  Scaffold.of(context).showSnackBar(
                                      DeleteItemSnackBar(
                                          item: item,
                                          onUndo: () =>
                                              BlocProvider.of<ListBloc>(context)
                                                  .add(AddItem(item)),
                                      ),
                                  );
                              }
                              },
                          onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          ImageView(
                                              imageFile: item.imageurl,
                                          ),
                                  )
                              );
                          },
                      );
                  },
              );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
