
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart' show TextBlock;
import 'package:url_launcher/url_launcher.dart';


typedef OnSaveProdCallBack = Function(String product);


class TextView extends StatefulWidget {
  final List<TextBlock> textBlocks;
  final OnSaveProdCallBack onSave;
  //const TextView({Key key, this.textBlocks}) : super(key: key);


  TextView({
      Key key,
      this.textBlocks,
      @required this.onSave,
  }) : super(key: key);

  @override
  _TextViewScreenState createState() => _TextViewScreenState();
}

class _TextViewScreenState extends State<TextView> {
    static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
              title: Text("Seleziona nome prodotto:",style: TextStyle(color:Color(0xFF18D191))),
              //backgroundColor: Colors.white,

          ),
          body: new SafeArea(
              child: new Form(
                  key: _formKey,
                  autovalidate: true,
                  child:
               ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: widget.textBlocks.length,
                  itemBuilder: (context, index) =>
                      Card(
                          child: Container(
                              padding: EdgeInsets.all(14),
                              child: Stack(children: [
                                  Text(widget.textBlocks[index].text,style: Theme.of(context).textTheme.headline6,),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Column(
                                          children: <Widget>[
                                              IconButton(
                                                  icon: Icon(
                                                      Icons.content_copy,
                                                      color: Theme.of(context).textTheme.headline6.color
                                                  ),
                                                  onPressed: () async {
                                                      /*ClipboardManager
                                                          .copyToClipBoard(
                                                          widget
                                                              .textBlocks[index]
                                                              .text)
                                                          .then((result) {
                                                          final snackBar = SnackBar(
                                                              content: Text(
                                                                  'Copied to Clipboard'),
                                                          );
                                                          Scaffold.of(context)
                                                              .showSnackBar(
                                                              snackBar);*/

                                                            if (_formKey.currentState.validate()) {
                                                                _formKey
                                                                    .currentState
                                                                    .save();
                                                                widget.onSave(
                                                                    widget
                                                                        .textBlocks[index]
                                                                        .text);
                                                                Navigator.pop(
                                                                    context,widget
                                                                    .textBlocks[index]
                                                                    .text);
                                                            }
                                                      //});
                                                  }),


                                          ],
                                      ),
                                  )
                              ]),
                          ),
                      )
              ),
              )
          )
      );

  }
}
