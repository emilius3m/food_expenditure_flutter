import 'package:Spesa/resources/assets.dart';
import 'package:Spesa/resources/strings.dart';
import 'package:Spesa/utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  //static const String routeName = '/about';
  Future<bool> _onWillPopScope() async {
      return false;
  }

  @override
  Widget build(BuildContext context) {
      return WillPopScope(
          onWillPop: _onWillPopScope,
          child:
     Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            //backgroundColor: Colors.white,

          title: const Text(Strings.titleAboutPage,style: TextStyle(color:Color(0xFF18D191))),
            actions: <Widget>[
                IconButton(
                    tooltip: "Back",
                    icon: Icon(Icons.backspace,color: Color(0xFF18D191)),
                    onPressed: () {
                        Navigator.pop(context);
                        //Navigator.of(context).pushReplacementNamed('/');
                    }),

            ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 16), child:
                  SvgPicture.asset(
                      Assets.iconNoContent,
                      width: 400,
                  ),
                  )),
                Card(
                    color: Colors.white70,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    elevation: 8.0,
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                            children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(30.0, 10, 70.0, 10.0),
                                    child: Divider(color: Colors.grey[500], height: 4,),
                                ),

                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(Strings.txtAbout,

                                    ),
                                ),
                                RaisedButton(
                                    child: const Text(Strings.labelViewCodeButton),
                                    onPressed: () => Utils.launchURL(Strings.urlLegal),
                                    //Utils.launchURL(Strings.urlGithub),
                                ),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(30.0, 10, 70.0, 10.0),
                                    child: Divider(color: Colors.grey[500], height: 4,),
                                ),
                            ],
                        ),
                    ),
                ),
              /*Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                    const Text(Strings.txtAbout),
                  /*RaisedButton(
                    child: const Text(Strings.labelGoBack),
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/decision'),

                  )*/
                ],
              ),*/
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            return Text(snapshot.data.version + " build " + snapshot.data.buildNumber);
                          }
                        })
                  ],
                ),
              )
            ],
          ),
        )
     )
      );
  }
}
