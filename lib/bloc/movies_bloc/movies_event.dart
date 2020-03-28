import 'package:MovieDB/repository/constants.dart';
import 'package:equatable/equatable.dart';

import 'package:MovieDB/model/movie_details.dart';
import 'package:MovieDB/repository/movie_repository.dart';

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
  final details;
  final String uid;
  final MediaType mediaType;
  AddFavouritesEvent({
    this.details,
    this.uid,
    this.mediaType
  });

  @override
  List<Object> get props => [details,uid,mediaType];
}

class GetFavouriteEvent extends MoviesEvent {
  final int id;
  final String uid;
  final MediaType mediaType;
  GetFavouriteEvent({
    this.id,
    this.uid,
    this.mediaType
  });

  @override
  List<Object> get props => [id,uid,mediaType];
}
class GetFavouriteMovieEvent extends MoviesEvent {
  final favourite;
  GetFavouriteMovieEvent({
    this.favourite,
  });

  @override
  List<Object> get props => [favourite];
}

class LoadFavouriteMoviesEvent extends MoviesEvent {
  final String uid;
  final MediaType mediaType;
  LoadFavouriteMoviesEvent({
    this.uid,
    this.mediaType
  });

  @override
  List<Object> get props => [uid];
}

class LoadAllFavouritesMovieEvent extends MoviesEvent {
  final List favourites;
  LoadAllFavouritesMovieEvent({
    this.favourites,
  });

  @override
  List<Object> get props => [favourites];
}


class AddWatchListEvent extends MoviesEvent {
  final movieDetails;
  final String uid;
  final MediaType mediaType;
  AddWatchListEvent({
    this.movieDetails,
    this.uid,
    this.mediaType
  });

  @override
  List<Object> get props => [movieDetails,uid,mediaType];
}

class GetWatchListItemEvent extends MoviesEvent {
  final int id;
  final String uid;
  final MediaType mediaType;
  GetWatchListItemEvent({
    this.id,
    this.uid,
    this.mediaType
  });

  @override
  List<Object> get props => [id,mediaType];
}
class GetWatchListMovieEvent extends MoviesEvent {
  final watchListItem;
  GetWatchListMovieEvent({
    this.watchListItem,
  });

  @override
  List<Object> get props => [watchListItem];
}

class LoadWatchListMoviesEvent extends MoviesEvent {
  final String uid;
  final MediaType mediaType;
  LoadWatchListMoviesEvent({
    this.uid,
    this.mediaType
  });

  @override
  List<Object> get props => [uid,mediaType,mediaType];
}

class LoadAllWatchListMovieEvent extends MoviesEvent {
  final List watchLists;
  final MediaType mediaType;
  LoadAllWatchListMovieEvent({
    this.watchLists,
    this.mediaType
  });

  @override
  List<Object> get props => [watchLists,mediaType];
}

class DeleteFavouriteMovieItem extends MoviesEvent {
  final int movieId;
  final String uid;
  final MediaType mediaType;
  DeleteFavouriteMovieItem({
    this.movieId,
    this.uid,
    this.mediaType
  });
  @override
  List<Object> get props => [movieId,uid,mediaType];

}

class DeleteWatchListMovieItem extends MoviesEvent {
  final int movieId;
  final String uid;
  final MediaType mediaType;
  DeleteWatchListMovieItem({
    this.movieId,
    this.uid,
    this.mediaType
  });
  @override
  List<Object> get props => [movieId,uid,mediaType];

}

class GetMovieReviews extends MoviesEvent {
  final int movieId;
  GetMovieReviews({
    this.movieId,
  });
  @override
  List<Object> get props => [movieId];

}

class GetGenres extends MoviesEvent {
  final MediaType mediaType;
  GetGenres({
    this.mediaType,
  });
  @override
  List<Object> get props => [mediaType];

}
class Discover extends MoviesEvent {
  final MediaType mediaType;
  final List<int> genres;
  final String sortQuery;
  final String year;
  Discover({
    this.mediaType,
    this.genres,
    this.sortQuery,
    this.year
  });
  @override
  List<Object> get props => [mediaType,genres,sortQuery,year];

}
