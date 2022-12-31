import 'package:flutter/material.dart';

class TabTitle extends StatelessWidget {
  final String text;
  const TabTitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Tab(
      child: Text(
        text,
        maxLines: 1,
        textScaleFactor: 1,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: layoutSize.width * 0.045,
        ),
      ),
    );
  }
}
