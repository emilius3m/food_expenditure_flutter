import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:Spesa/theme.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'theme_event.dart';

part 'theme_state.dart';


class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  //@override
  //ThemeState get initialState =>

  /*@override
  ThemeState get initialState   {

      return ThemeInitial(appThemeData[AppTheme.Light],"Light");
  }
  */
  ThemeState get initialState => super.initialState ?? ThemeInitial(appThemeData[AppTheme.Midnight],"Midnight");

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
      String isLightMode = json["isLightMode"] as String;
      if (isLightMode == "Light") {
          return ThemeInitial(appThemeData[AppTheme.Light],"Light");
      } else if (isLightMode == "PureBlack") {
          return ThemeInitial(appThemeData[AppTheme.PureBlack],"PureBlack");
      } else return ThemeInitial(appThemeData[AppTheme.Midnight],"Midnight");
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) {
      return {"isLightMode": state.themeName.toString()};
  }


  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ThemeChanged) {
      yield ThemeInitial(appThemeData[event.theme],event.themeName);
    }
  }
}
