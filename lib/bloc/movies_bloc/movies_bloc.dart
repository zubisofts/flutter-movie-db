import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/respository/movie_respository.dart';
import './bloc.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MovieRespository movieRespository = MovieRespository();

  @override
  MoviesState get initialState => InitialMoviesState();

  @override
  Stream<MoviesState> mapEventToState(
    MoviesEvent event,
  ) async* {
    if (event is LoadMoviesEvent) {
      yield* _fetchMoviesState(event.type, event.id);
    }

    if (event is LoadMovieDetailsEvent) {
      yield* _processMovieDetailsState(event.id);
    }

    // if (event is LoadMovieVideosEvent) {
    //   yield* _processMovieVideosState(event.id);
    // }
  }

  Stream<MoviesState> _fetchMoviesState(MovieCat type, int id) async* {
    yield LoadingState();

    var movies = await movieRespository.getMovies(type, id);
    // print(movies);

    yield MoviesLoadedState(movies: movies);
  }

  Stream<MoviesState> _processMovieDetailsState(int id) async* {
    yield LoadingState();
    MovieDetails movieDetails = await movieRespository.getMovieDetails(id);
    var videoDetails = await movieRespository.getMovieVideos(id);
    var similarMovies = await movieRespository.getMovies(MovieCat.Similar, id);

    yield MovieDetailsReadyState(
        movieDetails: movieDetails,
        videoDetails: videoDetails,
        similarMovies: similarMovies);
  }

// Stream<MoviesState>  _processMovieVideosState(int id) async*{
//   yield LoadingState();
//   var videoDetails = await movieRespository.getMovieVideos(id);
//   yield MovieVideosReadyState(videoDetails:videoDetails);
// }
}
