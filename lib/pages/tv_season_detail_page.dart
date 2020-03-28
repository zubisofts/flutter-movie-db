import 'package:MovieDB/bloc/tv_bloc/tv_bloc.dart';
import 'package:MovieDB/model/credit.dart';
import 'package:MovieDB/model/tv_details.dart';
import 'package:MovieDB/model/tv_season_details.dart';
import 'package:MovieDB/model/video_details.dart';
import 'package:MovieDB/pages/episode_details_page.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import 'package:MovieDB/widgets/cast_list.dart';
import 'package:MovieDB/widgets/trailers_row_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeasonDetailsPage extends StatefulWidget {
  final Season season;
  final int id;

  const TvSeasonDetailsPage({Key key, this.season, this.id}) : super(key: key);

  @override
  _TvSeasonDetailsPageState createState() => _TvSeasonDetailsPageState();
}

class _TvSeasonDetailsPageState extends State<TvSeasonDetailsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TvBloc _tvBloc=TvBloc();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tvBloc.add(LoadTvSeasonDetailsEvent(
        id: widget.id, seasonNo: widget.season.seasonNumber));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.season.name}'),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              shape: BoxShape.rectangle,
//              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.6),
            ),
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                text: "Info",
              ),
              Tab(
                text: "Episodes",
              )
            ],
          ),
        ),
        body: BlocBuilder<TvBloc, TvState>(
          bloc: _tvBloc,
          builder: (BuildContext context, TvState state) {
            if (state is TvSeasonDetailsState) {
              var tvSeasonDetails = state.tvSeasonDetails;
              return TabBarView(
                controller: _tabController,
                children: <Widget>[
                  InfoWidget(details: tvSeasonDetails, id: widget.id),
                  EpisodesWidget(details: tvSeasonDetails, id: widget.id),
                ],
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}

class InfoWidget extends StatelessWidget {
  final TvSeasonDetails details;
  final int id;

  const InfoWidget({Key key, this.details, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Stack(children: <Widget>[
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: details.posterPath != null
                  ? "${IMAGE_URL + details.posterPath}"
                  : "assets/images/no-image.jpg",
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 1,
                      )))),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${details.name}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.date_range,
                          color: Colors.orange,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                            '${details.airDate.day}-${details.airDate.month}-${details.airDate.year}')
                      ],
                    )
                  ],
                )),
          ),
        ]),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              Text('Air Date',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
//              SizedBox(height: 8,),
              Text(
                'Overview',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                details.overview,
                style: TextStyle(color: Colors.grey[400]),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
              VideoWidget(
                details: details,
                id:id,
              ),
              CastWidgetRow(details: details,id:id),
            ],
          ),
        ),
      ],
    );
  }
}

class EpisodesWidget extends StatelessWidget {
  final TvSeasonDetails details;
  final int id;

  const EpisodesWidget({Key key, this.details, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: ListView.builder(
//            shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: details.episodes.length,
          itemBuilder: (BuildContext context, int index) {
            Episode episode = details.episodes[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.all(16),
              elevation: 8,
              color: Theme.of(context).canvasColor,
              child: Stack(children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EpisodeDetailsPage(
                              episode: episode,
                              seasonId: id,
                            )));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 16, right: 8, top: 16, bottom: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: episode.stillPath != null
                                  ? "${IMAGE_URL + episode.stillPath}"
                                  : "assets/images/no-image.jpg",
                              fit: BoxFit.cover,
                              width: 70,
                              height: 85,
                              placeholder: (context, url) => Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      )))),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 16, right: 32),
                                            child: Text(
                                              episode.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                episode.overview,
                                style: TextStyle(color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    ]);
  }
}


class CastWidgetRow extends StatelessWidget {

  final TvSeasonDetails details;
  final int id;

  const CastWidgetRow({
    Key key, this.details,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        FutureBuilder(
          future: new MovieRepository().getCredits(id,type:1,sn: details.seasonNumber),
          builder: (BuildContext context, AsyncSnapshot<Credit> snapshot) {
              return snapshot.hasData?CastList(
                title: "Cast",
                credit: snapshot.data,
              ):Center(child: CircularProgressIndicator());
          },)
      ],
    );
  }
}

class VideoWidget extends StatefulWidget {
  final TvSeasonDetails details;
  final int id;

  const VideoWidget({Key key, this.details, this.id}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: FutureBuilder(
        future: new MovieRepository().getVideos(widget.id,
            sn: widget.details.seasonNumber,
            type: 1),
        builder: (BuildContext context, AsyncSnapshot<VideoDetails> snapshot) {
          return snapshot.hasData ? TrailersVideoRow(
            videos: snapshot.data.results,) : Center(
            child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
