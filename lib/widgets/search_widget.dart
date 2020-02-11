import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/model/movie.dart';
import 'package:flutter_ui_challenge/pages/movie_list_page.dart';
import 'package:flutter_ui_challenge/respository/movie_respository.dart';

class SearchWidget extends SearchDelegate<Movie> {

@override
  String get searchFieldLabel => "Search Movie";

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query='';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: new MovieRespository().searchMovie(query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } 
            return MovieListLayout(
              // type: widget.type,
              // id: widget.id,
              movieList: snapshot.data,
              isVertical: true,
            );
        },
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
  
}
