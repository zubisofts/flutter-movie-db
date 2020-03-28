import 'package:flutter/material.dart';

import 'package:MovieDB/model/credit.dart';
import 'package:MovieDB/widgets/cast_item.dart';
import 'package:MovieDB/widgets/crew_item.dart';

class MovieCreditsPage extends StatefulWidget {
  final Credit credit;

  MovieCreditsPage({
    Key key,
    this.credit,
  }) : super(key: key);

  @override
  _MovieCreditsPageState createState() => _MovieCreditsPageState();
}

class _MovieCreditsPageState extends State<MovieCreditsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Movie Credits"),
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                text: "Casts",
              ),
              Tab(
                text: "Crew",
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            CastWidget(
              casts: widget.credit.cast,
            ),
            CrewWidget(
              crew: widget.credit.crew,
            ),
          ],
        ));
  }
}

class CastWidget extends StatelessWidget {
  final List<Cast> casts;

  CastWidget({this.casts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.0),
      itemCount: casts.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return MovieCastItem(
          cast: casts[index],
        );
      },
    );
  }
}

class CrewWidget extends StatelessWidget {
  final List<Crew> crew;

  CrewWidget({this.crew});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.0),
      itemCount: crew.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return MovieCrewItem(
          crew: crew[index],
        );
      },
    );
  }
}
