import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingBottomSheet extends StatelessWidget {
  const LoadingBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    final double bottomNotch = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30),
          topRight: const Radius.circular(30),
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
              SizedBox(height: layoutSize.height * 0.015),
              Lottie.asset('assets/animations/loading.json'),
              Text(
                'الرجاء الانتظار',
                textScaleFactor: 1,
                style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                      fontSize: layoutSize.width * 0.065,
                    ),
              ),
              SizedBox(height: layoutSize.height * 0.005),
              Text(
                'تتم عملية جلب الفصول...',
                textScaleFactor: 1,
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      fontSize: layoutSize.width * 0.037,
                    ),
              ),
              bottomNotch == 0 ? SizedBox(height: 70) : SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}
