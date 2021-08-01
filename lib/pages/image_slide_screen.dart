import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MovieDB/repository/movie_repository.dart';

import 'package:MovieDB/model/movie_images.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_downloader/image_downloader.dart';

class ImageSlideScreen extends StatefulWidget {
  final List<Backdrop> backdrops;
  int index;

  ImageSlideScreen({
    Key key,
    this.backdrops,
    this.index,
  }) : super(key: key);

  @override
  _ImageSlideScreenState createState() => _ImageSlideScreenState();
}

class _ImageSlideScreenState extends State<ImageSlideScreen> {
//  String _message = "";
  String _path = "";
//  String _size = "";
  String _mimeType = "";
//  File _imageFile;
  int _progress = 0;

  @override
  void initState() {
    super.initState();

    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        _progress = progress;
        if (progress == 100) showImage();
        print(_progress);
      });
    });
  }

 Future<void> showImage() async {
    await ImageDownloader.open(_path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => Navigator.pop(context),
                    child: IconButtonEx(
                      icon: Icons.arrow_back_ios,
                      color: Theme.of(context).canvasColor,
                      iconColor: Theme.of(context).primaryTextTheme.body1.color,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                         MovieRepository.shareImage('Share this image', "image.jpg",widget.backdrops[widget.index].filePath);
                        },
                        child: IconButtonEx(
                          icon: Icons.share,
                          color: Theme.of(context).canvasColor,
                          iconColor:
                              Theme.of(context).primaryTextTheme.body1.color,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      GestureDetector(
                          onTap: () {
                            _downloadImage(
                                IMAGE_URL +
                                    widget.backdrops[widget.index].filePath,
                                context,
                                destination:
                                    AndroidDestinationType.directoryPictures);
                          },
                          child: IconButtonEx(
                            icon: Icons.cloud_download,
                            color: Theme.of(context).canvasColor,
                            iconColor:
                                Theme.of(context).primaryTextTheme.body1.color,
                          ))
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: GFCarousel(
                  height: MediaQuery.of(context).size.height,
                  items: widget.backdrops
                      .map((backdrop) => _buildBackdropItem(backdrop))
                      .toList(),
                  autoPlay: false,
                  initialPage: widget.index,
                  // aspectRatio: 1.0,
                  scrollPhysics: BouncingScrollPhysics(),
                  enlargeMainPage: false,
                  viewportFraction: 1.0,
                  onPageChanged: (page) {
                    setState(() {
                      widget.index = page;
                    });

                  },
                  // pagination: true,
                  // activeIndicator: Colors.orange,
                  // passiveIndicator: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackdropItem(Backdrop backdrop) {
    return Center(
      child: Hero(
        tag: "backdrop",
        child: CachedNetworkImage(
          imageUrl:backdrop.filePath != null ? "${IMAGE_URL + backdrop.filePath}" : IMAGE_TEMP_URL,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Future<void> _downloadImage(String url, BuildContext cxt,
      {AndroidDestinationType destination, bool whenError = false}) async {
    String fileName;
    String path;
    int size;
    String mimeType;

    try {
      String imageId;

      if (whenError) {
        imageId = await ImageDownloader.downloadImage(url).catchError((error) {
          if (error is PlatformException) {
            var path = "";
            if (error.code == "404") {
              print("Not Found Error.");
            } else if (error.code == "unsupported_file") {
              print("UnSupported FIle Error.");
              path = error.details["unsupported_file_path"];
            }
            // setState(() {
            //   _message = error.toString();
            //   _path = path;
            // });
          }

          print(error);
        }).timeout(Duration(seconds: 10), onTimeout: () {
          print("timeout");
        });
      } else {
        if (destination == null) {
          imageId = await ImageDownloader.downloadImage(url);
        } else {
          imageId = await ImageDownloader.downloadImage(
            url,
            destination: destination,
          );
        }
      }

      if (imageId == null) {
        return;
      }
      fileName = await ImageDownloader.findName(imageId);
      path = await ImageDownloader.findPath(imageId);
      size = await ImageDownloader.findByteSize(imageId);
      mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
      // setState(() {
      //   _message = error.message;
      // });
      return;
    }

    if (!mounted) return;

    setState(() {
      var location = Platform.isAndroid ? "Directory" : "Photo Library";
//      _message = 'Saved as "$fileName" in $location.\n';
//      _size = 'size:     $size';
      _mimeType = 'mimeType: $mimeType';
      _path = path;
      // Scaffold.of(cxt).showSnackBar(SnackBar(content: Text("data"),duration: Duration(seconds: 3),));
      if (!_mimeType.contains("video")) {
//        _imageFile = File(path);
      }
    });
  }
}

class IconButtonEx extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  const IconButtonEx({
    Key key,
    this.icon,
    this.color,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Icon(
        icon,
        color: iconColor,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.5),
//        boxShadow: [
//          BoxShadow(
//            offset: Offset(0, 0),
//            blurRadius: 10,
//          )
//        ],
      ),
    );
  }
}
