import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotLoggedInUserContent extends StatelessWidget {
  const NotLoggedInUserContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: layoutSize.height * 0.04),
        SvgPicture.asset(
          'assets/images/boy.svg',
          height: layoutSize.height * 0.22,
        ),
        SizedBox(height: layoutSize.height * 0.05),
        Text(
          'أيها اللطيف',
          textScaleFactor: 1,
          style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                fontSize: layoutSize.width * 0.063,
              ),
        ),
        MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: RichText(
            text: TextSpan(
              text: 'قم ',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: layoutSize.width * 0.04,
                  ),
              children: [
                TextSpan(
                  text: 'بالتسجيل',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: layoutSize.width * 0.04,
                        decoration: TextDecoration.underline,
                        decorationThickness: 15,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, ScreensName.registration);
                    },
                ),
                TextSpan(
                  text: ' أو ',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: layoutSize.width * 0.04,
                      ),
                ),
                TextSpan(
                  text: 'تسجيل الدخول',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: layoutSize.width * 0.04,
                        decoration: TextDecoration.underline,
                        decorationThickness: 15,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, ScreensName.login);
                    },
                ),
                TextSpan(
                  text: ' أولًا !',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: layoutSize.width * 0.04,
                      ),
                ),
              ],
            ),
          ),
        ),
        CustomDivider(
          lineWidth: layoutSize.width * 0.8,
          lineColor: AppColors.lightGrey3,
          marginBottom: layoutSize.height * 0.055,
          marginTop: layoutSize.height * 0.055,
        ),
      ],
    );
  }
}
