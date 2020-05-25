part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ThemeChanged extends ThemeEvent {
  final AppTheme theme;
  final String themeName;


  ThemeChanged({@required this.theme,@required this.themeName});

  @override
  // TODO: implement props
  List<Object> get props => [theme,themeName];

}
