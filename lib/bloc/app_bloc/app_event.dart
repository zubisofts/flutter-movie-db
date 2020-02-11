part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class ChangeThemeEvent extends AppEvent {
  final bool value;
  ChangeThemeEvent({
    this.value,
  });

  @override
  List<Object> get props => [value];
}

class GetThemeValueEvent extends AppEvent {
  GetThemeValueEvent();

  @override
  List<Object> get props => [];
}

class ListToggleEvent extends AppEvent {
  final bool isVertical;
  ListToggleEvent({
    this.isVertical,
  });
  @override
  List<Object> get props => [isVertical];
}

class ListScrollEvent extends AppEvent {
final bool load;
  ListScrollEvent({
    this.load,
  });
  @override
  List<Object> get props => [load];
  
}
