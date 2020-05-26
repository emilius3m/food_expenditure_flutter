import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Spesa/authentication_bloc/authentication_bloc.dart';
import 'package:Spesa/models/models.dart';
import 'package:Spesa/user_repository.dart';
import 'package:Spesa/simple_bloc_delegate.dart';

import 'package:Spesa/blocs/blocs.dart';
import 'package:Spesa/widgets/widgets.dart';
import 'package:Spesa/screens/screens.dart';
import 'package:Spesa/widgets/spesa_drawer.dart';
import 'package:Spesa/widgets/filters.dart';
import 'package:spesa_repository/spesa_repository.dart';
import 'package:Spesa/blocs/filters/filters.dart';
import 'package:flutter/services.dart';
import 'package:Spesa/screens/settings_page.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

const kCanvasSize = 200.0;

class HomeScreen extends StatelessWidget {
  final String name;
  final String fbaseuid;
  ByteData imgBytes;


  HomeScreen({Key key, @required this.name,@required this.fbaseuid}) : super(key: key);

  void generateImage() async {



  }

   _redirectToPage(BuildContext context, Widget page){
      WidgetsBinding.instance.addPostFrameCallback((_){
          MaterialPageRoute newRoute = MaterialPageRoute(
              builder: (BuildContext context) => page
          );

          Navigator.of(context).pushAndRemoveUntil(newRoute, ModalRoute.withName('/'));
      });
  }

  void _shareText(String share) async {
      try {
          WcFlutterShare.share(
              sharePopupTitle: 'Lista Spesa title',
              subject: "Lista Spesa",
              text: share,
              mimeType: 'text/plain');
      } catch (e) {
          print(e);
      }
  }

  void _shareImageAndText(String share, List<Item> filteredItems) async {

      Size size= Size(720, 1080);
      //final color = Colors.primaries[widget.rd.nextInt(widget.numColors)];
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromPoints(Offset(0.0, 0.0), Offset(size.width, size.height)));

