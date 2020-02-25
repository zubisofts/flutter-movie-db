import 'package:equatable/equatable.dart';
import 'package:flutter_ui_challenge/model/credit.dart';
import 'package:flutter_ui_challenge/model/favourite.dart';
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

class MovieLoadingState extends MoviesState {
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

class FavouritesState extends MoviesState {
  final List<Favourite> favourites;
  FavouritesState({
    this.favourites,
  });

  @override
  List<Object> get props => [favourites];
}

class FavouriteItemState extends MoviesState {
  final Favourite favourite;
  FavouriteItemState({
    this.favourite,
  });

  @override
  List<Object> get props => [favourite];
}


class FavouriteMoviesLoaded extends MoviesState {
  final List<MovieDetails> favourites;
  FavouriteMoviesLoaded({
    this.favourites,
  });

  @override
  List<Object> get props => [favourites];
}



// class WatchListState extends MoviesState {
//   final List<MovieDetails> watchList;
//   WatchListState({
//     this.watchList,
//   });

//   @override
//   List<Object> get props => [watchList];
// }

class WatchListItem extends MoviesState {
  final MovieDetails watchListItem;
  WatchListItem({
    this.watchListItem,
  });

  @override
  List<Object> get props => [watchListItem];
}


class WatchListMoviesLoaded extends MoviesState {
  final List<MovieDetails> watchList;
  WatchListMoviesLoaded({
    this.watchList,
  });

  @override
  List<Object> get props => [watchList];
}


class MovieErrorState extends MoviesState {

  @override
  List<Object> get props => [];
}
