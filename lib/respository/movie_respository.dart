import 'dart:convert';

import 'package:flutter_ui_challenge/model/credit.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/model/movie_images.dart';
import 'package:flutter_ui_challenge/model/movie_list.dart' as movieResult;
import 'package:flutter_ui_challenge/model/movie_list.dart';
import 'package:flutter_ui_challenge/model/person.dart';
import 'package:flutter_ui_challenge/model/person_images.dart';
import 'package:flutter_ui_challenge/model/video_details.dart' as videoResult;
import 'package:flutter_ui_challenge/respository/constants.dart';
import 'package:http/http.dart' as http;

enum MovieCat { Popular, NowPlaying, Upcoming, TopRated, Similar,Search }

class MovieRespository {
  Future<dynamic> getMovies(MovieCat type, int id,int pageIndex) async {
    String cat = "";
    if (type == MovieCat.NowPlaying) {
      cat = "now_playing";
    } else if (type == MovieCat.Popular) {
      cat = "popular";
    } else if (type == MovieCat.TopRated) {
      cat = "top_rated";
    } else if (type == MovieCat.Similar) {
      String s = "$id/similar";
      print("$pageIndex for similar");
      cat=s;
    }else {
      cat = "upcoming";
    }
    
    try {
      String url = '$BASE_URL$cat?api_key=$API_KEY&page=$pageIndex';
      // print(url);
      // String url ='https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341';
      // String url="https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);

      movieResult.MovieList movieList=movieResult.MovieList.fromJson(content);
      // print(movieList.toJson());
      // List data = content['results'];
      // int page=content['page'];
      // print('The page is $page');
      // print(data.length);
      // print(_moviesFromJson(data));
      // return _moviesFromJson(data,page);

      return movieList;
    } catch (ex) {
      print(ex.message);
      return null;
    }
  }

  Future<dynamic> searchMovie(String query) async {

    try {
      String url = 'https://api.themoviedb.org/3/search/movie?api_key=$API_KEY&language=en-US&query=$query&include_adult=false';
      // print(url);
      // String url ='https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341';
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);

      movieResult.MovieList movieList=movieResult.MovieList.fromJson(content);

      return movieList;
    } catch (ex) {
      print(ex.message);
      return null;
    }
  }

  Future<List<Results>> getMovieCredits(int id) async {

    try {
       String url = TMMDB_URL + "person/$id/movie_credits?api_key=$API_KEY";
      // print(url);
      // String url ='https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341';
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      List list=content['cast'];
      var movieList = list.map((f)=>Results.fromJson(f)).toList();
      
      return movieList;
    } catch (ex) {
      print(ex.message);
      return null;
    }
  }

Future<MovieImages> getMovieImages(int id) async {

    try {
       String url = "$BASE_URL$id/images?api_key=$API_KEY";
      // print(url);
      // String url ='https://api.themoviedb.org/3/movie/530915/images?api_key=3189670a5af406da03f513c311f29341';
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      var movieImages=MovieImages.fromMap(content);
      
      return movieImages;
    } catch (ex) {
      print(ex.message);
      return null;
    }
  }


  Future<dynamic> getMovieDetails(int id, {int page=1}) async {
    try {
      String url = BASE_URL + '$id?api_key=$API_KEY&page=$page';
      // String url="https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      // List data = content['results'];
      // print(content);
      // print(_moviesFromJson(data));
      // print(MovieDetails.fromJson(content).genres.map((f) => f.name));
      return MovieDetails.fromJson(content);
    } catch (ex) {
      print(ex.message);
      // return ex.message;
      return null;
    }
  }

  Future<dynamic> getMovieVideos(int id) async {
    try {
      String url = BASE_URL + "$id" + "/videos?api_key=" + API_KEY;
      // String url="https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      // List data = content['results'];
      // print(content);
      // print(_moviesFromJson(data));
      // print(VideoDetails.fromJson(content).results.map((f) => f.name));
      return videoResult.VideoDetails.fromJson(content);
    } catch (ex) {
      print(ex.message);
      // return ex.message;
      return null;
    }
  }

  Future<dynamic> getMovieCast(int id) async {
    try {
      String url = BASE_URL + "$id/credits?api_key=" + API_KEY;
      // String url="https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      // List data = content['results'];
      // print(content);
      // print(_moviesFromJson(data));
      // print(Credit.fromJson(content));

      return Credit.fromJson(content);
    } catch (ex) {
      print(ex.message);
      // return ex.message;
      return null;
    }
  }

  Future<dynamic> getPersonDetails(int id) async {
    try {
      String url = TMMDB_URL + "person/$id?api_key=$API_KEY";
      // String url="https://api.themoviedb.org/3/person/2888?api_key=3189670a5af406da03f513c311f29341&language=en-US";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      // List data = content['results'];
      // print(url);
      // print(_moviesFromJson(data));
      // print(personFromJson(content));

      return Person.fromMap(content);
    } catch (ex) {
      print(ex.message);
      // return ex.message;
      return null;
    }
  }

 Future<dynamic> getPersonImages(int id) async {
    try {
      String url = TMMDB_URL + "person/$id/images?api_key=$API_KEY";
      // String url="https://api.themoviedb.org/3/person/287/images?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      // List data = content['results'];
      print(url);
      // print(_moviesFromJson(data));
      // print(personFromJson(content));

      return PersonImages.fromJson(content);
    } catch (ex) {
      print(ex.message);
      // return ex.message;
      return null;
    }
  }
  
}
