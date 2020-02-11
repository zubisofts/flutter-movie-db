part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
}

class AppInitial extends AppState {
  @override
  List<Object> get props => [];
}

class ThemeChangedState extends AppState {
  final bool value;
  ThemeChangedState({
    this.value,
  });

  @override
  List<Object> get props => [value];
}

class GetThemeValueState extends AppState {
  final bool value;
  GetThemeValueState({
    this.value,
  });

  @override
  List<Object> get props => [value];
}

class ListToggleState extends AppState {
  final bool isVertical;
  ListToggleState({
    this.isVertical,
  });
  @override
  List<Object> get props => [isVertical];
}

class ListScrollState extends AppState {

  final bool load;
  ListScrollState({
    this.load,
  });

  @override
  List<Object> get props => [load];
  
}
