import 'package:equatable/equatable.dart';
import 'package:flutter_ui_challenge/model/credit.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/model/movie_list.dart';
import 'package:flutter_ui_challenge/model/person.dart';
import 'package:flutter_ui_challenge/model/person_images.dart';
import 'package:flutter_ui_challenge/model/video_details.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();
}

class InitialMoviesState extends MoviesState {
  @override
  List<Object> get props => [];
}

class LoadingState extends MoviesState {
  @override
  List<Object> get props => [];
}

class MoviesLoadedState extends MoviesState {
  final MovieList movies;
  MoviesLoadedState({
    this.movies,
  });

  @override
  List<Object> get props => [movies];
}

class MoreMoviesLoadedState extends MoviesState {
  final MovieList movies;
  MoreMoviesLoadedState({
    this.movies,
  });

  @override
  List<Object> get props => [movies];
}

class MovieDetailsReadyState extends MoviesState {
  final MovieDetails movieDetails;
  final VideoDetails videoDetails;
  final MovieList similarMovies;
  final Credit credit;

  MovieDetailsReadyState({
    this.movieDetails,
    this.videoDetails,
    this.similarMovies,
    this.credit,
  });

  @override
  List<Object> get props => [movieDetails,videoDetails,similarMovies];
}

class MovieVideosReadyState extends MoviesState {
  final VideoDetails videoDetails;
  MovieVideosReadyState({
    this.videoDetails,
  });

  @override
  List<Object> get props => [videoDetails];
}

class PersonDetialsState extends MoviesState {
  final Person person;
  PersonDetialsState({
    this.person,
  });

  @override
  List<Object> get props => [person];
}

class PersonImagesState extends MoviesState {
  final PersonImages images;
  PersonImagesState({
    this.images,
  });

  @override
  List<Object> get props => [images];
}
