import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {

  final String text;
  LoadingButton({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(color: Colors.blue[300]),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
  }
}
