import 'package:MovieDB/repository/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:MovieDB/bloc/movies_bloc/bloc.dart';
import 'package:MovieDB/model/movie_details.dart';
import 'package:MovieDB/pages/movie_detail_page.dart';
import 'package:MovieDB/repository/movie_repository.dart';

class WatchListPage extends StatefulWidget {
  final User user;

  WatchListPage({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  _WatchListPageState createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> {
//  GlobalKey<_WatchListFragmentState> watchList =
////  GlobalKey<_WatchListFragmentState>();
  bool isMovie = true;
  bool isTv=false;
  Widget page=Container();

  @override
  void initState() {
      page=new WatchListBuilder(uid: widget.user.uid,mediaType: MediaType.MOVIE,);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watch List"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 16.0,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             InkWell(child: CustomTab(title: "Movie",active:isMovie),onTap: (){
               setState(() {
                 isMovie=true;
                 isTv=false;
                 page=new WatchListBuilder(uid: widget.user.uid,mediaType: MediaType.MOVIE,);
               });
             },),
              SizedBox(width: 16.0,),
              InkWell(child: CustomTab(title: "Tv Shows",active:isTv),onTap: (){
                setState(() {
                  isTv=true;
                  isMovie=false;
                  page=new WatchListBuilder(uid: widget.user.uid,mediaType: MediaType.TV,);
                });
              },),
            ],
          ),
          Expanded(child: page)
        ],
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final String title;
  final active;

  const CustomTab({Key key, this.title,this.active}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
      child: Center(child: Text(title,style: TextStyle(color: Colors.white),)),
      decoration: BoxDecoration(
        color: active?Colors.orange:Colors.grey,
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}

class WatchListBuilder extends StatefulWidget {
  final String uid;
  final MediaType mediaType;

  WatchListBuilder({
    Key key,
    this.uid,
    this.mediaType
  }) : super(key: key);

  @override
  _WatchListBuilderState createState() => _WatchListBuilderState();
}

class _WatchListBuilderState extends State<WatchListBuilder> {
  List movies = [];

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MoviesBloc>(context)
        .add(LoadWatchListMoviesEvent(uid: widget.uid,mediaType: widget.mediaType));
    return BlocBuilder<MoviesBloc, MoviesState>(
      bloc: BlocProvider.of<MoviesBloc>(context),
      builder: (BuildContext context, state) {
        if (state is WatchListMoviesLoaded) {
          movies = state.watchList;
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                color: Theme.of(context).accentColor.withOpacity(0.3),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.watchList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MovieListTile(
                      list: state.watchList[index],
                      uid: widget.uid,
                      mediaType: widget.mediaType,
                    );
                  },
                ),
              ),
            ],
          );
        }
        return Center(
            child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.watch_later,
                  size: MediaQuery.of(context).size.width * 0.6,
                  color: Theme.of(context).accentColor.withOpacity(0.5),
                ),
                Text(
                  "Your Watch List is Empty",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ));
      },
    );
  }
}

class MovieListTile extends StatefulWidget {
  final list;
  final String uid;
  final MediaType mediaType;

  MovieListTile({
    Key key,
    this.list,
    this.uid,
    this.mediaType
  }) : super(key: key);

  @override
  _MovieListTileState createState() => _MovieListTileState();
}

class _MovieListTileState extends State<MovieListTile> {
  final SlidableController _slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: _slidableController,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MovieDetailPage(
                id: widget.list.id,
              )));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: "${IMAGE_URL + widget.list.posterPath}",
                    fit: BoxFit.cover,
                    width: 70,
                    height: 85,
                    placeholder: (context, url) => Center(
                        child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.list.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.list.overview,
                      style: TextStyle(color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          FontAwesome.star,
                          size: 16,
                          color: Colors.orange,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("${widget.list.voteAverage}"),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () async => await MovieRepository.shareImage(
              "Share this movie with",
              "Hi from MovieDB, I would like you to checkout this movie\n${widget.list.title}\m${widget.list.homepage}",
              widget.list.posterPath),
        ),
        IconSlideAction(
          caption: 'Remove',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => BlocProvider.of<MoviesBloc>(context).add(
              DeleteWatchListMovieItem(
                  movieId: widget.list.id, uid: widget.uid,mediaType: widget.mediaType)),
        ),
      ],
    );
  }
}

