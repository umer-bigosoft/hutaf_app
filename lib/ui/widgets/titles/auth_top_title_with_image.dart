import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthTopTitleWithImage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String type;
  const AuthTopTitleWithImage({Key key, this.title, this.subtitle, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
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
          ),
        ),
        SizedBox(width: layoutSize.width * 0.05),
        SvgPicture.asset(
          type == 'girl' ? 'assets/images/girl.svg' : 'assets/images/boy.svg',
          height: layoutSize.height * 0.075,
        )
      ],
    );
  }
}
