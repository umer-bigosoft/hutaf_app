import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyResult extends StatelessWidget {
  final String text;
  final bool isSizedBox;
  const EmptyResult({
    Key key,
    this.text,
    this.isSizedBox = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Container(
      width: layoutSize.width,
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.04,
        left: layoutSize.width * 0.04,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isSizedBox) SizedBox(height: layoutSize.height * 0.15),
          SvgPicture.asset(
            'assets/images/empty_image.svg',
            height: layoutSize.height * 0.29,
          ),
          SizedBox(height: layoutSize.height * 0.06),
          Text(
            text,
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                  fontSize: layoutSize.width * 0.042,
                ),
          )
        ],
      ),
    );
  }
}
