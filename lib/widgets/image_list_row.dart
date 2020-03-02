import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MovieDB/bloc/movies_bloc/bloc.dart';
import 'package:MovieDB/model/person_images.dart';
import 'package:MovieDB/repository/constants.dart';

// class ImageList extends StatefulWidget {
//   final int id;

//   ImageList({Key key, this.id}) : super(key: key);

//   @override
//   _ImageListState createState() => _ImageListState();
// }

class ImageList extends StatelessWidget {

final int id;
  ImageList({this.id});
  MoviesBloc _moviesBloc = MoviesBloc();

  @override
  Widget build(BuildContext context) {
    _moviesBloc.add(GetPersonImagesEvent(id: id));
    return Container(
      height: 150,
      // width: 200,
      child: BlocBuilder<MoviesBloc, MoviesState>(
        bloc: _moviesBloc,
        builder: (BuildContext context, MoviesState state) {
          if (state is MovieLoadingState) {
            return Center(child: CircularProgressIndicator());
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
                        _moviesBloc.add(GetPersonImagesEvent(id: id)),
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
                onPressed: () =>
                    _moviesBloc.add(GetPersonImagesEvent(id: id)),
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
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
