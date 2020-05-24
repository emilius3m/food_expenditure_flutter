import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:Spesa/blocs/tab/tab.dart';
import 'package:Spesa/models/models.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  @override
  AppTab get initialState => AppTab.spesa;

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
