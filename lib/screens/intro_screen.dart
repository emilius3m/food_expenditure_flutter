import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:Spesa/utils/constants.dart';
import 'package:Spesa/utils/styles.dart';
import 'package:Spesa/screens/partials/fake_bottom_buttons.dart';

// import 'home.dart';

class IntroScreenPage extends StatefulWidget {
  @override
  _IntroScreenPageState createState() => _IntroScreenPageState();
}

class _IntroScreenPageState extends State<IntroScreenPage> {
  static final List<String> images = [
    'assets/images/Screenshot_1.png',
    'assets/images/Screenshot_2.png',
    'assets/images/Screenshot_4.png',
  ];

  static final List<String> titles = [
    '',
    'Start ',
    'Enjoy ',
  ];

  static final List<String> descriptions = [
    'Built by E3M',
    'Per semplificare la lista della spesa \n puoi anche scansionare un prodotto e aggiungerlo ',
    'La tua lista sincronizzata su piu dispositivi',
  ];

  final pages = [
    PageViewModel(
      pageColor: Styles.appPrimaryColor,
      // iconImageAssetPath: 'assets/air-hostess.png',
      bubble: Image.asset(images[1]),
      title: Text(titles[0]),
      body: Text(descriptions[0]),
      titleTextStyle: TextStyle(fontFamily: 'Radicals', color: Colors.white),
      bodyTextStyle: Styles.p.copyWith(
        color: Colors.white,
        fontFamily: 'Comfortaa',
        fontStyle: FontStyle.italic,
      ),
      mainImage: Image.asset(
        images[0],
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )
    ),
    PageViewModel(
      pageColor: const Color(0xFF8BC34A),
      iconImageAssetPath: images[2],
      title: Text(titles[1]),
      body: Text(descriptions[1]),
      mainImage: Image.asset(
        images[1],
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'Radicals', color: Colors.white),
      bodyTextStyle: Styles.p.copyWith(
        color: Colors.white,
        fontFamily: 'Comfortaa',
        fontStyle: FontStyle.italic,
      ),
    ),
    PageViewModel(
      pageColor: const Color.fromRGBO(22, 160, 133, 1),
      iconImageAssetPath: images[1],
      title: Text(titles[2]),
      body: Text(descriptions[2]),
      mainImage: Image.asset(
        images[2],
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'Radicals', color: Colors.white),
      bodyTextStyle: Styles.p.copyWith(
        color: Colors.white,
        fontFamily: 'Comfortaa',
        fontStyle: FontStyle.italic,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        color: Colors.red,
        child: Scaffold(
//          persistentFooterButtons: FakeBottomButtons(height: 40.0), // showcase admob banner
          body: IntroViewsFlutter(
            pages,
            showNextButton: true,
            showBackButton: true,
            onTapDoneButton: () {

                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );*/
            },
            pageButtonTextStyles: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

}
