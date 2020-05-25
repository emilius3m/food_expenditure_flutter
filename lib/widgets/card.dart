
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Spesa/screens/screens.dart';
import 'package:badges/badges.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:spesa_repository/spesa_repository.dart';

class SpesaCard extends StatelessWidget {

 Item item;
 final GestureTapCallback onTap;
 final GestureLongPressCallback onLongPress;

 SpesaCard(
    {
        Key key,
        @required this.item,
        @required this.onTap,
        @required this.onLongPress,
    }
    ):
        super(key: key);


@override
Widget build(BuildContext context) {
    return InkWell(
        onLongPress: onLongPress,
        onTap: () =>  item.imageurl.isNotEmpty ? Navigator.push(
            context,
            MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) =>
                     ImageView(
                            imageFile: item.imageurl,
                        ),
                    )
        ) : null,
        //padding: EdgeInsets.all(10.0),
        child:        DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(12),
            padding: EdgeInsets.all(6),
            color: Theme.of(context).accentColor,
            strokeWidth: 1,
            dashPattern: [6, 4, 6, 4],
            child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget> [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                        Text(
                            (item.imageurl != "")  ? item.product: "",
                            style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Badge(
                            shape: BadgeShape.square,
                            badgeColor: Theme.of(context).highlightColor,
                            borderRadius: 5,
                            position: BadgePosition.topRight(top:0, right: 0),
                            padding: EdgeInsets.all(4),
                            badgeContent: Text(
                                item.quantity.toString(),
                                style:  Theme.of(context).textTheme.bodyText2

                            ),
                            child:
                            Container(
                            //margin: EdgeInsets.all(2),
                            width: double.infinity,
                            height: 100,
                            //padding: EdgeInsets.only(top: 0.5, left: 0.5, right: 0.5, bottom: 20),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: (item.imageurl == "")  ?
                                    Text( item.product, style: Theme.of(context).textTheme.bodyText1)
                                 :  Image.network(item.imageurl , fit: BoxFit.cover)
                            )
                        ),
                        ),
                    ]
                ),
                Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget> [
                        Column (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget> [
                                FloatingActionButton(
                                    backgroundColor: Theme.of(context).highlightColor,
                                    onPressed: onTap,
                                    elevation: 4,
                                    heroTag: null,
                                    mini: false,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                                    child: Icon(
                                        Icons.edit_attributes, color:IconTheme.of(context).color ),
                                )
                            ]
                        ),
                        Column (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget> [
                                //padding: EdgeInsets.all(12.5),
                                Text(" "+ item.note, maxLines: 1,style: Theme.of(context).textTheme.headline2),
                                Text(" "+ item.type, maxLines: 1,style: Theme.of(context).textTheme.headline2),
                            ]
                        )
                        //Text(item.note, maxLines: 2,style: TextStyle(color:Colors.greenAccent))
                ]
            )
            ],
        ))
    );
}
}
