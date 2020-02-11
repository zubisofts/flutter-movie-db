import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/model/credit.dart';
import 'package:flutter_ui_challenge/widgets/movie_cast_item.dart';

class MovieCastList extends StatefulWidget {
  final String title;
  final Credit credit;

  MovieCastList({Key key, this.title, this.credit}) : super(key: key);

  @override
  _MovieCastList createState() => _MovieCastList();
}

class _MovieCastList extends State<MovieCastList> {
  // List<Cast> cast= widget.credit.cast;

  @override
  void initState() {
    // cast = widget.credit.cast;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
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
              child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: widget.credit.cast.length,
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              // print(movies[index].title);
              // Movie movie=movies[index];
              var cast=widget.credit.cast;
              return MovieCastItem(
                cast: cast[index],
              );
            },
          )),
        ],
      ),
    );
  }
}
