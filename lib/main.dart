import 'package:MovieDB/bloc/tv_bloc/tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MovieDB/bloc/app_bloc/app_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/bloc.dart';
import 'package:MovieDB/bloc/movies_bloc/bloc.dart';
import 'package:MovieDB/pages/home.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (BuildContext context) => AppBloc(),
        ),
        BlocProvider<MoviesBloc>(
          create: (BuildContext context) => MoviesBloc(),
        ),
        BlocProvider<TvBloc>(
          create: (BuildContext context) => TvBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(),
        )
      ],
      child: MyApp(),
    )
        // BlocProvider<AppBloc>(
        //     child: MyApp(),
        //     create: (context) => AppBloc(),
        //   )
        );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AppBloc>(context).add(GetThemeValueEvent());
    BlocProvider.of<AuthBloc>(context).add(ListenToLoginEvent());
    return BlocBuilder<AppBloc, AppState>(
      builder: (BuildContext context, AppState state) {
        // BlocProvider.of(context).add(GetThemeValueEvent());

        bool value = false;

        if (state is GetThemeValueState) {
          value = state.value;
        }
        if (state is ThemeChangedState) {
          value = state.value;
        }

        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: value
              ? ThemeData(
                  brightness: Brightness.dark,
                  fontFamily: "Poppins-Regular",

                )
              : ThemeData(brightness: Brightness.light, fontFamily: "Poppins-Regular")
                  .copyWith(
                      primaryColor: Colors.orange, accentColor: Colors.orange),
          home: Home(),
        );
      },
    );
  }
}
