import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:MovieDB/model/movie_review.dart';
import 'package:MovieDB/model/tv_details.dart';
import 'package:MovieDB/model/tv_list_model.dart';
import 'package:MovieDB/model/tv_season_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:MovieDB/model/credit.dart';
import 'package:MovieDB/model/movie_details.dart';
import 'package:MovieDB/model/person.dart';
import 'package:MovieDB/model/person_images.dart';
import 'package:MovieDB/model/video_details.dart' as videoResult;
import 'package:MovieDB/repository/constants.dart';
import 'package:http/http.dart' as http;

enum TvCat { AiringToday, OnTheAir, Latest, Popular, TopRated, Similar, Search }

class TVRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection("flutter_ui_challenge");
  String uid;

  TVRepository();

  TVRepository.withUID(String id) {
    this.uid = id == null ? 'empty' : id;
  }

  Future<Tv> getTvShows(TvCat type, int id, int pageIndex) async {
    String cat = "";

    if (type == TvCat.AiringToday) {
      cat = "airing_today";
    } else if (type == TvCat.OnTheAir) {
      cat = "on_the_air";
    } else if (type == TvCat.Popular) {
      cat = "popular";
    } else if (type == TvCat.Latest) {
      cat = "latest";
    } else if (type == TvCat.TopRated) {
      cat = "top_rated";
    } else if (type == TvCat.Similar) {
      cat = "$id/similar";
//      print("$cat");
    } else {
      cat = "upcoming";
    }
    String url = "";
    try {
      if (type == TvCat.Similar) {
        url = '$TV_BASE_URL$cat?api_key=$API_KEY';
      } else {
        url = '$TV_BASE_URL$cat?api_key=$API_KEY&page=$pageIndex';
      }
      // String url ='https://api.themoviedb.org/3/tv/popular?api_key=3189670a5af406da03f513c311f29341&page=1';
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
//      var content = json.decode(res.body);

      var tv = tvFromJson(res.body);
      // debugPrint(res.body);
      // List data = content['results'];
      // int page=content['page'];
      // print('The page is $page');
      // print(data.length);
      // print(_moviesFromJson(data));
      // return _moviesFromJson(data,page);

      return tv;
    } on HttpException catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<Tv> searchTv(String query) async {
    try {
      String url =
          '${TMDB_URL}search/tv?api_key=$API_KEY&language=en-US&query=$query&include_adult=false';
      // print(url);
      // String url ='https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341';
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);

      var tv = tvFromJson(content);

      return tv;
    } catch (ex) {
      print(ex.message);
      return null;
    }
  }

  Future<Credit> getTvCredits(int id) async {
    try {
      String url = TMDB_URL + "tv/$id/credits?api_key=$API_KEY";
      // print(url);
      // String url ='https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341';
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
//      print(content);

      return Credit.fromJson(content);
//      List list = content['cast'];
//      var movieList = list.map((f) => Results.fromJson(f)).toList();
//
//      return movieList;
    } catch (ex) {
      print("TvCredits$ex.message");
      return null;
    }
  }

  Future<TvSeasonDetails> getTvSeasonDetails(int id, int number) async {
    try {
      String url = TMDB_URL + "tv/$id/season/$number?api_key=$API_KEY";
      // print(url);
      // String url ='https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341';
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
//      var content = json.decode(res.body);
//      print(content);

      return tvSeasonDetailsFromJson(res.body);
//      List list = content['cast'];
//      var movieList = list.map((f) => Results.fromJson(f)).toList();
//
//      return movieList;
    } catch (ex) {
      print("TvCredits$ex.message");
      return null;
    }
  }

  Future<dynamic> getTvDetails(int id, {int page = 1}) async {
    try {
      String url = TMDB_URL + 'tv/$id?api_key=$API_KEY&page=$page';
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      // List data = content['results'];
      // print(content);
      // print(_moviesFromJson(data));
      // print(MovieDetails.fromJson(content).genres.map((f) => f.name));
//      print(res.body);
      return tvDetailsFromJson(res.body);
    } catch (ex) {
      print("TvDetails$ex.message");
      // return ex.message;
      return null;
    }
  }

  Future<dynamic> getTvVideos(int id) async {
    try {
      String url = TMDB_URL + "tv/$id" + "/videos?api_key=" + API_KEY;
      // String url="https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
//      print(content);
      return videoResult.VideoDetails.fromJson(content);
    } catch (ex) {
      print("TvVideos$ex.message");
      // return ex.message;
      return null;
    }
  }

  Future<dynamic> getMovieCast(int id) async {
    try {
      String url = TMDB_URL + "/tv$id/credits?api_key=" + API_KEY;
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
      String url = TMDB_URL + "person/$id?api_key=$API_KEY";
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
      String url = TMDB_URL + "person/$id/images?api_key=$API_KEY";
      // String url="https://api.themoviedb.org/3/person/287/images?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      // List data = content['results'];
//      print(url);
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
//    print(movies.length);
    try {
      String n = "Hi there, checkout my cool Watch List from MovieDB app:\n";
      for (var item in movies) {
        n += "*" + item.title + "*\n";
      }
      n += "You can download this app at www.procity.com";
      Share.text("Share this Watch List", n, "text/plain");
    } catch (ex) {
      print(ex);
    }
    // Share.text(title,"hdfjhil","text");
  }

  Future<void> addToWatchList(MovieDetails movieDetails) async {
    return await userReference
        .doc("data")
        .collection("movies_data")
        .doc('watch_list')
        .collection(uid)
        .doc('${movieDetails.id}')
        .set({'${movieDetails.id}': movieDetails.toJson()});
  }

  Future<void> addToFavorites(MovieDetails movieDetails) async {
    return await userReference
        .doc("data")
        .collection("movies_data")
        .doc('favourites')
        .collection(uid)
        .doc('${movieDetails.id}')
        .set({'${movieDetails.id}': movieDetails.toJson()});
  }

  Stream<List<MovieDetails>> get favourites {
    return userReference
        .doc("data")
        .collection("movies_data")
        .doc('favourites')
        .collection(uid)
        .snapshots()
        .map(_mapdocToData);
  }

  Stream<List<MovieDetails>> get watchlist {
    return userReference
        .doc("data")
        .collection("movies_data")
        .doc('watch_list')
        .collection(uid)
        .snapshots()
        .map(_mapdocToData);
  }

  Stream<MovieDetails> getFavourite(int movieId) {
    return userReference
        .doc("data")
        .collection("movies_data")
        .doc('favourites')
        .collection(uid)
        .doc('$movieId')
        .snapshots()
        .map((doc) => doc.exists ? MovieDetails.fromJson(doc.data()) : null);
  }

  Stream<MovieDetails> getWatchListItem(int movieId) {
    return userReference
        .doc("data")
        .collection("movies_data")
        .doc('watch_list')
        .collection(uid)
        .doc('$movieId')
        .snapshots()
        .map((doc) => doc.exists ? MovieDetails.fromJson(doc.data()) : null);
  }

  Future<void> removeFavoritesItem(int id) async {
    return await userReference
        .doc("data")
        .collection("movies_data")
        .doc('favourites')
        .collection(uid)
        .doc('$id')
        .delete();
  }

  Future<void> removeWatchListItem(int id) async {
    return await userReference
        .doc("data")
        .collection("movies_data")
        .doc('watch_list')
        .collection(uid)
        .doc('$id')
        .delete();
  }

  List<MovieDetails> _mapdocToData(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => MovieDetails.fromJson(doc.data()))
        .toList();
  }

  Future<MovieReview> getMovieReviews(int id) async {
    try {
      String url = MOVIE_BASE_URL + "$id/reviews?api_key=$API_KEY";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
//      var content = json.decode(res.body);
      // List data = content['results'];
//      print(url);
//      print(movieReview.results.last.toMap());
      return movieReviewFromJson(res.body);
    } catch (ex) {
      print(ex.message);
      // return ex.message;
      return null;
    }
  }
}
