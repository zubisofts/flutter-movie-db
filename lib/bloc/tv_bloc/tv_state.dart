part of 'tv_bloc.dart';

abstract class TvState extends Equatable {
  const TvState();
}

class TvInitial extends TvState {
  @override
  List<Object> get props => [];
}

class TvLoadingState extends TvState {
  @override
  List<Object> get props => [];
}

class LoadingState extends TvState {
  @override
  List<Object> get props => [];
}

class TvLoadedState extends TvState {
  final Tv tvs;

  TvLoadedState({
    this.tvs,
  });

  @override
  List<Object> get props => [tvs];
}

class MoreMoviesLoadedState extends TvState {
  final Tv tvs;

  MoreMoviesLoadedState({
    this.tvs,
  });

  @override
  List<Object> get props => [tvs];
}

class TvErrorState extends TvState{
  @override
  List<Object> get props => [];

}

class WatchListItem extends TvState{

  final Result watchListItem;

  WatchListItem({this.watchListItem});

  @override
  List<Object> get props => [watchListItem];

}


class TvDetailsReadyState extends TvState {
  final TvDetails tvDetails;
  final VideoDetails videoDetails;
  final Tv similarTvs;
  final Credit credit;

  TvDetailsReadyState({
    this.tvDetails,
    this.videoDetails,
    this.similarTvs,
    this.credit,
  });

  @override
  List<Object> get props => [tvDetails, videoDetails, similarTvs,credit];
}