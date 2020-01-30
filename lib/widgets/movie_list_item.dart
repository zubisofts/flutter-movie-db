
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/model/movie.dart';
import 'package:flutter_ui_challenge/pages/movie_detail_page.dart';
import 'package:flutter_ui_challenge/respository/constants.dart';

class MovieListItem extends StatelessWidget {

  const MovieListItem({
    Key key,
    @required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>MovieDetailPage(movie:movie)));
      },
          child: Container(
        margin: EdgeInsets.all(10.0),
        // height: 250,
        width: 150,
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex:8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(movie.posterPath,width:200,fit: BoxFit.cover,))),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${movie.title}',style: TextStyle(fontWeight: FontWeight.w500),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    Row(
                      children: <Widget>[
                        Icon(Icons.star,color: Colors.orange,),
                        Text('${movie.votes}')
                      ],
                    )
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }
}
