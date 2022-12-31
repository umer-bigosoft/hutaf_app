import 'package:Hutaf/models/auth/subscribtion_model.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/iap_provider.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/ui/widgets/others/row_builder.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SubscribedUser extends StatefulWidget {
  SubscribedUser({Key key}) : super(key: key);

  @override
  _SubscribedUserState createState() => _SubscribedUserState();
}

class _SubscribedUserState extends State<SubscribedUser> {
  List subscriptions = [];
  int selectedIndex = 0;

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      subscriptions =
          Provider.of<IAPProvider>(context, listen: false).subscriptions;
      UserSubscription subscription =
          Provider.of<AuthProvider>(context, listen: false).subscription;
      selectedIndex = int.parse(subscription.type);
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    UserSubscription subscription =
        Provider.of<AuthProvider>(context, listen: false).subscription;
    final Size layoutSize = MediaQuery.of(context).size;
    String remaining = '';
    if (int.parse(subscription.balance.toString()) == 1) {
      remaining = 'الرصيد المتبقي : كتاب واحد';
    } else if (int.parse(subscription.balance.toString()) == 2) {
      remaining = 'الرصيد المتبقي : كتابان';
    } else if (int.parse(subscription.balance.toString()) >= 3 &&
        int.parse(subscription.balance.toString()) <= 10) {
      remaining =
          'الرصيد المتبقي : ' + subscription.balance.toString() + ' كتب';
    } else {
      remaining =
          'الرصيد المتبقي : ' + subscription.balance.toString() + ' كتاب';
    }

    ///
    ///
    ///
    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: layoutSize.height * 0.03,
          left: layoutSize.width * 0.035,
          right: layoutSize.width * 0.035,
        ),
        children: [
          SvgPicture.asset(
            'assets/images/subscribtions.svg',
            height: layoutSize.height * 0.3,
          ),
          SizedBox(height: layoutSize.height * 0.055),
          Center(
            child: Text(
              int.parse(subscriptions[selectedIndex].balance.toString()) >= 3 &&
                      int.parse(subscriptions[selectedIndex]
                              .balance
                              .toString()) <=
                          10
                  ? 'أنت مشترك في باقة ' +
                      subscriptions[selectedIndex].balance.toString() +
                      ' كتب'
                  : 'أنت مشترك في باقة ' +
                      subscriptions[selectedIndex].balance.toString() +
                      ' كتاب',
              // 'subscribtions.subscribed'
              //     .tr(args: [subscriptions[selectedIndex].balance.toString()]),
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: layoutSize.width * 0.052,
                    decoration: TextDecoration.underline,
                    decorationThickness: 15,
                  ),
            ),
          ),
          SizedBox(height: layoutSize.height * 0.05),
          Text(
            remaining,
            // 'subscribtions.balance'
            //     .tr(args: [subscription.balance.toString()]), 
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                  fontSize: layoutSize.width * 0.042,
                ),
          ),
          SizedBox(height: layoutSize.height * 0.02),
          Text(
            int.parse(subscriptions[selectedIndex].balance.toString()) >= 3 &&
                    int.parse(
                            subscriptions[selectedIndex].balance.toString()) <=
                        10
                ? 'المجموع : ' +
                    subscriptions[selectedIndex].balance.toString() +
                    ' كتب'
                : 'المجموع : ' +
                    subscriptions[selectedIndex].balance.toString() +
                    ' كتاب',
            // 'subscribtions.total'
            //     .tr(args: [subscriptions[selectedIndex].balance.toString()]),
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                  fontSize: layoutSize.width * 0.042,
                ),
          ),
          CustomDivider(
            lineWidth: layoutSize.width * 0.8,
            lineColor: AppColors.lightGrey3,
            marginBottom: layoutSize.height * 0.055,
            marginTop: layoutSize.height * 0.055,
          ),
          Text(
            'subscribtions.available'.tr(),
            textScaleFactor: 1,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: layoutSize.width * 0.052,
                ),
          ),
          SizedBox(height: layoutSize.height * 0.03),
          RowBuilder(
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              return Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 110,
                    // width: 116,
                    margin: EdgeInsets.only(left: layoutSize.width * 0.02),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: selectedIndex == index
                            ? AppColors.purple
                            : AppColors.lightGrey3,
                        width: 2,
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: constraints.maxHeight * 0.1),
                            Text(
                              subscriptions[index].balance.toString(),
                              textScaleFactor: 1,
                              style: selectedIndex == index
                                  ? Theme.of(context)
                                      .primaryTextTheme
                                      .headline2
                                      .copyWith(
                                        fontSize: constraints.maxWidth * 0.3,
                                        height: 0.3,
                                      )
                                  : Theme.of(context)
                                      .primaryTextTheme
                                      .caption
                                      .copyWith(
                                        fontSize: constraints.maxWidth * 0.3,
                                        height: 0.3,
                                      ),
                            ),
                            Text(
                              int.parse(subscriptions[index]
                                              .balance
                                              .toString()) >=
                                          3 &&
                                      int.parse(subscriptions[index]
                                              .balance
                                              .toString()) <=
                                          10
                                  ? 'كتب'
                                  : 'كتاب',
                              //'subscribtions.points'.tr(),
                              textScaleFactor: 1,
                              style: selectedIndex == index
                                  ? Theme.of(context)
                                      .primaryTextTheme
                                      .headline2
                                      .copyWith(
                                        fontSize: constraints.maxWidth * 0.2,
                                      )
                                  : Theme.of(context)
                                      .primaryTextTheme
                                      .caption
                                      .copyWith(
                                        fontSize: constraints.maxWidth * 0.2,
                                      ),
                            ),
                            Text(
                              'subscribtions.currency'.tr(args: [
                                subscriptions[index].price.toStringAsFixed(3)
                              ]),
                              textScaleFactor: 1,
                              style: selectedIndex == index
                                  ? Theme.of(context)
                                      .primaryTextTheme
                                      .headline2
                                      .copyWith(
                                        fontSize: constraints.maxWidth * 0.12,
                                      )
                                  : Theme.of(context)
                                      .primaryTextTheme
                                      .caption
                                      .copyWith(
                                        fontSize: constraints.maxWidth * 0.12,
                                      ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  onTap: () {
                    // setState(() {
                    //   selectedIndex = index;
                    // });
                  },
                ),
              );
            },
          ),
          SizedBox(height: layoutSize.height * 0.06),
        ],
      ),
    );
  }
}
