import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/bloc.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/movies_bloc.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/movies_event.dart';
import 'package:flutter_ui_challenge/model/movie_list.dart';
import 'package:flutter_ui_challenge/model/person.dart';
import 'package:flutter_ui_challenge/respository/constants.dart';
import 'package:flutter_ui_challenge/respository/movie_respository.dart';
import 'package:flutter_ui_challenge/widgets/curved_path_bg.dart';
import 'package:flutter_ui_challenge/widgets/image_list_row.dart';
import 'package:flutter_ui_challenge/widgets/movie_item_horizontal.dart';
import 'package:intl/intl.dart';

class PersonDetailsPage extends StatefulWidget {
  final int id;

  PersonDetailsPage({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  MoviesBloc _moviesBloc = MoviesBloc();

  @override
  void initState() {
    // print("Person id:${widget.id}");
    _moviesBloc.add(PersonDetailsEvent(id: widget.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MoviesBloc, MoviesState>(
          bloc: _moviesBloc,
          builder: (BuildContext context, state) {
            if (state is PersonDetialsState) {
              var person = state.person;
              if (person != null) {
                return DetailsWidget(person: person);
              }
            }
            if (state is LoadingState) {
              return Center(
                child:
                    SpinKitRotatingCircle(color: Theme.of(context).accentColor),
              );
            }

            return Center(
              child: Text("Nothing was found!"),
            );
          }),
    );
  }
}

class DetailsWidget extends StatefulWidget {
  final Person person;

  DetailsWidget({
    Key key,
    this.person,
  }) : super(key: key);

  @override
  _DetailsWidgetState createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(() {
      // print("postion ${_controller.position.pixels}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return CustomScrollView(
        controller: _controller,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
//        leading: SizedBox.shrink(),
            titleSpacing: 0,
            pinned: true,
            expandedHeight: screenSize.height * 0.4,
            backgroundColor: Colors.black.withOpacity(0.5),
            elevation: 8,
            actions: <Widget>[
//          IconButton(
//            onPressed: () {},
//            icon: Icon(Icons.share),
//          ),
//          IconButton(
//            onPressed: () {},
//            icon: Icon(Icons.favorite_border),
//          )
            ],
            flexibleSpace: FlexibleSpaceBar(
//              title: Text('${widget.person.name}'),
              // stretchModes: [StretchMode.blurBackground],
              collapseMode: CollapseMode.pin,
              background: Container(
                color: Theme.of(context).canvasColor,
                child: ClipPath(
                  clipper: CurvedPath(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.redAccent,
                    child: Image.network(
                      IMAGE_URL + widget.person.profilePath,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          widget.person.name,
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(widget.person.placeOfBirth),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.date_range,
                          color: Colors.redAccent,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${DateFormat.yMMMMEEEEd().format(widget.person.birthday)}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text("Biography",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${widget.person.biography}',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  "Photos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ImageList(
                id: widget.person.id,
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  "Movies",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 340,
                child: _buildMoviesRow(widget.person.id)
                )
            ],addAutomaticKeepAlives: true),
          ),
        ]);
  }

  Widget _buildMoviesRow(int id) {
    
    return FutureBuilder(
      future: new MovieRespository().getMovieCredits(id),
       builder: (BuildContext context, AsyncSnapshot<List<Results>> snapshot) {
         if(snapshot.hasData){
           List<Results> results=snapshot.data;
           if(results.length>0)

           return ListView.builder(
             scrollDirection: Axis.horizontal,
             itemCount: results.length,
             itemBuilder: (BuildContext context, int index) {
               var result = results[index];
               if(result != null)
               return MovieItemHorizontal(movie:results[index]);
               return Center(child: Icon(Icons.error),);
             },
           );
         }else{
            return Center(child: CircularProgressIndicator(),);
         }

         return Center(child:Text("Nothing found"),);
       },
    );
  }
}
