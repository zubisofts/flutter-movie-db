import 'package:flutter/material.dart';

final String API_KEY = "3189670a5af406da03f513c311f29341";
final String MOVIE_BASE_URL="https://api.themoviedb.org/3/movie/";
final String TV_BASE_URL="https://api.themoviedb.org/3/tv/";
final TMDB_URL="https://api.themoviedb.org/3/";
final String IMAGE_URL="https://image.tmdb.org/t/p/w600_and_h900_bestv2";
final String THEME_PREF_KEY='theme_key';

GlobalKey<ScaffoldState>homeScaffoldKey=GlobalKey<ScaffoldState>();

ThemeData getLightTheme(BuildContext context){
  return Theme.of(context).copyWith(brightness: Brightness.light,primaryColor: Colors.blue,);
}

ThemeData getDarkTheme(BuildContext context){
  return Theme.of(context).copyWith(brightness: Brightness.dark,primaryColor: Colors.blue,);
}