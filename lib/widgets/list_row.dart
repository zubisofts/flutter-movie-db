
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/bloc.dart';
import 'package:flutter_ui_challenge/respository/movie_respository.dart';
import 'package:flutter_ui_challenge/widgets/movie_list_item.dart';

class ListRow extends StatefulWidget {
  final String title;
  final MovieCat type;
  final int id;

  ListRow({
    Key key,
    this.title,
    this.type,
    this.id
  }) : super(key: key);

  @override
  _ListRowState createState() => _ListRowState();
}

class _ListRowState extends State<ListRow> {
  MoviesBloc _moviesBloc = MoviesBloc();

  @override
  void initState() {
    _moviesBloc.add(LoadMoviesEvent(type: widget.type,id: widget.id));
    super.initState();
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
                Text(
                  "View All",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.greenAccent),
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
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.movies.length,
                    // shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      // print(movies[index].title);
                      // Movie movie=movies[index];
                      return MovieListItem(movie: state.movies[index]);
                    },
                  );
                }

                return Text("");
              },
            ),
          ),
        ],
      ),
    );
  }
}
