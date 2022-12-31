import 'package:flutter/material.dart';

class AuthTopTitleWithoutImage extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthTopTitleWithoutImage({
    Key key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textScaleFactor: 1,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                fontSize: layoutSize.width * 0.05,
                // height: 1,
              ),
        ),
        Text(
          subtitle,
          textScaleFactor: 1,
          style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                fontSize: layoutSize.width * 0.03,
              ),
        ),
      ],
    );
  }
}
