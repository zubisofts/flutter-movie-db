import 'package:equatable/equatable.dart';
import 'package:flutter_ui_challenge/model/movie.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
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
  List<Object> get props => null;
}

class MoviesLoadedState extends MoviesState {
  final List<Movie> movies;
  MoviesLoadedState({
    this.movies,
  });

  @override
  List<Object> get props => [movies];
}

class MovieDetailsReadyState extends MoviesState {
  final MovieDetails movieDetails;
  final VideoDetails videoDetails;
  final List<Movie> similarMovies;

  MovieDetailsReadyState({
    this.movieDetails,
    this.videoDetails,
    this.similarMovies
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
