import 'package:equatable/equatable.dart';

import 'package:flutter_ui_challenge/model/favourite.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/repository/movie_repository.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();
}

class LoadingEvent extends MoviesEvent {
  @override
  List<Object> get props => [];
}

class LoadMoviesEvent extends MoviesEvent {
  final MovieCat type;
  final int id;
  final currentPageIndex;

  LoadMoviesEvent({this.currentPageIndex, this.type, this.id});

  @override
  List<Object> get props => [type,id,currentPageIndex];
}

class LoadMoreMoviesEvent extends MoviesEvent {
  final MovieCat type;
  final int id;
  final currentPageIndex;

  LoadMoreMoviesEvent({this.currentPageIndex, this.type, this.id});

  @override
  List<Object> get props => [type,id,currentPageIndex];
}

class LoadMovieDetailsEvent extends MoviesEvent {
  final int id;
  LoadMovieDetailsEvent({
    this.id,
  });

  @override
  List<Object> get props => [id];
}

class LoadMovieVideosEvent extends MoviesEvent {
  final int id;
  LoadMovieVideosEvent({
    this.id,
  });

  @override
  List<Object> get props => [id];
}

class PersonDetailsEvent extends MoviesEvent {
  final int id;
  PersonDetailsEvent({
    this.id,
  });

  @override
  List<Object> get props => [id];
}

class GetPersonImagesEvent extends MoviesEvent {
  final int id;
  GetPersonImagesEvent({
    this.id,
  });

  @override
  List<Object> get props => [id];
}


class AddFavouritesEvent extends MoviesEvent {
  final MovieDetails movieDetails;
  final String uid;
  AddFavouritesEvent({
    this.movieDetails,
    this.uid
  });

  @override
  List<Object> get props => [movieDetails];
}

class GetFavouriteEvent extends MoviesEvent {
  final int id;
  final String uid;
  GetFavouriteEvent({
    this.id,
    this.uid
  });

  @override
  List<Object> get props => [id];
}
class GetFavouriteMovieEvent extends MoviesEvent {
  final Favourite favourite;
  GetFavouriteMovieEvent({
    this.favourite,
  });

  @override
  List<Object> get props => [favourite];
}

class LoadFavouriteMoviesEvent extends MoviesEvent {
  final String uid;
  LoadFavouriteMoviesEvent({
    this.uid,
  });

  @override
  List<Object> get props => [uid];
}

class LoadAllFavouritesMovieEvent extends MoviesEvent {
  final List<MovieDetails> favourites;
  LoadAllFavouritesMovieEvent({
    this.favourites,
  });

  @override
  List<Object> get props => [favourites];
}


class AddWatchListEvent extends MoviesEvent {
  final MovieDetails movieDetails;
  final String uid;
  AddWatchListEvent({
    this.movieDetails,
    this.uid
  });

  @override
  List<Object> get props => [movieDetails,uid];
}

class GetWatchListItemEvent extends MoviesEvent {
  final int id;
  final String uid;
  GetWatchListItemEvent({
    this.id,
    this.uid
  });

  @override
  List<Object> get props => [id];
}
class GetWatchListMovieEvent extends MoviesEvent {
  final MovieDetails watchListItem;
  GetWatchListMovieEvent({
    this.watchListItem,
  });

  @override
  List<Object> get props => [watchListItem];
}

class LoadWatchListMoviesEvent extends MoviesEvent {
  final String uid;
  LoadWatchListMoviesEvent({
    this.uid,
  });

  @override
  List<Object> get props => [uid];
}

class LoadAllWatchListMovieEvent extends MoviesEvent {
  final List<MovieDetails> watchLists;
  LoadAllWatchListMovieEvent({
    this.watchLists,
  });

  @override
  List<Object> get props => [watchLists];
}

class DeleteFavouriteMovieItem extends MoviesEvent {
  final int movieId;
  DeleteFavouriteMovieItem({
    this.movieId,
  });
  @override
  List<Object> get props => [movieId];

}

class DeleteWatchListMovieItem extends MoviesEvent {
  final int movieId;
  final String uid;
  DeleteWatchListMovieItem({
    this.movieId,
    this.uid
  });
  @override
  List<Object> get props => [movieId];

}
