import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthRichText extends StatelessWidget {
  final String normalString;
  final String underlineString;
  final Function handler;
  const AuthRichText(
      {Key key, this.normalString, this.underlineString, this.handler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.only(bottom: layoutSize.height * 0.02),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: RichText(
          text: TextSpan(
            text: normalString,
            style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                  fontSize: layoutSize.width * 0.04,
                ),
            children: [
              TextSpan(
                text: underlineString,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: layoutSize.width * 0.04,
                      decoration: TextDecoration.underline,
                      decorationThickness: 20,
                    ),
              ),
            ],
          ),
        ),
      ),
      onPressed: handler,
    );
  }
}
