import 'package:flutter/material.dart';
import 'package:MovieDB/model/credit.dart';
import 'package:MovieDB/pages/movie_credits_page.dart';
import 'package:MovieDB/widgets/cast_item.dart';

class CastList extends StatefulWidget {
  final String title;
  final Credit credit;

  CastList({Key key, this.title, this.credit}) : super(key: key);

  @override
  _MovieCastList createState() => _MovieCastList();
}

class _MovieCastList extends State<CastList> {
  // List<Cast> cast= widget.credit.cast;

  @override
  void initState() {
    // cast = widget.credit.cast;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 8),
      elevation: 5,
      color: Theme.of(context).canvasColor,
          child: Container(
            margin: EdgeInsets.only(top: 8),
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
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MovieCreditsPage(
                              credit: widget.credit,
                            ))),
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
              
                child:widget.credit.cast!=null ? ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.credit.cast.length,
              // shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                // print(movies[index].title);
                // Movie movie=movies[index];
                var cast = widget.credit.cast;
                return MovieCastItem(
                  cast: cast[index],
                );
              },
            ):SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
