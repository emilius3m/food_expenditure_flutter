import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Spesa/colors.dart';



enum AppTheme {
    Light,
    Midnight,
    //BlueDark,
    PureBlack }

final appThemeData = {

    AppTheme.Light:Themes._defaultTheme(),
    //AppTheme.BlueLight: ThemeData( backgroundColor: Colors.white,brightness: Brightness.light , primaryColor: Colors.white),
    //AppTheme.BlueDark: ThemeData( brightness: Brightness.dark , primaryColor: Colors.blue[700]),
    AppTheme.Midnight: Themes._midnightTheme(),
    AppTheme.PureBlack: Themes._pureBlackTheme(),
    //AppTheme.GreenLight: ThemeData( brightness: Brightness.light , primaryColor: Colors.green),
    //AppTheme.GreenDark: ThemeData( brightness: Brightness.dark , primaryColor: Colors.green[700]),
};












class Themes {
    Themes._();

    static ThemeData getDarkTheme() =>  _pureBlackTheme();
        //: _midnightTheme();

    static ThemeData _midnightTheme() {
        const _textStyle = TextStyle(
            fontSize: 16,
            color: Colors.white,
        );
        return ThemeData(
            brightness: Brightness.dark,
            canvasColor:E3MColors.primary,
            primaryColor: E3MColors.secondary,
            accentColor: E3MColors.accent,
            highlightColor: E3MColors.secondary,
            cardColor: E3MColors.secondary,
            splashColor: E3MColors.splash,
            dialogBackgroundColor: E3MColors.secondary,
            dividerColor: E3MColors.accent.withAlpha(0),
            dividerTheme: DividerThemeData(
                color: E3MColors.accent,
                indent: 100.0,
                endIndent: 100.0,
            ),
            iconTheme: IconThemeData(
                color: Colors.white,
            ),
            unselectedWidgetColor: Colors.white,
            textTheme: TextTheme(
                bodyText1: _textStyle,
                bodyText2: _textStyle,
                headline1: _textStyle,
                headline2: _textStyle,
                headline3: _textStyle,
                headline4: _textStyle,
                headline5: _textStyle,
                headline6: _textStyle,
                button: _textStyle,
                caption: _textStyle,
                subtitle1: _textStyle,
                subtitle2: _textStyle,
                overline: _textStyle,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
        );
    }

    static ThemeData _defaultTheme() {
        const _textStyle = TextStyle(
            //color: Colors.white,
            fontSize: 16,
            color:Color(0xFF18D191)
        );



        return ThemeData(
            brightness: Brightness.light,
            //canvasColor:E3MColors.primary,
            primaryColor: Colors.white,
            accentColor: Color(0xFF18D191),
            highlightColor: Colors.white,
            //cardColor: E3MColors.secondary,
            //splashColor: E3MColors.splash,
            //dialogBackgroundColor: E3MColors.secondary,
            //dividerColor: E3MColors.accent.withAlpha(0),
            /*dividerTheme: DividerThemeData(
                color: E3MColors.accent,
                indent: 100.0,
                endIndent: 100.0,
            ),*/
            primarySwatch: Colors.blue,
            canvasColor: Colors.white,
            iconTheme: IconThemeData(
                color: Color(0xFF18D191),
            ),
            unselectedWidgetColor: Colors.white,
            textTheme: TextTheme(
                bodyText1: _textStyle,
                bodyText2: TextStyle(color: Color(0xFF18D191), fontSize: 14, fontWeight: FontWeight.bold),
                headline1: _textStyle,
                headline2: TextStyle(color: Colors.teal, fontSize: 14, fontWeight: FontWeight.bold),
                headline3: _textStyle,
                headline4: _textStyle,
                headline5: _textStyle,
                headline6: _textStyle,
                button: _textStyle,
                caption: _textStyle,
                subtitle1: _textStyle,
                subtitle2: _textStyle,
                overline: _textStyle,
            ),
            //visualDensity: VisualDensity.adaptivePlatformDensity,
        );
    }


    static ThemeData _pureBlackTheme() {
        const _textStyle = TextStyle(
            fontSize: 16,
            color: Colors.white,
        );
        return ThemeData(
            brightness: Brightness.dark,
            canvasColor: Colors.black,
            primaryColor: Colors.black,
            accentColor: Colors.white,
            highlightColor: E3MColors.secondary,
            cardColor: Colors.black,
            splashColor: E3MColors.splash,
            dialogBackgroundColor: Colors.black,
            dividerColor: E3MColors.accent.withAlpha(0),
            dividerTheme: DividerThemeData(
                color: E3MColors.accent,
                indent: 72.0,
                endIndent: 72.0,
            ),
            iconTheme: IconThemeData(
                color: Colors.white,
            ),
            unselectedWidgetColor: Colors.white,
            textTheme: TextTheme(
                bodyText1: _textStyle,
                bodyText2: _textStyle,
                headline1: _textStyle,
                headline2: _textStyle,
                headline3: _textStyle,
                headline4: _textStyle,
                headline5: _textStyle,
                headline6: _textStyle,
                button: _textStyle,
                caption: _textStyle,
                subtitle1: _textStyle,
                subtitle2: _textStyle,
                overline: _textStyle,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
        );
    }
}
