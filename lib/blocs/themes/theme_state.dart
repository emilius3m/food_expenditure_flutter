part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  final ThemeData themeData;
  final String themeName;

  ThemeState({this.themeData,  this.themeName=""});
}

class ThemeInitial extends ThemeState {
  ThemeInitial(ThemeData themeData, String themeName) : super(themeData : themeData,themeName: themeName);

  @override
  List<Object> get props => [themeData,themeName];
}
