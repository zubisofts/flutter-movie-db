import 'package:MovieDB/pages/loading_text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MovieDB/bloc/movies_bloc/bloc.dart';
import 'package:MovieDB/model/person_images.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:shimmer/shimmer.dart';

// class ImageList extends StatefulWidget {
//   final int id;

//   ImageList({Key key, this.id}) : super(key: key);

//   @override
//   _ImageListState createState() => _ImageListState();
// }

class ImageList extends StatefulWidget {
  final int id;

  ImageList({this.id});

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  MoviesBloc _moviesBloc = MoviesBloc();

  @override
  void initState() {
    super.initState();
    _moviesBloc.add(GetPersonImagesEvent(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      // width: 200,
      child: BlocBuilder<MoviesBloc, MoviesState>(
        bloc: _moviesBloc,
        builder: (BuildContext context, MoviesState state) {
          if (state is MovieLoadingState) {
            return Center(child: LoadingTextWidget(baseColor: Colors.red,highlightColor: Colors.yellow,text: "Loading...",));
          }
          if (state is PersonImagesState) {
            var personImages = state.images;
            var images = personImages.profiles;
            if (images != null) {
              if (images.length > 0) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: images.length,
                  // shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    // print(movies[index].title);
                    // Movie movie=movies[index];
                    return _buildImage(images[index]);
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
                    onPressed: () =>
                        _moviesBloc.add(GetPersonImagesEvent(id: widget.id)),
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
                onPressed: () => _moviesBloc.add(GetPersonImagesEvent(id: widget.id)),
              )
            ],
          ));
        },
      ),
    );
  }

  Widget _buildImage(Profiles image) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: CachedNetworkImage(
        imageUrl: "${IMAGE_URL + image.filePath}",
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
            child: Shimmer.fromColors(
                child: Container(
                  height: 150,
                  width: 120,
                ),
                baseColor: Colors.grey[600],
                highlightColor: Colors.grey[700])),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
