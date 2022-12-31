import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessOtpBottomSheet extends StatelessWidget {
  const SuccessOtpBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    final double bottomNotch = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(40),
          topRight: const Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.bottomSheetShadow,
            offset: Offset(1.0, -5.0),
            blurRadius: 8.0,
          )
        ],
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          top: false,
          bottom: bottomNotch > 0 ? true : false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: layoutSize.height * 0.03),
              SvgPicture.asset(
                'assets/images/bottom_sheet_line.svg',
                width: layoutSize.width / 4,
              ),
              SizedBox(height: layoutSize.height * 0.07),
              SvgPicture.asset(
                'assets/images/otp_success.svg',
                height: layoutSize.height * 0.27,
              ),
              SizedBox(height: layoutSize.height * 0.055),
              Text(
                'auth.great'.tr(),
                textScaleFactor: 1,
                style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                      fontSize: layoutSize.width * 0.085,
                    ),
              ),
              SizedBox(height: layoutSize.height * 0.005),
              Text(
                'auth.account_verified_successfully'.tr(),
                textScaleFactor: 1,
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      fontSize: layoutSize.width * 0.037,
                    ),
              ),
              SizedBox(height: layoutSize.height * 0.07),
              Button(
                text: 'هيا لنبدأ',
                buttonHeight: layoutSize.width * 0.12,
                buttonWidth: layoutSize.width,
                fontSize: layoutSize.width * 0.045,
                margin: EdgeInsets.only(
                  right: layoutSize.width * 0.1,
                  left: layoutSize.width * 0.1,
                  bottom: layoutSize.height * 0.03,
                ),
                handler: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushNamed(
                      context, ScreensName.userInterests);
                },
              ),
              bottomNotch == 0 ? SizedBox(height: 50) : SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