      final stroke = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
      final stroke1 = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width,  size.height), stroke);

      var index = 40;
      filteredItems.forEach((element) {

          final textStyle = TextStyle(
              color: Colors.black,
              fontSize: 40,
          );

          final textSpan = TextSpan(
              text: element.product,
              style: textStyle,
          );

          final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
          );

          final textSpan1 = TextSpan(
              text: "n.  "+ element.quantity,
              style: textStyle,
          );

          final textPainter1 = TextPainter(
              text: textSpan1,
              textDirection: TextDirection.ltr,
          );

          textPainter1.layout(
              minWidth: 0,
              maxWidth: size.width,
          );

          textPainter.layout(
              minWidth: 0,
              maxWidth: size.width,
          );

          textPainter.paint(canvas, Offset(150, index.toDouble()));
          textPainter1.paint(canvas, Offset(50, index.toDouble()));
          canvas.drawRect(Rect.fromLTWH(10, index.toDouble()+5, 30,  30), stroke1);
          index+=40;
      }
      );

      final picture = recorder.endRecording();
      final img = await picture.toImage(size.width.toInt(),  size.height.toInt());
      final pngBytes = await img.toByteData(format: ImageByteFormat.png);

      try {
          final ByteData bytes = await rootBundle.load('assets/launcher_icon.png');
          await WcFlutterShare.share(
              sharePopupTitle: 'Lista Spesa',
              subject: 'prodotti da comprare',
              text: share,
              fileName: 'share.png',
              mimeType: 'image/png',
              //bytesOfFile: bytes.buffer.asUint8List()
              bytesOfFile: pngBytes.buffer.asUint8List()
          );
      } catch (e) {
          print('error: $e');
      }
  }

  @override
  Widget build(BuildContext context) {

      IconThemeData iconThemeData = IconTheme.of(context);
      return BlocBuilder<TabBloc, AppTab>(
          builder: (context, activeTab) {
              return Scaffold(
                  ///////drawer: SpesaDrawer(),
                  appBar: AppBar(
                      //backgroundColor: Colors.white,
                      title: Text('Hi $name!',
                          style:  Theme.of(context).textTheme.bodyText1,
                          //style: TextStyle()
                           ),
                      actions: <Widget>[
                          BlocBuilder<FiltersBloc, FiltersState>(
                              builder: (context, state) =>
                                  IconButton(
                                      icon: state.isEnabled
                                          ?  Icon(Icons.filter_list, color: iconThemeData.color)
                                          :  Icon(Icons.filter_list, color: iconThemeData.color),
                                      tooltip: 'Filtrare',
                                      onPressed: () {
                                          return showGeneralDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              transitionDuration: Duration(milliseconds: 500),
                                              barrierLabel: MaterialLocalizations.of(context).dialogLabel,
                                              pageBuilder: (_, __, ___) => Filters(),
                                              transitionBuilder: (context, animation, secondaryAnimation, child) {
                                                  return SlideTransition(
                                                      position: CurvedAnimation(
                                                          parent: animation,
                                                          curve: Curves.easeOut,
                                                      ).drive(Tween<Offset>(
                                                          begin: Offset(0, -1.0),
                                                          end: Offset.zero,
                                                      )),
                                                      child: child,
                                                  );
                                              },
                                          );
                                      },
                                  )
                          ),

                            BlocBuilder<FiltersBloc, FiltersState>(

                            builder: (context, state) {
                                if (state is FilteredItemsLoading) {
                                    return LoadingIndicator();
                                }

                                return IconButton(
                                    icon: (state as FilteredItemsLoaded).activeFilter ? Icon(Icons.view_list,
                                        color: iconThemeData.color
                                    ) : Icon(Icons.view_comfy,color: iconThemeData.color,),
                                    onPressed: () {
                                        BlocProvider.of<FiltersBloc>(context).add(UpdateListGrid(!(state as FilteredItemsLoaded).activeFilter));
                                    }
                                    );
          }),
                          BlocBuilder<FiltersBloc, FiltersState>(

                              builder: (context, state) =>
                                  IconButton(

                                      icon:  Icon(Icons.share,
                                          color: iconThemeData.color
                                      ) ,
                                      onPressed: () {
                                          String share="";
                                          (state as FilteredItemsLoaded).filteredItems.forEach((element) {
                                             if (element.quantity != null)
                                                 share +="n. " + element.quantity?.toString() ;
                                             share += " "+element.product;
                                             if (element.note != null && element.note.isNotEmpty)
                                                 share +=" : " + element.note?.toString();
                                             if (element.type != null && element.type.isNotEmpty)
                                                 share +=" - " + element.type?.toString();
                                             share+= " \n";
                                          }
                                          );
                                          //print (share);
                                          _shareImageAndText(share,(state as FilteredItemsLoaded).filteredItems);
                                      }
                                  )
                          ),
                          InkWell(
                              child: Icon(
                                  Icons.settings,
                                  color: iconThemeData.color
                              ),
                              onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => SettingsPage(
                                              "prova",
                                          )),
                                  );
                              },
                          ),
                          //ExtraActions(),
                          IconButton(
                              icon: Icon(Icons.info,color: iconThemeData.color),
                              onPressed: () {
                                 _redirectToPage(context, AboutPage());
                              }),

                          //LogOutButton(),
                          IconButton(
                              icon: Icon(
                                  Icons.close,
                                  color: iconThemeData.color,
                              ),
                              onPressed: () {
                                  BlocProvider.of<AuthenticationBloc>(context).add(
                                      LoggedOut());
                              },
                          ),
                          IconButton(
                              tooltip: "Back",
                              icon: Icon(Icons.backspace,color: iconThemeData.color),
                              onPressed: () {
                                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                  //Navigator.of(context).pushReplacementNamed('/');
                              })

                      ],
                  ),
                  body: activeTab == AppTab.spesa ? FilteredItems() : AddEditScreen(
                      onSave: (product, note,quantity,fileName,selectedType) {
                          ///print ("$product $note $fileName $selectedType");
                          BlocProvider.of<ListBloc>(context).add(
                              AddItem(Item( product, note: note,quantity:quantity,type:selectedType,imageurl:fileName )),
                          );
                          BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.spesa));
                          Navigator.pushNamed(context, '/');
                      },
                      isEditing: false,
                  ),


                  bottomNavigationBar: TabSelector(
                      activeTab: activeTab,
                      onTabSelected: (tab) =>
                          BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
                  ),
              );
          },
      );
  }
}






