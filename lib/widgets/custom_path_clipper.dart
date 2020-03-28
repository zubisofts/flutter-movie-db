import 'package:flutter/material.dart';

class CustomTagClipper extends CustomClipper<Path>{
 
  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }

  @override
  getClip(Size size) {
     double width=size.width;
    double height=size.height;

    Path path=Path();
    path.lineTo(0, height);
    path.lineTo(width*0.5, height*0.8);
    path.lineTo(width*0.5, height*0.8);
    path.lineTo(width, height);
    path.lineTo(width, 0);
    path.close();
    return path;
  }
  
}