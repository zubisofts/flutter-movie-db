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

class MoreTvLoadedState extends TvState {
  final Tv tvs;

  MoreTvLoadedState({
    this.tvs,
  });

  @override
  List<Object> get props => [tvs];
}

class TvErrorState extends TvState{
  @override
  List<Object> get props => [];

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

class TvSeasonDetailsState extends TvState {
  final TvSeasonDetails tvSeasonDetails;
  TvSeasonDetailsState({
    this.tvSeasonDetails
  });

  @override
  List<Object> get props => [tvSeasonDetails];
}