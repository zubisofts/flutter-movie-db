import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/respository/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {

  AppBloc(){
    _getThemeValueEventToState();
  }
  
  @override
  AppState get initialState => AppInitial();

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {

    // Theme event and state
    if (event is ChangeThemeEvent) {
      yield* _setThemeEventToState(event.value);
    }

     if (event is GetThemeValueEvent) {
      yield*  _getThemeValueEventToState();
    }

    if(event is ListScrollEvent){
      yield ListScrollState(load: !event.load);
    }

    // List toggle events and states
    if(event is ListToggleEvent){
      // print(event.isVertical);
      yield ListToggleState(isVertical: event.isVertical);
    }
  }

  Stream<AppState> _setThemeEventToState(bool value) async* {
    final pref = await SharedPreferences.getInstance();
    var x = await pref.setBool(THEME_PREF_KEY, value);
    

    if (x) {
      var themeValue =pref.getBool(THEME_PREF_KEY);
      yield ThemeChangedState(value: themeValue);
      // print("Theme set:$themeValue");
      //  yield GetThemeValueState(value: x);
      }
  }

  Stream<AppState> _getThemeValueEventToState() async* {
    final pref = await SharedPreferences.getInstance();
    
       var x = pref.getBool(THEME_PREF_KEY) ?? false;
      //  print("Fetched theme:$x");

      yield GetThemeValueState(value: x);
  }
}
