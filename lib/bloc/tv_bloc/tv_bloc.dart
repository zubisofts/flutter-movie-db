import 'dart:async';

import 'package:MovieDB/model/credit.dart';
import 'package:MovieDB/model/tv_details.dart';
import 'package:MovieDB/model/tv_list_model.dart';
import 'package:MovieDB/model/tv_season_details.dart';
import 'package:MovieDB/model/video_details.dart';
import 'package:MovieDB/repository/tv_series_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tv_event.dart';

part 'tv_state.dart';

class TvBloc extends Bloc<TvEvent, TvState> {
  TVRepository tvRepository = TVRepository();

  TvBloc() : super(TvInitial());

  @override
  Stream<TvState> mapEventToState(
    TvEvent event,
  ) async* {
    if (event is LoadTvEvent) {
      yield* _fetchTvState(event.type, event.id, event.currentPageIndex);
    }

    if (event is LoadMoreTvEvent) {
      yield* _fetchMoreTvState(event.type, event.id, event.currentPageIndex);
    }

    if (event is LoadTvDetailsEvent) {
      yield* _processTvDetailsState(event.id);
    }

    if (event is LoadTvSeasonDetailsEvent) {
      yield* _processSeasonDetailEvent(event.id, event.seasonNo);
    }
  }

  Stream<TvState> _fetchTvState(
      TvCat type, int id, int currentPageIndex) async* {
    yield TvLoadingState();

    var tvs = await tvRepository.getTvShows(type, id, currentPageIndex);

    if (tvs != null) {
      yield TvLoadedState(tvs: tvs);
    } else {
      yield TvErrorState();
    }
  }

  Stream<TvState> _fetchMoreTvState(
      TvCat type, int id, int currentPageIndex) async* {
    //     yield LoadingState();

    var tvs = await tvRepository.getTvShows(type, id, currentPageIndex);
    if (tvs != null) {
      yield MoreTvLoadedState(tvs: tvs);
    } else {
      yield TvErrorState();
    }
  }

  Stream<TvState> _processTvDetailsState(int id) async* {
    yield TvLoadingState();
    TvDetails tvDetails = await tvRepository.getTvDetails(id);
    var videoDetails = await tvRepository.getTvVideos(id);
    var similarTvs = await tvRepository.getTvShows(TvCat.Similar, id, 1);
    var tvCredit = await tvRepository.getTvCredits(id);
//
//    print(tvDetails);
//    print(videoDetails);
//    print(similarTvs);
//    print(tvCredit);
    if (tvDetails != null)
      yield TvDetailsReadyState(
          tvDetails: tvDetails,
          videoDetails: videoDetails,
          similarTvs: similarTvs,
          credit: tvCredit);
  }

  Stream<TvState> _processSeasonDetailEvent(int tvId, int seasonNo) async* {
    yield TvLoadingState();
    TvSeasonDetails tvSeasonDetails =
        await tvRepository.getTvSeasonDetails(tvId, seasonNo);
    if (tvSeasonDetails != null) {
      yield TvSeasonDetailsState(tvSeasonDetails: tvSeasonDetails);
    } else {
      yield TvErrorState();
    }
  }
}
