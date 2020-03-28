import 'dart:ui';

import 'package:MovieDB/fragments/discover_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:MovieDB/bloc/movies_bloc/bloc.dart';
import 'package:MovieDB/model/genre.dart';
import 'package:MovieDB/repository/constants.dart';

 Map<String,String> sortList={"Popularity Asc.":"popularity.asc","Popularity Desc.":"popularity.desc","Release Date Asc.":"release_date.asc","Release Date Desc.":"release_date.desc"};

  List<int> selectedGenries = [];
  var selectectItem='';
  String year='2019';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {

bool isApplied=true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).accentColor.withOpacity(0.5),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Sort and Filter",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                  icon: Icon(isApplied?Icons.movie_filter:Icons.check),
                  onPressed: () {
                    setState(() {
                      isApplied=!isApplied;
                      isApplied? DiscoverListFragment(mediaType: MediaType.MOVIE,sortQuery: selectectItem,year: year, genres: selectedGenries,user: null,):SortAndFilterWidget();
                    });
                    
                  }
                  ),
              ],
          ),
        ),
        Expanded(child: isApplied?DiscoverListFragment(mediaType: MediaType.MOVIE,sortQuery: selectectItem,year: year, genres: selectedGenries,user: null,):SortAndFilterWidget())
      ],
    );
  }
}

class SortAndFilterWidget extends StatefulWidget {
  @override
  _SortAndFilterWidgetState createState() => _SortAndFilterWidgetState();
}

class _SortAndFilterWidgetState extends State<SortAndFilterWidget> {

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MoviesBloc>(context).add(GetGenres(mediaType: MediaType.MOVIE));
    return Container(
      padding: EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: ListView(
//                shrinkWrap:true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
//          padding: EdgeInsets.all(32.0),
                  color: Theme.of(context).canvasColor,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(
                          height: 1.0,
                          thickness: 2.0,
                          indent: 5.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Sort By:",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Wrap(
                          runAlignment: WrapAlignment.start,

                          direction: Axis.horizontal,

                          // runSpacing: 0,

                          spacing: 5,

                          children: sortList.entries.map((f)=>GestureDetector(
                            child: ChoiceChip(
                              label: Text(f.key),
                              onSelected: (bool s){
                                setState(() {
                                  selectectItem=f.value;
                                });
                              },
                              selected: f.value==selectectItem,
                              selectedColor: Theme.of(context).accentColor,
                            )
                            )).toList(),
                          
                        )
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Text(
                    "Filter",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  height: 1.0,
                  thickness: 2.0,
                  indent: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Release Year",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    maxLines: 1,
                    onChanged: (value){
                      year=value;
                    },
                    decoration: InputDecoration(
                      hintText: "2020",
                    ),
                  ),
                ),
                Divider(
                  height: 1.0,
                  thickness: 2.0,
                  indent: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Genry:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder(
                    bloc: BlocProvider.of<MoviesBloc>(context),
                    builder: (BuildContext context, state) {
                      if(state is GenresState){
                        return Wrap(
                          runAlignment: WrapAlignment.start,

                          direction: Axis.horizontal,

                          // runSpacing: 0,

                          spacing: 5,

                          children: state.genry.genres
                              .map((f) => GenryItem(
                              genry: f, selections: selectedGenries))
                              .toList(),
                        );
                      }
                      return Container();
                    },
                      ),
                ),
                Divider(
                  height: 1.0,
                  thickness: 2.0,
                  indent: 5.0,
                ),
              ],
            ),
          ),
          // Expanded(
          //   flex: 1,
            // child: Padding(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   child: RaisedButton(
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(16)),
            //       child: Text("Apply Filter"),
            //       color: Theme.of(context).accentColor.withOpacity(0.8),
            //       textColor: Colors.white,
            //       onPressed: () {
            //         // print(selectedGenries.length);
            //         // print(selectectItem);
            //       }),
            // ),
          // )
        ],
      ),
    );
  }
}

class GenryItem extends StatefulWidget {
  final Genre genry;
  final List<int> selections;

  const GenryItem({Key key, this.genry, this.selections}) : super(key: key);

  @override
  _GenreItemState createState() => _GenreItemState();
}

class _GenreItemState extends State<GenryItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.selections.contains(widget.genry.id)) {
            widget.selections.remove(widget.genry.id);
          } else {
            widget.selections.add(widget.genry.id);
          }
          isSelected = !isSelected;
        });

      },
      child: Chip(
        backgroundColor: isSelected? Theme.of(context).accentColor.withOpacity(0.5):null,
        label: Text(widget.genry.name),
      ),
    );
  }
}

class SortItem extends StatefulWidget {

final Map<String,String> sortList;
  const SortItem({
    Key key,
    this.sortList, this.item,
  }) : super(key: key);
final item;


  @override
  _SortItemState createState() => _SortItemState();
}

class _SortItemState extends State<SortItem> {

String selectedItemKey;

@override
  void initState() {
    super.initState();
    selectedItemKey='';
  }

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.item.key), 
      selected: null,
    );
  }
}
