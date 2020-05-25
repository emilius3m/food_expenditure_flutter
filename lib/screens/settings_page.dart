import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Spesa/theme.dart';
import 'package:Spesa/blocs/themes/theme_bloc.dart';

class SettingsPage extends StatelessWidget {
  final String title;
  SettingsPage(this.title);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //title: Text('$title > Settings'),
        actions: <Widget>[],
      ),
      body: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
              Card(
                  color: appThemeData[AppTheme.Light].primaryColor,
                  child: ListTile(
                      title: Text(
                          'Light',
                          style: appThemeData[AppTheme.Light].textTheme.bodyText1,
                      ),
                      onTap: () {
                          BlocProvider.of<ThemeBloc>(context)
                              .add(ThemeChanged(theme: AppTheme.Light,themeName:"Light"));
                      }
                  ),
              ),
              Card(
                  color: appThemeData[AppTheme.Midnight].primaryColor,
                  child: ListTile(
                      title: Text(
                          ' Midnight',
                          style: appThemeData[AppTheme.Midnight].textTheme.bodyText1,
                      ),
                      onTap: () {
                          BlocProvider.of<ThemeBloc>(context)
                              .add(ThemeChanged(theme: AppTheme.Midnight,themeName:"Midnight"));
                      }
                  ),
              ),
              Card(
              color: appThemeData[AppTheme.PureBlack].primaryColor,
                    child: ListTile(
                        title: Text(
                            'PureBlack (AMOLED)',
                            style: appThemeData[AppTheme.PureBlack].textTheme.bodyText1,
                        ),
                        onTap: () {
                            BlocProvider.of<ThemeBloc>(context)
                            .add(ThemeChanged(theme: AppTheme.PureBlack,themeName:"PureBlack"));
                        }
                        ),
              )
          ]

      ),
    );


     /* ListView.builder(
        itemCount: AppTheme.values.length,
        padding: EdgeInsets.all(8.0),
          items:
        itemBuilder: (context, index) {
          final itemAppTheme = AppTheme.values[index];
          return Card(
            color: appThemeData[itemAppTheme].primaryColor,
            child: ListTile(
                title: Text(
                  '${itemAppTheme.index} - ${itemAppTheme.toString()}',
                  style: appThemeData[itemAppTheme].textTheme.bodyText1,
                ),
                onTap: () {
                  BlocProvider.of<ThemeBloc>(context)
                      .add(ThemeChanged(theme: itemAppTheme));
                }),
          );
        },
      ),*/

  }
}
