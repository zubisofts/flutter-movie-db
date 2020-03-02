part of 'tv_bloc.dart';

abstract class TvEvent extends Equatable {
  const TvEvent();
}

class LoadTvEvent extends TvEvent {
  final TvCat type;
  final int id;
  final currentPageIndex;

  LoadTvEvent({this.type, this.id, this.currentPageIndex});

  @override
  List<Object> get props => [type,id,currentPageIndex];
}

class LoadMoreTvEvent extends TvEvent{
  final TvCat type;
  final int id;
  final currentPageIndex;

  LoadMoreTvEvent({this.type, this.id, this.currentPageIndex});

  @override
  List<Object> get props => [type,id,currentPageIndex];

}

class LoadTvDetailsEvent extends TvEvent {
  final int id;
  LoadTvDetailsEvent({
    this.id,
  });

  @override
  List<Object> get props => [id];
}
