import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ui_challenge/model/credit.dart';
import 'package:flutter_ui_challenge/model/favourite.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/model/movie_images.dart';
import 'package:flutter_ui_challenge/model/movie_list.dart' as movieResult;
import 'package:flutter_ui_challenge/model/movie_list.dart';
import 'package:flutter_ui_challenge/model/person.dart';
import 'package:flutter_ui_challenge/model/person_images.dart';
import 'package:flutter_ui_challenge/model/video_details.dart' as videoResult;
import 'package:flutter_ui_challenge/repository/constants.dart';
import 'package:http/http.dart' as http;

enum MovieCat { Popular, NowPlaying, Upcoming, TopRated, Similar, Search }

class MovieRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userReference =
      Firestore.instance.collection("flutter_ui_challenge");
  String uid;

  MovieRepository();

  MovieRepository.withUID(String id) {
    this.uid = id;
  }

  Future<dynamic> getMovies(MovieCat type, int id, int pageIndex) async {
    String cat = "";

    if (type == MovieCat.NowPlaying) {
      cat = "now_playing";
    } else if (type == MovieCat.Popular) {
      cat = "popular";
    } else if (type == MovieCat.TopRated) {
      cat = "top_rated";
    } else if (type == MovieCat.Similar) {
      cat = "$id/similar";
//      print("$cat");
    } else {
      cat = "upcoming";
    }
    String url = "";
    try {
      if (type == MovieCat.Similar) {
        url = '$BASE_URL$cat?api_key=$API_KEY';
      } else {
        url = '$BASE_URL$cat?api_key=$API_KEY&page=$pageIndex';
      }
      // String url ='https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341';
      // String url="https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);

      movieResult.MovieList movieList = movieResult.MovieList.fromJson(content);
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
      String url =
          'https://api.themoviedb.org/3/search/movie?api_key=$API_KEY&language=en-US&query=$query&include_adult=false';
      // print(url);
      // String url ='https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341';
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);

      movieResult.MovieList movieList = movieResult.MovieList.fromJson(content);

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
      List list = content['cast'];
      var movieList = list.map((f) => Results.fromJson(f)).toList();

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
      var movieImages = MovieImages.fromMap(content);

      return movieImages;
    } catch (ex) {
      print(ex.message);
      return null;
    }
  }

  Future<dynamic> getMovieDetails(int id, {int page = 1}) async {
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
      return PersonImages.fromJson(content);
    } catch (ex) {
      print(ex.message);
      // return ex.message;
      return null;
    }
  }

  static Future<void> shareImage(String title, String text, path) async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(IMAGE_URL + path));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file(title, "image.jpg", bytes, 'image/jpg', text: text);
    } catch (ex) {
      print(ex);
    }
    // Share.text(title,"hdfjhil","text");
  }

  static Future<void> shareWatchList(List<MovieDetails> movies) async {
    print(movies.length);
    try {
      String n = "Hi there, checkout my cool Watch List from MovieDB app:\n";
      for (var item in movies) {
        n+="*"+item.title+"*\n";
      }
      n+="You can download this app at www.procity.com";
      Share.text("Share this Watch List", n, "text/plain");
    } catch (ex) {
      print(ex);
    }
    // Share.text(title,"hdfjhil","text");
  }

  Future<void> addToWatchList(MovieDetails movieDetails) async {
    return await userReference
        .document("data")
        .collection("movies_data")
        .document('watch_list')
        .collection(uid)
        .document('${movieDetails.id}')
        .setData({'${movieDetails.id}': movieDetails.toJson()});
  }

  Future<void> addToFavorites(MovieDetails movieDetails) async {
    return await userReference
        .document("data")
        .collection("movies_data")
        .document('favourites')
        .collection(uid)
        .document('${movieDetails.id}')
        .setData({'${movieDetails.id}': movieDetails.toJson()});
  }

  Stream<List<MovieDetails>> get favourites {
    return userReference
        .document("data")
        .collection("movies_data")
        .document('favourites')
        .collection(uid)
        .snapshots()
        .map(_mapDocumentToData);
  }

  Stream<List<MovieDetails>> get watchlist {
    return userReference
        .document("data")
        .collection("movies_data")
        .document('watch_list')
        .collection(uid)
        .snapshots()
        .map(_mapDocumentToData);
  }

  Stream<Favourite> getFavourite(int movieId) {
    return userReference
        .document("data")
        .collection("movies_data")
        .document('favourites')
        .collection(uid)
        .document('$movieId')
        .snapshots()
        .map((doc) => doc.exists
            ? Favourite(id: doc.data["movieId"], uid: doc.data["uid"])
            : null);
  }

  Stream<MovieDetails> getWatchListItem(int movieId) {
    return userReference
        .document("data")
        .collection("movies_data")
        .document('watch_list')
        .collection(uid)
        .document('$movieId')
        .snapshots()
        .map((doc) => doc.exists
            ? MovieDetails.fromJson(doc.data['${doc.documentID}'])
            : null);
  }

  Future<void> removeFavoritesItem(int id) async {
    return await userReference
        .document("data")
        .collection("movies_data")
        .document('favourites')
        .collection(uid)
        .document('$id')
        .delete();
  }

  Future<void> removeWatchListItem(int id) async {
    return await userReference
        .document("data")
        .collection("movies_data")
        .document('watch_list')
        .collection(uid)
        .document('$id')
        .delete();
  }

  List<MovieDetails> _mapDocumentToData(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) => MovieDetails.fromJson(doc.data[doc.documentID]))
        .toList();
  }
}
