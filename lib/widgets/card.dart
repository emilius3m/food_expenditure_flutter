
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

        //@required this.imgUrl,
        //@required this.title,
        //@required this.subtitle,
        //@required this.estimatedTime
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
            color: Colors.green,
            strokeWidth: 1,
            dashPattern: [6, 4, 6, 4],
            child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
                //SizedBox(height: 10.0),
                /*
                    Badge(
                    position: BadgePosition.topRight(top: 0, right: -3),
                    animationDuration: Duration(milliseconds: 300),
                    animationType: BadgeAnimationType.slide,
                    badgeContent: Text(
                        estimatedTime.toString(),
                    style: TextStyle(color: Colors.white),
                    ),
                    child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
                    ),*/


                /*Expanded(
                    child:
                    DottedBorder(

                        //borderType: BorderType.RRect,
                        //radius: Radius.circular(12),
                        //padding: EdgeInsets.all(6),
                        //padding: EdgeInsets.all(2.5),
                        //dashPattern: [8, 4],
                        //strokeWidth: 2,
                        //strokeCap: StrokeCap.round,
                        child:Text(
                            item.product,
                            style: TextStyle(color:Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                    ),
                ),*/
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                        Text(
                            (item.imageurl != "")  ? item.product: "",
                            style: TextStyle(color:Color(0xFF18D191), fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Badge(
                            shape: BadgeShape.square,
                            badgeColor: Color(0xFF18D191),
                            borderRadius: 5,
                            position: BadgePosition.topRight(top:0, right: 0),
                            padding: EdgeInsets.all(4),
                            badgeContent: Text(
                                item.quantity.toString(),

                                style: TextStyle(
                                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                                    Text( item.product, style: TextStyle(color:Color(0xFF18D191), fontSize: 16, fontWeight: FontWeight.bold))
                                 :
                                Image.network(item.imageurl , fit: BoxFit.cover)

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
                                    backgroundColor: Color(0xFF18D191),
                                    onPressed: onTap,
                                    elevation: 2,
                                    heroTag: null,
                                    mini: false,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                                    child: Icon(Icons.edit_attributes, color: Colors.white),
                                )
                            ]
                        ),
                        /*Text(
                            (item.imageurl != "")  ? item.product: "",
                            style: TextStyle(color:Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        */Column (

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget> [

                                       //padding: EdgeInsets.all(12.5),
                                Text(" "+ item.note, maxLines: 1,style: TextStyle(color:Colors.greenAccent)),
                                Text(" "+ item.type, maxLines: 1,style: TextStyle(color:Colors.teal)),



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
