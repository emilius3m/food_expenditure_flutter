import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Spesa/utils/constants.dart';
import 'package:Spesa/utils/styles.dart';

//import 'home.dart';
import 'intro_screen.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool(Constants.appPreviouslyRunKey) ?? false);
    //bool _seen = false;

    if (_seen) {
        //Navigator.pushNamed(context, '/');
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
       // Navigator.pushReplacementNamed(context, '/');
      /*Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage()
        )
      );*/
    } else {
      await prefs.setBool(Constants.appPreviouslyRunKey, true);
      Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
          builder: (context) => new IntroScreenPage()
        )
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () {
        checkFirstSeen();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      decoration: BoxDecoration(
//        image: DecorationImage(
//          image: AssetImage('assets/images/football-boy.jpg'),
//          fit: BoxFit.cover,
//        ),
//      ),
      color: Styles.appPrimaryColor,
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 150.0,),
              Center(
                child: Text(Constants.appName,
                  style: Styles.h1_white.copyWith(
                    fontSize: 45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(45,5,45,5),
                child: Divider(color: Colors.grey[300],),
              ),

              Text(Constants.appTagLine,
                style: Styles.p_white.copyWith(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30.0,),
              Container(
                padding: EdgeInsets.all(20),
                height: 250,
                child: Image.asset('assets/launcher_icon.png'),
              ),
              SizedBox(height: 10.0,),
            ],
          ),
        ),
      ),
    );
  }

}
