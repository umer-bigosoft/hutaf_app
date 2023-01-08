import 'package:Hutaf/models/auth/subscribtion_model.dart';
import 'package:Hutaf/models/main/hutaf_subscription_model.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/iap_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_title_only.dart';
import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/ui/widgets/loading/button_loading.dart';
import 'package:Hutaf/ui/widgets/others/not_logged_in_user_content.dart';
import 'package:Hutaf/ui/widgets/others/row_builder.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../utils/screens_name.dart';

class Subscribtions extends StatefulWidget {
  final bool roundedCorners;
  Subscribtions({Key key, this.roundedCorners = false}) : super(key: key);

  @override
  _SubscribtionsState createState() => _SubscribtionsState();
}

class _SubscribtionsState extends State<Subscribtions> {
  List<HutafSubscription> subscriptions = [];
  List subscriptionsProducts = [];
  List notFoundIds = [];
  int selectedIndex = 0;

  bool _isInit = true;
  bool _isBuying = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      subscriptions =
          Provider.of<IAPProvider>(context, listen: false).subscriptions;
      Set<String> storeIds = {};
      notFoundIds = storeIds.toList();
      for (var subscription in subscriptions) {
        storeIds.add(subscription.productId);
      }
      if (storeIds.length > 0) loadStoreProduct(storeIds);
    }
    _isInit = false;
  }

  final subscriptionsText = [
    'خطة القارئ العادي تمكنك من الاستمتاع لمدة ثلاثة أشهر',
    'خطة القارئ البطل تمكنك من الاستمتاع لمدة ستة أشهر',
    'خطة القارئ المتميز تمكنك من الاستمتاع لمدة سنة كاملة والحصول على خصم مميز'
  ];

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBarTitleOnly(
        title: 'subscribtions.subscribtions_title'.tr(),
        cornerRadius: widget.roundedCorners ? 40 : 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (!auth.isLoggedIn) {
            return Container(
                color: Colors.white, child: NotLoggedInUserContent());
          } else {
            return Container(
              color: Colors.white,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SvgPicture.asset(
                    'assets/images/subscribtions.svg',
                    height: layoutSize.height * 0.3,
                  ),
                  SizedBox(height: layoutSize.height * 0.055),
                  paddedWidget(
                    layoutSize,
                    MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                      child: RichText(
                        text: TextSpan(
                          text: subscriptionsText[selectedIndex],
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: layoutSize.width * 0.042,
                              ),
                          children: [
                            // TextSpan(
                            //   text: 'subscribtions.subscribtions_underline_text'
                            //       .tr(),
                            //   style:
                            //       Theme.of(context).textTheme.bodyText2.copyWith(
                            //             fontSize: layoutSize.width * 0.042,
                            //             decoration: TextDecoration.underline,
                            //             decorationThickness: 20,
                            //           ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.035),
                  paddedWidget(
                    layoutSize,
                    subscribtionRow(
                      layoutSize,
                      'subscribtions.subscribtion1'.tr(),
                      Icons.lock_open_rounded,
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.02),
                  paddedWidget(
                    layoutSize,
                    subscribtionRow(
                      layoutSize,
                      'subscribtions.subscribtion2'.tr(),
                      Icons.keyboard_voice_rounded,
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.02),
                  paddedWidget(
                    layoutSize,
                    subscribtionRow(
                      layoutSize,
                      'subscribtions.subscribtion4'.tr(),
                      Icons.bubble_chart_rounded,
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.05),
                  paddedWidget(
                    layoutSize,
                    RowBuilder(
                      itemCount: subscriptions.length,
                      itemBuilder: (context, index) {
                        return Expanded(
                          child: GestureDetector(
                            child: Container(
                              height: 110,
                              // width: 116,
                              margin: EdgeInsets.only(
                                  left: layoutSize.width * 0.02),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: constraints.maxHeight * 0.1),
                                      Text(
                                        subscriptions[index].balance.toString(),
                                        textScaleFactor: 1,
                                        style: selectedIndex == index
                                            ? Theme.of(context)
                                                .primaryTextTheme
                                                .headline2
                                                .copyWith(
                                                  fontSize:
                                                      constraints.maxWidth *
                                                          0.3,
                                                  height: 0.3,
                                                )
                                            : Theme.of(context)
                                                .primaryTextTheme
                                                .caption
                                                .copyWith(
                                                  fontSize:
                                                      constraints.maxWidth *
                                                          0.3,
                                                  height: 0.3,
                                                ),
                                      ),
                                      Text(
                                        subscriptions[index].balance > 10
                                            ? 'شهر'
                                            : 'أشهر', // subscribtions.points'.tr()
                                        textScaleFactor: 1,
                                        style: selectedIndex == index
                                            ? Theme.of(context)
                                                .primaryTextTheme
                                                .headline2
                                                .copyWith(
                                                  fontSize:
                                                      constraints.maxWidth *
                                                          0.2,
                                                )
                                            : Theme.of(context)
                                                .primaryTextTheme
                                                .caption
                                                .copyWith(
                                                  fontSize:
                                                      constraints.maxWidth *
                                                          0.2,
                                                ),
                                      ),
                                      Text(
                                        'subscribtions.currency'.tr(args: [
                                          subscriptions[index]
                                              .price
                                              .toStringAsFixed(3)
                                        ]),
                                        textScaleFactor: 1,
                                        style: selectedIndex == index
                                            ? Theme.of(context)
                                                .primaryTextTheme
                                                .headline2
                                                .copyWith(
                                                  fontSize:
                                                      constraints.maxWidth *
                                                          0.12,
                                                )
                                            : Theme.of(context)
                                                .primaryTextTheme
                                                .caption
                                                .copyWith(
                                                  fontSize:
                                                      constraints.maxWidth *
                                                          0.12,
                                                ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.025),
                  Container(
                    width: layoutSize.width,
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "قم بالاشتراك الآن في أحد خطط الاشتراك، ولا تقلق تستطيع إلغاء اشتراكك في أي وقت تريد.عند اشتراكك في أي باقة ستحصل على تجربة مجانية لمدة خمس أيام بعد ذلك سيتم خصم تكلفة الاشتراك تلقائياً عند انتهاء التجربة المجانية في حين إنك لم تقم بإلغاء التجديد التلقائي من إعدادات هاتفك قبل مدة لاتزيد عن 24 ساعة على الأقل من انتهاء الفترة التجريبية",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: layoutSize.width * 0.038,
                              color: AppColors.purple),
                        ),
                        Row(
                          children: [
                            Text('لمعرفة المزيد قم بقراءت',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize: layoutSize.width * 0.038,
                                        color: AppColors.purple)),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, ScreensName.rules);
                              },
                              child: Text(
                                "  الشروط والحكام",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: layoutSize.width * 0.038,
                                      decorationThickness: 15,
                                    ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.035),
                  _isBuying
                      ? LoadingButton(
                          text: int.parse(subscriptions[selectedIndex]
                                          .balance
                                          .toString()) >=
                                      3 &&
                                  int.parse(subscriptions[selectedIndex]
                                          .balance
                                          .toString()) <=
                                      10
                              ? 'اشترك في باقة ' +
                                  subscriptions[selectedIndex]
                                      .price
                                      .toStringAsFixed(3) +
                                  ' ر.ع / ' +
                                  subscriptions[selectedIndex]
                                      .balance
                                      .toString() +
                                  ' الشهور'
                              : 'اشترك في باقة ' +
                                  subscriptions[selectedIndex]
                                      .price
                                      .toStringAsFixed(3) +
                                  ' ر.ع / ' +
                                  subscriptions[selectedIndex]
                                      .balance
                                      .toString() +
                                  ' الشهور',
                          buttonHeight: layoutSize.width * 0.12,
                          buttonWidth: layoutSize.width,
                          fontSize: layoutSize.width * 0.045,
                          margin: EdgeInsets.only(
                            right: layoutSize.width * 0.02,
                            left: layoutSize.width * 0.02,
                            bottom: layoutSize.height * 0.07,
                          ),
                        )
                      : notFoundIds
                              .contains(subscriptions[selectedIndex].productId)
                          ? Button(
                              text: 'ستتوفّر قريبًا',
                              buttonHeight: layoutSize.width * 0.12,
                              buttonWidth: layoutSize.width,
                              fontSize: layoutSize.width * 0.045,
                              margin: EdgeInsets.only(
                                right: layoutSize.width * 0.02,
                                left: layoutSize.width * 0.02,
                                bottom: layoutSize.height * 0.07,
                              ),
                              handler: () {},
                            )
                          : Button(
                              text: int.parse(subscriptions[selectedIndex]
                                              .balance
                                              .toString()) >=
                                          3 &&
                                      int.parse(subscriptions[selectedIndex]
                                              .balance
                                              .toString()) <=
                                          10
                                  ? 'اشترك في باقة ' +
                                      subscriptions[selectedIndex]
                                          .price
                                          .toStringAsFixed(3) +
                                      ' ر.ع / ' +
                                      subscriptions[selectedIndex]
                                          .balance
                                          .toString() +
                                      ' الشهور'
                                  : 'اشترك في باقة ' +
                                      subscriptions[selectedIndex]
                                          .price
                                          .toStringAsFixed(3) +
                                      ' ر.ع / ' +
                                      subscriptions[selectedIndex]
                                          .balance
                                          .toString() +
                                      ' الشهور',
                              buttonHeight: layoutSize.width * 0.12,
                              buttonWidth: layoutSize.width,
                              fontSize: layoutSize.width * 0.045,
                              margin: EdgeInsets.only(
                                right: layoutSize.width * 0.02,
                                left: layoutSize.width * 0.02,
                                bottom: layoutSize.height * 0.07,
                              ),
                              handler: () {
                                setState(() {
                                  _isBuying = true;
                                });

                                ProductDetails product;
                                for (ProductDetails _product
                                    in subscriptionsProducts) {
                                  if (_product.id ==
                                      subscriptions[selectedIndex].productId)
                                    product = _product;
                                }
                                // pay with store
                                Provider.of<IAPProvider>(context, listen: false)
                                    .purchase(
                                  product: product,
                                  type: 'PACKAGE',
                                  doc: 'users',
                                  onSuccess: onPurchasedSucceed,
                                  onError: onPurchaseError,
                                );
                              },
                            ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget subscribtionRow(Size layoutSize, String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: layoutSize.width * 0.055,
          color: AppColors.darkGrey,
        ),
        SizedBox(width: layoutSize.width * 0.02),
        Expanded(
          child: Text(
            text,
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                  fontSize: layoutSize.width * 0.038,
                ),
          ),
        )
      ],
    );
  }

  Future<void> loadStoreProduct(Set<String> storeIds) async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      // print('StoreId');
      // print('Not available');
      return;
    } else {
      // print('StoreId');
      // print('Available');
    }
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(storeIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
      // print('StoreId');
      // print('Not Found');
      setState(() {
        notFoundIds = response.notFoundIDs;
      });
    } else
      setState(() {
        notFoundIds = [];
      });

    subscriptionsProducts = response.productDetails;
  }

  void onPurchasedSucceed() {
    final Size layoutSize = MediaQuery.of(context).size;
    Provider.of<AuthProvider>(context, listen: false).querySubscriptionStatus();
    setState(() {
      _isBuying = false;
    });
    showSimpleNotification(
      Text(
        'تم الشهور بنجاح :) ، الرجاء الانتظار قليلًا حتى يتم التفعيل',
        textScaleFactor: 1,
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: layoutSize.width * 0.037,
            ),
      ),
      background: AppColors.purple,
      duration: Duration(milliseconds: 1000),
    );
    Provider.of<AuthProvider>(context, listen: false).subscription =
        UserSubscription(
      active: true,
      balance: subscriptions[selectedIndex].balance,
      type: selectedIndex.toString(),
    );
  }

  Widget paddedWidget(layoutSize, Widget widget) => Padding(
        padding: EdgeInsets.only(
          top: layoutSize.height * 0.01,
          left: layoutSize.width * 0.035,
          right: layoutSize.width * 0.035,
        ),
        child: widget,
      );

  void onPurchaseError() {
    final Size layoutSize = MediaQuery.of(context).size;
    setState(() {
      _isBuying = false;
    });
    showSimpleNotification(
      Text(
        'book_details.purchase_failed_unknown'.tr(),
        textScaleFactor: 1,
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: layoutSize.width * 0.037,
            ),
      ),
      background: AppColors.pink,
      duration: Duration(milliseconds: 1000),
    );
  }
}
