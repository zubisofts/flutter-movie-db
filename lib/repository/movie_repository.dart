import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:MovieDB/model/genre.dart';
import 'package:MovieDB/model/movie_review.dart';
import 'package:MovieDB/model/tv_details.dart';
import 'package:MovieDB/model/tv_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:MovieDB/model/credit.dart';
import 'package:MovieDB/model/movie_details.dart';
import 'package:MovieDB/model/movie_images.dart';
import 'package:MovieDB/model/movie_list.dart' as movieResult;
import 'package:MovieDB/model/movie_list.dart';
import 'package:MovieDB/model/person.dart';
import 'package:MovieDB/model/person_images.dart';
import 'package:MovieDB/model/video_details.dart' as videoResult;
import 'package:MovieDB/repository/constants.dart';
import 'package:http/http.dart' as http;

enum MovieCat { Popular, NowPlaying, Upcoming, TopRated, Similar, Search }

class MovieRepository {
  // FirebaseAuth _auth = FirebaseAuth.instance;
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
        url = '$MOVIE_BASE_URL$cat?api_key=$API_KEY';
      } else {
        url = '$MOVIE_BASE_URL$cat?api_key=$API_KEY&page=$pageIndex';
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

  Future<dynamic> discover(String sortString, List<int> genreIds,String y, MediaType mediaType,int pageIndex) async {
    String media=mediaType==MediaType.MOVIE?'movie':'tv';
    String sortQuery=sortString==''?'':'&sort_by=$sortString';
    String genres='';
    String year=y==''?'':'&year=$y';
    if(genreIds.length>0){
      genreIds.forEach((f){
        genres+='$f ';
      });
      genres='&with_genres=$genres';
    }
    String url='${TMDB_URL}discover/$media?api_key=$API_KEY&language=en-US$sortQuery$year$genres';
    // print(url);
    try {
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'},);
      var content = json.decode(res.body);

print(res.request.url);
      return mediaType==MediaType.MOVIE? movieResult.MovieList.fromJson(content):tvFromJson(res.body);

    } catch (ex) {
      print(ex.message);
      return null;
    }
  }

  Future<List<Results>> getMovieCredits(int id) async {
    try {
      String url = TMDB_URL + "person/$id/movie_credits?api_key=$API_KEY";
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
      String url = "$MOVIE_BASE_URL$id/images?api_key=$API_KEY";
      // print(url);
      // String url ='https://api.themoviedb.org/3/movie/530915/images?api_key=3189670a5af406da03f513c311f29341';
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
//      print(res.body);
      var movieImages = MovieImages.fromMap(content);

      return movieImages;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<dynamic> getMovieDetails(int id, {int page = 1}) async {
    try {
      String url = MOVIE_BASE_URL + '$id?api_key=$API_KEY&page=$page';
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



  Future<videoResult.VideoDetails> getVideos(int id,
      {int type, int sn, int epn}) async {
    try {
      String url;
      if (type == 1) {
        url = TMDB_URL + "tv/$id/season/$sn/videos?api_key=" + API_KEY;
      } else if (type == 2) {
        url = TMDB_URL +
            "tv/$id/season/$sn/episode/$epn/videos?api_key=" +
            API_KEY;
      } else {
        url = MOVIE_BASE_URL + "$id/videos?api_key=" + API_KEY;
      }

//      String url = MOVIE_BASE_URL + "$id" + "/videos?api_key=" + API_KEY;
      // String url="https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      // List data = content['results'];
      print(url);
      // print(_moviesFromJson(data));
      // print(VideoDetails.fromJson(content).results.map((f) => f.name));
      return videoResult.VideoDetails.fromJson(content);
    } catch (ex) {
      print(ex.message);
      // return ex.message;
      return null;
    }
  }

  Future<Credit> getCredits(int id, {int type, int sn, int epn}) async {
    try {
      String url;
      if (type == 1) {
        url = TMDB_URL + "tv/$id/season/$sn/credits?api_key=" + API_KEY;
      } else if (type == 2) {
        url = TMDB_URL +
            "tv/$id/season/$sn/episode/$epn/credits?api_key=" +
            API_KEY;
      } else {
        url = MOVIE_BASE_URL + "$id/credits?api_key=" + API_KEY;
      }
      // String url="https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      // List data = content['results'];
//       print(url);
      // print(_moviesFromJson(data));
      // print(Credit.fromJson(content));

      return Credit.fromJson(content);
    } catch (ex) {
      print(ex.message);
      // return ex.message;
      return null;
    }
  }

  Future<Genry> getGenres(MediaType type) async {
    try {
      String url;
      if(type==MediaType.MOVIE) {
        url= "${TMDB_URL}genre/movie/list?api_key=" + API_KEY;
    }else{
        url= "${TMDB_URL}genre/tv/list?api_key=" + API_KEY;
      }
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      // List data = content['results'];
//       print(url);
//       print(content);
      // print(_moviesFromJson(data));
      // print(Credit.fromJson(content));

      return Genry.fromMap(content);
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

  Future<void> addToWatchList(
      dynamic movieDetails, MediaType mediaType) async {
    print('Watchlist=${movieDetails.id}');
    return await userReference
        .document("data")
        .collection('watch_list')
        .document(mediaType == MediaType.MOVIE ? "movie" : "tv")
        .collection(uid)
        .document('${movieDetails.id}')
        .setData({'${movieDetails.id}':mediaType==MediaType.MOVIE? movieDetails.toJson():tvDetailsToMap(movieDetails)});
  }

  Future<void> addToFavorites(dynamic details, MediaType mediaType) async {
//    print(details);
    return await userReference
        .document("data")
        .collection('favourites')
        .document(mediaType == MediaType.MOVIE ? "movie" : "tv")
        .collection(uid)
        .document('${details.id}')
        .setData({
      '${details.id}': mediaType == MediaType.MOVIE
          ? details.toJson()
          : tvDetailsToMap(details)
    });
  }

  Stream<List> favourites(MediaType mediaType) {
    return userReference
        .document("data")
        .collection('favourites')
        .document(mediaType == MediaType.MOVIE ? "movie" : "tv")
        .collection(uid)
        .snapshots()
        .map(mediaType == MediaType.MOVIE
            ? _mapMovieDocumentToData
            : _mapTvDocumentToData);
  }

  Stream<List> watchlist(MediaType mediaType) {
    return userReference
        .document("data")
        .collection('watch_list')
        .document(mediaType == MediaType.MOVIE ? "movie" : "tv")
        .collection(uid)
        .snapshots()
        .map(mediaType == MediaType.MOVIE
            ? _mapMovieDocumentToData
            : _mapTvDocumentToData);
  }

  Stream getFavourite(int movieId, MediaType mediaType) {
    return userReference
        .document("data")
        .collection('favourites')
        .document(mediaType == MediaType.MOVIE ? "movie" : "tv")
        .collection(uid)
        .document('$movieId')
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        print(TvDetails.fromMap(doc.data['${doc.documentID}']).name);
        return mediaType == MediaType.MOVIE
            ? MovieDetails.fromJson(doc.data['${doc.documentID}'])
            : TvDetails.fromMap(doc.data['${doc.documentID}']);
      } else {
        return null;
      }
    });
  }

  Stream getWatchListItem(int mediaId, MediaType mediaType) {
    return userReference
        .document("data")
        .collection('watch_list')
        .document(mediaType == MediaType.MOVIE ? "movie" : "tv")
        .collection(uid)
        .document('$mediaId')
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return mediaType == MediaType.MOVIE
            ? MovieDetails.fromJson(doc.data['${doc.documentID}'])
            : tvDetailsFromMap(doc.data['${doc.documentID}']);
      } else {
        return null;
      }
    });

  }

  Future<void> removeFavoritesItem(int id, MediaType mediaType) async {
    return await userReference
        .document("data")
        .collection('favourites')
        .document(mediaType == MediaType.MOVIE ? "movie" : "tv")
        .collection(uid)
        .document('$id')
        .delete();
  }

  Future<void> removeWatchListItem(int id, MediaType mediaType) async {
    return await userReference
        .document("data")
        .collection('watch_list')
        .document(mediaType == MediaType.MOVIE ? "movie" : "tv")
        .collection(uid)
        .document('$id')
        .delete();
  }

  List _mapMovieDocumentToData(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) => MovieDetails.fromJson(doc.data[doc.documentID]))
        .toList();
  }

  List _mapTvDocumentToData(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) => TvDetails.fromMap(doc.data[doc.documentID]))
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
