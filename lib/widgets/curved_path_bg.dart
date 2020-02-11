import 'package:flutter/widgets.dart';

class CurvedPath extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
//    final path = Path();
//    path.lineTo(size.width, 0.0);
//    path.lineTo(size.width, size.height*0.6);
//    path.lineTo(size.width*0.5, size.height*0.95);
//    path.quadraticBezierTo(0.8, size.height,size.width*0.3, size.height*0.3);
//    path.close();

    var path = new Path();
    path.lineTo(0.0, size.height * 0.6);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height );
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
    Offset(size.width *0.9, size.height *0.99);
    var secondEndPoint = Offset(size.width, size.height*0.55);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}