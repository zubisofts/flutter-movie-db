import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_ui_challenge/model/favourite.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/model/person.dart';
import 'package:flutter_ui_challenge/model/person_images.dart';
import 'package:flutter_ui_challenge/repository/movie_repository.dart';
import './bloc.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MovieRepository movieRespository = MovieRepository();
  StreamSubscription _movieDbSubscription;

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

    if (event is AddFavouritesEvent) {
      yield* _mapAddFavouriteEventToState(event.movieDetails,event.uid);
    }

    if (event is GetFavouriteEvent) {
      yield* _mapFavouriteEventToState(event.id);
    }

    if (event is GetFavouriteMovieEvent) {
      yield* _mapGetFavouriteMovieState(event.favourite);
    }

    if (event is LoadFavouriteMoviesEvent) {
      yield* _mapLoadFavouriteMoviesState(event.uid);
    }

    if (event is LoadAllFavouritesMovieEvent) {
      yield* _mapLoadAllFavouritesMovieEvent(event.favourites);
    }

    if (event is DeleteFavouriteMovieItem) {
      yield* _mapDeleteFavouriteMovieState(event.movieId);
    }

    if (event is AddWatchListEvent) {
      yield* _mapAddWatchListItemEventToState(event.movieDetails,event.uid);
    }

    if (event is GetWatchListItemEvent) {
      yield* _mapWatchListItemEventEventToState(event.id,event.uid);
    }

    if (event is LoadWatchListMoviesEvent) {
      yield* _mapLoadWatchListState(event.uid);
    }

    if (event is LoadAllWatchListMovieEvent) {
      yield* _mapLoadAllWatchList(event.watchLists);
    }

    if (event is GetWatchListMovieEvent) {
      yield* _mapGetWatchListMovieState(event.watchListItem);
    }

    if (event is DeleteWatchListMovieItem) {
      yield* _mapDeleteWatchListMovieState(event.movieId,event.uid);
    }
  }

  Stream<MoviesState> _fetchMoviesState(
      MovieCat type, int id, int currentPageIndex) async* {
    yield MovieLoadingState();

    var movies = await movieRespository.getMovies(type, id, currentPageIndex);
    // print(type);

    if (movies != null) {
      yield MoviesLoadedState(movies: movies);
    } else {
      yield MovieErrorState();
    }
  }

  Stream<MoviesState> _fetchMoreMoviesState(
      MovieCat type, int id, int currentPageIndex) async* {
    //     yield LoadingState();

    var movies = await movieRespository.getMovies(type, id, currentPageIndex);
    if (movies != null) {
      yield MoreMoviesLoadedState(movies: movies);
    } else {
      yield MovieErrorState();
    }
  }

  Stream<MoviesState> _processMovieDetailsState(int id) async* {
    yield MovieLoadingState();
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
    yield MovieLoadingState();
    Person person = await movieRespository.getPersonDetails(id);
    yield PersonDetialsState(person: person);
  }

  Stream<MoviesState> _mapPersonImagesToState(int id) async* {
    yield MovieLoadingState();
    PersonImages images = await movieRespository.getPersonImages(id);
    yield PersonImagesState(images: images);
  }

  Stream<MoviesState> _mapFavouriteEventToState(int id) async* {
    // if (_movieDbSubscription != null) {
    _movieDbSubscription?.cancel();
    // }

    _movieDbSubscription =
        MovieRepository.withUID("L74vA8gCachsD2WZvRDpBoVR2A42")
            .getFavourite(id)
            .listen((fav) => add(GetFavouriteMovieEvent(favourite: fav)));
  }

  Stream<MoviesState> _mapGetFavouriteMovieState(Favourite favourite) async* {
    yield FavouriteItemState(favourite: favourite);
  }

  Stream<MoviesState> _mapAddFavouriteEventToState(
      MovieDetails movieDetails, String uid) async* {
    MovieRepository.withUID(uid)
        .addToFavorites(movieDetails);
    add(GetFavouriteEvent(id: movieDetails.id));
  }

  Stream<MoviesState> _mapLoadFavouriteMoviesState(String uid) async* {
    _movieDbSubscription?.cancel();
    // }

    _movieDbSubscription = MovieRepository.withUID(uid).favourites.listen(
        (favMovies) => add(LoadAllFavouritesMovieEvent(favourites: favMovies)));
  }

  Stream<MoviesState> _mapLoadAllFavouritesMovieEvent(
      List<MovieDetails> favourites) async* {
    if (favourites != null) yield FavouriteMoviesLoaded(favourites: favourites);
  }

  Stream<MoviesState> _mapDeleteFavouriteMovieState(int movieId) async* {
    await MovieRepository.withUID("L74vA8gCachsD2WZvRDpBoVR2A42")
        .removeFavoritesItem(movieId);

    add(LoadFavouriteMoviesEvent(uid: "L74vA8gCachsD2WZvRDpBoVR2A42"));
  }

  // Event mappings for watchlist
  Stream<MoviesState> _mapAddWatchListItemEventToState(
      MovieDetails movieDetails, String uid) async* {
    await MovieRepository.withUID(uid)
        .addToWatchList(movieDetails);
    add(GetWatchListItemEvent(id: movieDetails.id,uid: uid));
  }

  Stream<MoviesState> _mapWatchListItemEventEventToState(int id, String uid) async* {
    // if (_movieDbSubscription != null) {
    _movieDbSubscription?.cancel();
    // }

    _movieDbSubscription = MovieRepository.withUID(
            uid)
        .getWatchListItem(id)
        .listen((movie) => add(GetWatchListMovieEvent(watchListItem: movie)));
  }

  Stream<MoviesState> _mapGetWatchListMovieState(
      MovieDetails movieDetails) async* {
    yield WatchListItem(watchListItem: movieDetails);
  }

  Stream<MoviesState> _mapLoadWatchListState(String uid) async* {
    _movieDbSubscription?.cancel();
    // }

    _movieDbSubscription = MovieRepository.withUID(uid).watchlist.listen(
        (watchLists) =>
            add(LoadAllWatchListMovieEvent(watchLists: watchLists)));
  }

  Stream<MoviesState> _mapDeleteWatchListMovieState(int movieId, String uid) async* {
    await MovieRepository.withUID(uid)
        .removeWatchListItem(movieId);

    add(LoadWatchListMoviesEvent(uid: uid));
  }

  @override
  Future<void> close() {
    _movieDbSubscription?.cancel();
    return super.close();
  }

  Stream<MoviesState> _mapLoadAllWatchList(
      List<MovieDetails> watchLists) async* {
    yield WatchListMoviesLoaded(watchList: watchLists);
  }
}
