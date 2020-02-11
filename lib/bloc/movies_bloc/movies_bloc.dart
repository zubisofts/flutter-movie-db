import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/model/person.dart';
import 'package:flutter_ui_challenge/model/person_images.dart';
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
      yield* _fetchMoviesState(event.type, event.id, event.currentPageIndex);
    }

    if (event is LoadMovieDetailsEvent) {
      yield* _processMovieDetailsState(event.id);
    }

    if (event is LoadMoreMoviesEvent) {
      yield* _fetchMoreMoviesState(
          event.type, event.id, event.currentPageIndex);
    }

    if (event is PersonDetailsEvent) {
      yield* _mapPersonDetailsToState(event.id);
    }

    if (event is GetPersonImagesEvent) {
      yield* _mapPersonImagesToState(event.id);
    }
  }

  Stream<MoviesState> _fetchMoviesState(
      MovieCat type, int id, int currentPageIndex) async* {
    yield LoadingState();

    var movies = await movieRespository.getMovies(type, id, currentPageIndex);
    // print(movies);

    yield MoviesLoadedState(movies: movies);
  }

  Stream<MoviesState> _fetchMoreMoviesState(
      MovieCat type, int id, int currentPageIndex) async* {
    // yield LoadingState();

    var movies = await movieRespository.getMovies(type, id, currentPageIndex);
    // print(movies);

    yield MoreMoviesLoadedState(movies: movies);
  }

  Stream<MoviesState> _processMovieDetailsState(int id) async* {
    yield LoadingState();
    MovieDetails movieDetails = await movieRespository.getMovieDetails(id);
    var videoDetails = await movieRespository.getMovieVideos(id);
    var similarMovies =
        await movieRespository.getMovies(MovieCat.Similar, id, 1);
    var movieCredit = await movieRespository.getMovieCast(id);

    yield MovieDetailsReadyState(
        movieDetails: movieDetails,
        videoDetails: videoDetails,
        similarMovies: similarMovies,
        credit: movieCredit);
  }

  Stream<MoviesState> _mapPersonDetailsToState(int id) async* {
    yield LoadingState();
    Person person = await movieRespository.getPersonDetails(id);
    yield PersonDetialsState(person: person);
  }

   Stream<MoviesState> _mapPersonImagesToState(int id) async* {
    yield LoadingState();
    PersonImages images = await movieRespository.getPersonImages(id);
    yield PersonImagesState(images: images);
  }

// Stream<MoviesState>  _processMovieVideosState(int id) async*{
//   yield LoadingState();
//   var videoDetails = await movieRespository.getMovieVideos(id);
//   yield MovieVideosReadyState(videoDetails:videoDetails);
// }
}
