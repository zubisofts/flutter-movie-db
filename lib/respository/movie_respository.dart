import 'dart:convert';

import 'package:flutter_ui_challenge/model/movie.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/model/video_details.dart';
import 'package:flutter_ui_challenge/respository/constants.dart';
import 'package:http/http.dart' as http;

enum MovieCat { Popular, NowPlaying, Upcoming, TopRated, Similar }

class MovieRespository {
  Future<List<Movie>> getMovies(MovieCat type, int id) async {
    String cat = "";
    if (type == MovieCat.NowPlaying) {
      cat = "now_playing";
    } else if (type == MovieCat.Popular) {
      cat = "popular";
    } else if (type == MovieCat.TopRated) {
      cat = "top_rated";
    } else if (type == MovieCat.Similar) {
      String s = "$id/similar";
      cat=s;
    } else {
      cat = "upcoming";
    }
    print("$id/similar");
    try {
      String url = BASE_URL + cat + "?api_key=" + API_KEY;
      // String url="https://api.themoviedb.org/3/movie/now_playing?api_key=3189670a5af406da03f513c311f29341";
      var res = await http
          .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
      var content = json.decode(res.body);
      List data = content['results'];
      // print(data.length);
      // print(_moviesFromJson(data));
      return _moviesFromJson(data);
    } catch (ex) {
      // print(ex.message);
      return null;
    }
  }

  Future<dynamic> getMovieDetails(int id) async {
    try {
      String url = BASE_URL + "$id" + "?api_key=" + API_KEY;
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
      // print("ex");
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
      print(VideoDetails.fromJson(content).results.map((f) => f.name));
      return VideoDetails.fromJson(content);
    } catch (ex) {
      // print("ex");
      // return ex.message;
      return null;
    }
  }

  List<Movie> _moviesFromJson(List list) {
    return list
        .map((f) => Movie(
            id: f['id'],
            title: f['title'],
            overview: f['overview'],
            votes: f['vote_average'],
            genries: f['genre_ids'],
            posterPath: IMAGE_URL + f['poster_path'],
            releaseDate: f['release_date'],
            backdrop: IMAGE_URL + f['backdrop_path']))
        .toList();
  }
}
