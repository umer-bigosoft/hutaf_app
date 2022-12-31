import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  final Function handler;
  final String text;
  const RectangleButton({Key key, this.handler, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: CupertinoButton(
        minSize: 1,
        padding: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.only(
            top: layoutSize.height * 0.027,
            bottom: layoutSize.height * 0.027,
          ),
          color: AppColors.darkPink,
          child: Center(
            child: Text(
              text,
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: layoutSize.width * 0.05,
                  ),
            ),
          ),
        ),
        onPressed: handler,
      ),
    );
  }
}
