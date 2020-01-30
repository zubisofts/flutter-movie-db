import 'package:equatable/equatable.dart';

import 'package:flutter_ui_challenge/respository/auth_respository.dart';
import 'package:flutter_ui_challenge/respository/movie_respository.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();
}

class LoadingEvent extends MoviesEvent{
  @override
  List<Object> get props => [];
  
}

class LoadMoviesEvent extends MoviesEvent {

  final MovieCat type;
  final int id;

  LoadMoviesEvent({
    this.type,
    this.id
  });

  @override
  List<Object> get props => [type];
  
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
