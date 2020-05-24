import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Spesa/blocs/list/todos.dart';
import 'package:Spesa/screens/screens.dart';

class DetailsScreen extends StatelessWidget {
  final String id;

  DetailsScreen({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        final item = (state as ListLoaded)
            .lista
            .firstWhere((item) => item.id == id, orElse: () => null);


        return Scaffold(
          appBar: AppBar(
            title: Text('Details'),
            actions: [
              IconButton(
                tooltip: 'Delete Item',
                icon: Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<ListBloc>(context).add(DeleteItem(item));
                  Navigator.pop(context, item);
                },
              )
            ],
          ),
          body: item == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                                item.quantity,
                                style:
                                Theme.of(context).textTheme.headline5,
                            ),
                              /*child: Checkbox(
                                value: item.complete,
                                onChanged: (_) {
                                  BlocProvider.of<ListBloc>(context).add(
                                    UpdateItem(
                                        item.copyWith(complete: !item.complete),
                                    ),
                                  );
                                }),*/
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: '${item.id}__heroTag',
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 16.0,
                                    ),
                                    child: Text(
                                        item.product,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),

                                  ),
                                ),
                                Text(
                                    item.note,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                  Text(
                                      item.quantity,
                                      style:
                                      Theme.of(context).textTheme.headline5,
                                  ),
                                  Text(
                                      item.type,
                                      style:
                                      Theme.of(context).textTheme.headline5,
                                  ),

                              ],
                            ),
                          ),
                            Expanded(
                                child:  Column(
                                children: <Widget>[
                                    //Text('Uploaded Image'),
                                    item.imageurl != null
                                        ? Image.network(
                                        item.imageurl,
                                        height: 300,
                                        width: 300,
                                    )
                                        : Container(
                                        child: Center(
                                            child: Text(
                                                "No Image is Selected",
                                            ),
                                        ),
                                        height: 150,
                                    ),
                                ],
                            )
                            )
                        ],
                      ),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Edit Product',
            child: Icon(Icons.edit),
            onPressed: item == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddEditScreen(
                            onSave: (product, note,quantity,fileName,selectedType) {
                                print ("$product $note $quantity $fileName $selectedType");
                              BlocProvider.of<ListBloc>(context).add(UpdateItem(item.copyWith(
                                  product:product,note:note,quantity:quantity,imageurl:fileName,type:selectedType
                              )));
                            },
                            isEditing: true,
                            item: item,
                          );
                        },
                      ),
                    );
                  },
          ),
        );
      },
    );
  }
}
