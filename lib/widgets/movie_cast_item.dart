import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/model/credit.dart';
import 'package:flutter_ui_challenge/pages/person_details_page.dart';
import 'package:flutter_ui_challenge/respository/constants.dart';

class MovieCastItem extends StatelessWidget {
  const MovieCastItem({
    Key key,
    @required this.cast,
  }) : super(key: key);

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    // print('${IMAGE_URL + cast.profilePath}');

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context)=>PersonDetailsPage(id:cast.id)));
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        // height: 250,
        // width: 150,
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 9,
                child: Center(
                    child: cast.profilePath != null ?CircleAvatar(
                  backgroundImage:
                      NetworkImage('${IMAGE_URL + cast.profilePath}'),
                  radius: 50,
                ):CircleAvatar(child: Icon(Icons.person,size: 90,color: Colors.white24,),radius: 50,backgroundColor: Colors.grey,)
                )
                ),
            Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${cast.name}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '(${cast.character})',
                        style: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
