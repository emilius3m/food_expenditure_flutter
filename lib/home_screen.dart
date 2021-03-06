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
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'dart:math';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:form_floating_action_button/form_floating_action_button.dart';


List<Language> languages = [
    const Language('System', 'default'),
    const Language('English', 'en_US'),
    const Language('Italiano', 'it_IT'),
];

class Language {
    final String name;
    final String code;

    const Language(this.name, this.code);
}

class HomeScreen extends StatefulWidget {
    final String username;
    final String fbaseuid;

    const HomeScreen ({ Key key, this.username,this.fbaseuid }): super(key: key);
    @override
    _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    bool _loading = false;
  ByteData imgBytes;

  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  SpeechToText _speech;
  bool _speechRecognitionAvailable = false;
  Language selectedLang = languages.first;


  @override
  void initState() {
      super.initState();
      activateSpeechRecognizer();
  }

  void errorListener(SpeechRecognitionError error) {
      setState(() {
          lastError = "${error.errorMsg} - ${error.permanent}";
      });
  }

  void statusListener(String status) {
      setState(() {
          lastStatus = "$status";
      });
  }

  Future<void> activateSpeechRecognizer() async {
      print('_MyAppState.activateSpeechRecognizer... ');
      _speech = SpeechToText();

      _speechRecognitionAvailable = await _speech.initialize(
          onError: errorListener, onStatus: statusListener
      );
      var currentLocale = await _speech.systemLocale();
      if (null != currentLocale) {
          selectedLang =
              languages.firstWhere((lang) => lang.code == currentLocale.localeId);
      }

      if (!mounted) return;

      setState(() {
          _speechRecognitionAvailable = _speechRecognitionAvailable;
      });
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
      Size size;

      if ((40 * filteredItems.length) > 1080)
       size= Size( 720, ( (40 * filteredItems.length ).toDouble() + 80) );
            else size=Size( 720,1080);

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
                      title: Text('Hi ' + widget.username +'!',
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
                                              "",
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
                  body:
                  //Row(children: <Widget>[
                  //Text('You have $lastWords'),

                  activeTab == AppTab.spesa ? FilteredItems() : AddEditScreen(
                      onSave: (product, note,quantity,fileName,selectedType) {
                          ///print ("$product $note $fileName $selectedType");
                          //BlocProvider.of<ListBloc>(context).add(
                          //    AddItem(Item( product, note: note,quantity:quantity,type:selectedType,imageurl:fileName )),
                          //);
                          //BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.spesa));
                          //Navigator.pushReplacementNamed(context, '/');
                          //Navigator.of(context)
                          //    .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                          //Navigator.pushNamed(context, '/');
                      },
                      isEditing: false,
                  ),
                  //]),
                  /*floatingActionButton: ((activeTab == AppTab.addelement) && _speechRecognitionAvailable) ? Container() :
              FloatingActionButton(
                      backgroundColor: Color(0xFF18D191),
                      mini: false,
                      elevation: 9,
                      onPressed:  _speech.isListening ? null : startListening,
                      child: Icon(Icons.keyboard_voice),
                      tooltip: 'Add product',
                  ),*/
                  floatingActionButton:((activeTab == AppTab.addelement) && _speechRecognitionAvailable) ? Container() : FormFloatingActionButton(
                      loading: _loading,
                      icon: Icons.keyboard_voice,
                      color:  Color(0xFF18D191),
                      onSubmit: () {
                          setState(() => _loading = true);
                          startListening();
                          Future.delayed(Duration(seconds: 5)).then((_) {
                              if (mounted) {
                                  setState(() {
                                      _loading = false;
                                  });
                              }
                          });
                      },

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

  void startListening() {
      lastWords = "";
      lastError = "";
      _speech.listen(
          onResult: resultListener,
          listenFor: Duration(seconds: 5),
          localeId:  selectedLang.code,
          onSoundLevelChange: soundLevelListener,
          cancelOnError: true,
          partialResults: true);
      setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {

      if (result.finalResult)
      BlocProvider.of<ListBloc>(context).add(
          AddItem(Item( result.recognizedWords, note: "",quantity:"0",type:"" )));

      if (mounted) {
          setState(() {
              _loading = false;
          });
      }
      setState(() {
          lastWords = "${result.recognizedWords} - ${result.finalResult}";

      });
  }

  void soundLevelListener(double level) {
      minSoundLevel = min(minSoundLevel, level);
      maxSoundLevel = max(maxSoundLevel, level);
      //print("sound level $level: $minSoundLevel - $maxSoundLevel ");
      setState(() {
          this.level = level;
      });
  }
}



/*


floatingActionButton: activeTab == AppTab.addelement ? Container() : Row (
children: <Widget>[
FloatingActionButton(
backgroundColor: Color(0xFF18D191),

mini: false,
elevation: 9,
heroTag: null,
onPressed: _hasSpeech ? null : initSpeechState,
child: Icon(Icons.add_a_photo),
),
SizedBox(
width: 10,
),
FloatingActionButton(
backgroundColor: Color(0xFF18D191),
mini: false,
elevation: 9,
onPressed:  speech.isListening ? null : startListening,
child: Icon(Icons.keyboard_voice),
tooltip: 'Add product',
),
]),
*/
