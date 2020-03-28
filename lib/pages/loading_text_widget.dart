import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingTextWidget extends StatelessWidget {

  final Color baseColor;
  final Color highlightColor;
  final String text;

  const LoadingTextWidget({
    Key key, this.baseColor, this.highlightColor,this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200.0,
        height: 100.0,
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
