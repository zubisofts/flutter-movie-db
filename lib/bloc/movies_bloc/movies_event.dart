import 'package:equatable/equatable.dart';

import 'package:flutter_ui_challenge/respository/movie_respository.dart';

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
