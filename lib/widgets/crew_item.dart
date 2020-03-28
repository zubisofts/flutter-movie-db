import 'package:flutter/material.dart';
import 'package:MovieDB/model/credit.dart';
import 'package:MovieDB/pages/person_details_page.dart';
import 'package:MovieDB/repository/constants.dart';

class MovieCrewItem extends StatelessWidget {
  const MovieCrewItem({
    Key key,
    @required this.crew,
  }) : super(key: key);

  final Crew crew;

  @override
  Widget build(BuildContext context) {
    // print('${IMAGE_URL + cast.profilePath}');

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context)=>PersonDetailsPage(id:crew.id)));
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
                    child: crew.profilePath != null ?CircleAvatar(
                  backgroundImage:
                      NetworkImage('${IMAGE_URL + crew.profilePath}'),
                  radius: 50,
                ):CircleAvatar(child: Icon(Icons.person,size: 90,color: Colors.white24,),radius: 50,backgroundColor: Colors.grey,)
                )
                ),
            Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${crew.name}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '(${crew.job})',
                          style: TextStyle(
                              color: Colors.grey, fontStyle: FontStyle.italic),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
