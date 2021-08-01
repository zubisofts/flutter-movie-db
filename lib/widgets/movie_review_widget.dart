import 'package:MovieDB/bloc/movies_bloc/bloc.dart';
import 'package:MovieDB/model/movie_details.dart';
import 'package:MovieDB/model/movie_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
// import 'package:getflutter/getflutter.dart';

class MovieReviewWidget extends StatefulWidget {
  final MovieDetails movieDetails;

  const MovieReviewWidget({Key key, this.movieDetails}) : super(key: key);

  @override
  _MovieReviewWidgetState createState() => _MovieReviewWidgetState();
}

class _MovieReviewWidgetState extends State<MovieReviewWidget> {

  MoviesBloc bloc = MoviesBloc();

  @override
  void initState() {
    bloc.add(GetMovieReviews(movieId: widget.movieDetails.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    print("Id:${movieDetails.id}");
    return GFAccordion(
      title: "Reviews",
      contentBackgroundColor:Theme.of(context).canvasColor,
      textStyle: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      collapsedIcon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.black,
      ),
      expandedIcon: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.black,
      ),
      contentChild: BlocBuilder<MoviesBloc, MoviesState>(
        bloc: bloc,
        builder: (BuildContext context, MoviesState state) {
          if (state is LoadingState) {
            print("Loading");
            return Center(
              child: SpinKitRipple(
                color: Theme.of(context).accentColor,
              ),
            );
          }

          if (state is MovieReviewsLoaded) {
            return _buildReviewsList(state.movieReview, context);
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReviewsList(MovieReview movieReview, BuildContext context) {
    List<Result> review = movieReview.results;
    if (movieReview.results.length > 5) {
      review = review.sublist(0, 5);
    }
    return Column(
      children: <Widget>[
        ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: review.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return ReviewItemWidget(context: context, result: review[index]);
          },
        ),
        movieReview.results.length > 3
            ? FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => FullMovieReview(
                            title: widget.movieDetails.title,
                            reviews: movieReview,
                          )));
                },
                textColor: Theme.of(context).accentColor,
                child: Text("See all Reviews..."))
            : SizedBox.shrink(),
      ],
    );
  }
}

class ReviewItemWidget extends StatefulWidget {
  const ReviewItemWidget({
    Key key,
    @required this.context,
    @required this.result,
  }) : super(key: key);

  final BuildContext context;
  final Result result;

  @override
  _ReviewItemWidgetState createState() => _ReviewItemWidgetState();
}

class _ReviewItemWidgetState extends State<ReviewItemWidget> {
  bool readMore=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        onTap: (){
          setState(() {
            readMore=!readMore;
          });
        },
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).accentColor,
          child: Center(
            child: Text(
              widget.result.author.substring(0, 1),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        title: Text(
          widget.result.author,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.result.content,
          maxLines: readMore?1000:3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class FullMovieReview extends StatelessWidget {
  final String title;
  final MovieReview reviews;

  const FullMovieReview({Key key, this.title, this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title:Reviews'),
      ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 16.0,),
            Expanded(
              child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: reviews.results.length,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
              return ReviewItemWidget(
                  context: context, result: reviews.results[index]);
      },
    ),
            ),
          ],
        ));
  }
}
