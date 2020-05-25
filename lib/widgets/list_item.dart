import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spesa_repository/spesa_repository.dart';

class ListItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final ValueChanged<bool> onCheckboxChanged;
  final Item item;

  ListItem({
    Key key,
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.onLongPress,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('__list_item_${item.id}'),
      onDismissed: onDismissed,
        child:   Card(
            elevation: 8.0,
            margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: ListTile(
                    //  dense:true,
                    isThreeLine: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 6.0),
                    leading:Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                    border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.red)),
              ),
              child:Column(
                  children: <Widget>[
                      Icon(Icons.shopping_cart, color:IconTheme.of(context).color),
                      Text(item.quantity, style: TextStyle(color: Colors.white,fontSize: 20))
                  ],
              )
          ),
          title: Hero(
              tag: '${item.id}__heroTag',
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                      item.product,
                      style: Theme.of(context).textTheme.headline6,
                  ),
              ),
          ),
          subtitle:
                Row(
              children: <Widget>[
                  Icon(Icons.note, color: Colors.white),
                  Text(item.type +"\n "+ item.note, style: TextStyle(color: Colors.white)),
              //Text(item.type, style: TextStyle(color: Colors.white))
              ],
          ),
          trailing:
                  item.imageurl.isNotEmpty
              ? Image.network(item.imageurl , fit: BoxFit.cover ,width:100 )
              : Text(""),
          onTap: item.imageurl.isNotEmpty ? onTap : null ,
          onLongPress:  onLongPress ,


      )
      ),
      ),
    );
  }
}
