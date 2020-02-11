import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/bloc.dart';
import 'package:flutter_ui_challenge/pages/movie_list_page.dart';
import 'package:flutter_ui_challenge/respository/movie_respository.dart';
import 'package:flutter_ui_challenge/widgets/movie_item_horizontal.dart';

class ListRow extends StatefulWidget {
  final String title;
  final MovieCat type;
  final int id;

  ListRow({Key key, this.title, this.type, this.id}) : super(key: key);

  @override
  _ListRowState createState() => _ListRowState();
}

class _ListRowState extends State<ListRow> {
  MoviesBloc _moviesBloc = MoviesBloc();

  @override
  void initState() {
    super.initState();
    _moviesBloc.add(LoadMoviesEvent(type: widget.type, id: widget.id,));
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      // width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>MoviesListPage(title:widget.title,id:widget.id,type: widget.type,)
                    ));
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Center(
                      child: Text(
                        "View All",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<MoviesBloc, MoviesState>(
              bloc: _moviesBloc,
              builder: (BuildContext context, MoviesState state) {
                if (state is LoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is MoviesLoadedState) {
                  var movieList = state.movies;
                  var movies = movieList.results;
                  if (movies != null) {
                    if (movies.length > 0) {
                      if (movies.length > 10) {
                        movies = movies.sublist(0, 8);
                      }
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: movies.length,
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          // print(movies[index].title);
                          // Movie movie=movies[index];
                          return MovieItemHorizontal(movie: movies[index]);
                        },
                      );
                    }
                  } else {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Nothing was found!"),
                        RaisedButton(
                          child: Text("Retry"),
                          onPressed: () => _moviesBloc.add(LoadMoviesEvent(
                              id: widget.id, type: widget.type)),
                        )
                      ],
                    ));
                  }
                }

                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("An error occured!"),
                    RaisedButton(
                      child: Text("Retry"),
                      onPressed: () => _moviesBloc.add(
                          LoadMoviesEvent(id: widget.id, type: widget.type)),
                    )
                  ],
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
