import 'package:Hutaf/handler/notification_handler.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/home_provider.dart';
import 'package:Hutaf/ui/views/main/archives.dart';
import 'package:Hutaf/ui/views/main/learn_screen.dart';
import 'package:Hutaf/ui/views/main/settings.dart';
import 'package:Hutaf/ui/views/main/subscribed_user.dart';
import 'package:Hutaf/ui/views/main/subscriptions.dart';
import 'package:Hutaf/ui/views/main/suggestion_modal.dart';
import 'package:Hutaf/ui/widgets/navigation_bar/ff_navigation_bar.dart';
import 'package:Hutaf/ui/widgets/others/custom_dialog.dart';
import 'package:Hutaf/ui/widgets/others/mini_audio_widget.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:Hutaf/ui/views/main/home/home_screen.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MainNavigationScreen extends StatefulWidget {
  MainNavigationScreen({Key key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<Widget> _children = [
    HomeScreen(),
    LearnScreen(),
    Subscribtions(),
    Archives(),
    Settings(),
  ];
  final _drawerKey = GlobalKey<InnerDrawerState>();
  int _currentIndex = 0;
  // ignore: unused_field
  bool _isDrawerOpened = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String moringOrEvening;

  @override
  void initState() {
    super.initState();
    moringOrEvening = DateFormat('a').format(DateTime.now());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        NotificationHandler().handleNotification(message.data, context);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationHandler().handleInAppNotification(message.data, context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationHandler().handleNotification(message.data, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    _children[2] =
        Provider.of<AuthProvider>(context, listen: true).hasSubscription
            ? SubscribedUser()
            : Subscribtions();
    return InnerDrawer(
      key: _drawerKey,
      onTapClose: true,
      swipe: true,
      innerDrawerCallback: (isOpened) {
        setState(() {
          _isDrawerOpened = isOpened;
        });
      },
      // leftOffset: 0.1,
      // rightOffset: 0.6,
      // leftScale: 0.8,
      // rightScale: 0.9,
      proportionalChildArea: true,
      borderRadius: 25,
      scale: IDOffset.horizontal(0.7),
      leftAnimationType: InnerDrawerAnimation.static,
      rightAnimationType: InnerDrawerAnimation.quadratic,
      onDragUpdate: (double val, InnerDrawerDirection direction) {
        //print(direction);
      },
      leftChild: menuDrawer(layoutSize),
      backgroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [AppColors.darkPink, AppColors.orange],
        ),
      ),
      scaffold: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: FFNavigationBar(
          theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.white,
            selectedItemBackgroundColor: AppColors.darkPink,
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: AppColors.black,
            unselectedItemIconColor: AppColors.darkGrey,
            unselectedItemLabelColor: AppColors.darkGrey,
            selectedItemTextStyle:
                Theme.of(context).primaryTextTheme.headline2.copyWith(
                      fontSize: layoutSize.width * 0.028,
                      fontWeight: FontWeight.w700,
                    ),
            unselectedItemTextStyle:
                Theme.of(context).primaryTextTheme.headline6.copyWith(
                      fontSize: layoutSize.width * 0.028,
                    ),
          ),
          selectedIndex: _currentIndex,
          onSelectTab: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            FFNavigationBarItem(
              iconData: Icons.home_rounded,
              label: 'navigation.home'.tr(),
            ),
            FFNavigationBarItem(
              iconData: Icons.book_rounded,
              label: 'navigation.learn'.tr(),
            ),
            FFNavigationBarItem(
              iconData: Icons.subscriptions_rounded,
              label: 'navigation.subscriptions'.tr(),
            ),
            FFNavigationBarItem(
              iconData: Icons.auto_stories,
              label: 'navigation.saved'.tr(),
            ),
            FFNavigationBarItem(
              iconData: Icons.person,
              label: 'navigation.my_account'.tr(),
            ),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   elevation: 25,
        //   backgroundColor: Colors.white,
        //   type: BottomNavigationBarType.fixed,
        //   unselectedLabelStyle:
        //       Theme.of(context).primaryTextTheme.headline6.copyWith(
        //             fontSize: layoutSize.width * 0.028,
        //           ),
        //   selectedLabelStyle:
        //       Theme.of(context).primaryTextTheme.headline2.copyWith(
        //             fontSize: layoutSize.width * 0.028,
        //             fontWeight: FontWeight.w700,
        //           ),
        //   currentIndex: _currentIndex,
        //   unselectedItemColor: AppColors.lightGrey,
        //   selectedItemColor: AppColors.darkPink,
        //   onTap: (index) {
        //     setState(() {
        //       _currentIndex = index;
        //     });
        //   },
        //   // theme: FFNavigationBarTheme(
        //   //   barBackgroundColor: Colors.white,
        //   //   selectedItemBackgroundColor: AppColors.darkPink,
        //   //   selectedItemIconColor: Colors.white,
        //   //   selectedItemLabelColor: AppColors.black,
        //   //   unselectedItemIconColor: AppColors.darkGrey,
        //   //   unselectedItemLabelColor: AppColors.darkGrey,
        //   //   selectedItemTextStyle:
        //   //       Theme.of(context).primaryTextTheme.headline3.copyWith(
        //   //             fontSize: layoutSize.width * 0.033,
        //   //             fontWeight: FontWeight.w700,
        //   //           ),
        //   //   unselectedItemTextStyle:
        //   //       Theme.of(context).primaryTextTheme.headline6.copyWith(
        //   //             fontSize: layoutSize.width * 0.028,
        //   //           ),
        //   // ),
        //   // selectedIndex: _currentIndex,
        //   // onSelectTab: (index) {
        //   //   setState(() {
        //   //     _currentIndex = index;
        //   //   });
        //   // },
        //   items: <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home_rounded),
        //       label: 'navigation.home'.tr(),
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.book_rounded),
        //       label: 'navigation.learn'.tr(),
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.subscriptions_rounded),
        //       label: 'navigation.subscriptions'.tr(),
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.star_rate_rounded),
        //       label: 'navigation.saved'.tr(),
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.settings_rounded),
        //       label: 'navigation.settings'.tr(),
        //     ),
        //   ],
        // ),
        body: Stack(
          children: [
            _children[_currentIndex],
            MiniAudioWidget(),
          ],
        ),
      ),
    );
  }

  Widget menuDrawer(Size layoutSize) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              right: layoutSize.width * 0.045, left: layoutSize.width * 0.045),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: layoutSize.height * 0.05),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CupertinoButton(
                              minSize: 1,
                              padding: EdgeInsets.zero,
                              child: auth.profilePhoto == ''
                                  ? SvgPicture.asset(
                                      auth.gender == 1
                                          ? 'assets/images/girl.svg'
                                          : 'assets/images/boy.svg',
                                      height: layoutSize.height * 0.075,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image(
                                        image: NetworkImage(auth.profilePhoto),
                                        fit: BoxFit.cover,
                                        height: layoutSize.height * 0.075,
                                        width: layoutSize.height * 0.095,
                                      ),
                                    ),
                              onPressed: () {},
                            ),
                            SizedBox(width: layoutSize.width * 0.025),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  child,
                                  Text(
                                    auth.isLoggedIn
                                        ? auth.userName
                                        : 'main.kind_person'.tr(),
                                    textScaleFactor: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                          fontSize: layoutSize.width * 0.055,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      child: Text(
                        moringOrEvening == 'AM'
                            ? 'menu.good_morning'.tr()
                            : 'menu.good_afternoon'.tr(),
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: layoutSize.width * 0.035,
                            ),
                      ),
                    ),
                    SizedBox(height: layoutSize.height * 0.025),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return auth.isLoggedIn
                            ? Text(
                                'menu.you_are_with_us_since'.tr(),
                                textScaleFactor: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                      fontSize: layoutSize.width * 0.037,
                                    ),
                              )
                            : Container();
                      },
                    ),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return Text(
                          auth.isLoggedIn ? auth.firstRegistration : '',
                          textScaleFactor: 1,
                          style: Theme.of(context).textTheme.headline1.copyWith(
                                fontSize: layoutSize.width * 0.037,
                                fontFamily: Assets.englishFontName,
                              ),
                        );
                      },
                    ),
                    SizedBox(height: layoutSize.height * 0.08),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return auth.isLoggedIn
                            ? menuSection(
                                layoutSize,
                                'menu.my_notes'.tr(),
                                Icons.sticky_note_2_rounded,
                                () {
                                  Navigator.pushNamed(
                                      context, ScreensName.notesList);
                                },
                              )
                            : menuSection(
                                layoutSize,
                                'menu.login'.tr(),
                                Icons.login_rounded,
                                () {
                                  Navigator.pushNamed(
                                      context, ScreensName.login);
                                },
                              );
                      },
                    ),
                    Consumer<AuthProvider>(builder: (context, auth, child) {
                      return auth.isLoggedIn
                          ? SizedBox(height: layoutSize.height * 0.04)
                          : Container();
                    }),
                    Consumer<AuthProvider>(builder: (context, auth, child) {
                      return auth.isLoggedIn
                          ? menuSection(layoutSize, 'menu.my_suggestions'.tr(),
                              Icons.text_snippet_rounded, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SuggestionModal()));
                            })
                          : Container();
                    }),
                    SizedBox(height: layoutSize.height * 0.04),
                    menuSection(
                      layoutSize,
                      'menu.about_hutaf'.tr(),
                      Icons.help_rounded,
                      () {
                        Navigator.pushNamed(context, ScreensName.aboutHutaf);
                      },
                    ),
                    SizedBox(height: layoutSize.height * 0.04),
                    menuSection(
                      layoutSize,
                      'menu.success'.tr(),
                      Icons.bubble_chart_rounded,
                      () {
                        Navigator.pushNamed(context, ScreensName.success);
                      },
                    ),
                    SizedBox(height: layoutSize.height * 0.04),
                    menuSection(
                      layoutSize,
                      'menu.privacy'.tr(),
                      Icons.list_rounded,
                      () {
                        Navigator.pushNamed(context, ScreensName.privacyPolicy);
                      },
                    ),
                    SizedBox(height: layoutSize.height * 0.04),
                    menuSection(
                      layoutSize,
                      'menu.rules'.tr(),
                      Icons.list_rounded,
                      () {
                        Navigator.pushNamed(context, ScreensName.rules);
                      },
                    ),
                    SizedBox(height: layoutSize.height * 0.04),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return auth.isLoggedIn
                            ? menuSection(
                                layoutSize,
                                'menu.logout'.tr(),
                                Icons.logout,
                                () {
                                  return showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return CustomDialog(
                                        title: 'menu.logout_title'
                                            .tr(args: [auth.userName]),
                                        buttonText: 'menu.yes'.tr(),
                                        buttonHandler: () {
                                          Provider.of<HomeProvider>(context,
                                                  listen: false)
                                              .homeBooksByInterests = [];
                                          Provider.of<HomeProvider>(context,
                                                  listen: false)
                                              .homeCoursesByInterests = [];
                                          FirebaseAuth.instance.signOut().then(
                                                (value) =>
                                                    Navigator.pop(context),
                                              );
                                        },
                                        textButtonText: 'menu.no'.tr(),
                                        textHandler: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                },
                              )
                            : Container();
                      },
                    ),
                    SizedBox(height: layoutSize.height * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        socialMediaIcon(
                          layoutSize,
                          Ionicons.logo_instagram,
                          () {
                            launch(Uri.parse(
                                'https://instagram.com/hutafapp?utm_medium=copy_link'));
                          },
                        ),
                        SizedBox(width: layoutSize.width * 0.04),
                        socialMediaIcon(
                          layoutSize,
                          Ionicons.logo_twitter,
                          () {
                            launch(
                                Uri.parse('https://twitter.com/hutafapp?s=21'));
                          },
                        ),
                        SizedBox(width: layoutSize.width * 0.04),
                        socialMediaIcon(
                          layoutSize,
                          Ionicons.logo_facebook,
                          () {
                            launch(
                                Uri.parse('https://www.facebook.com/hutafapp'));
                          },
                        ),
                        SizedBox(width: layoutSize.width * 0.04),
                        socialMediaIcon(
                          layoutSize,
                          Ionicons.logo_youtube,
                          () {
                            launch(Uri.parse(
                                'https://youtube.com/channel/UC543j07nI2FbdUrhVnLBDQA'));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'App version 2.1.1',
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontSize: layoutSize.width * 0.04,
                      ),
                ),
              ),
              SizedBox(height: layoutSize.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget socialMediaIcon(Size layoutSize, IconData icon, Function handler) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Icon(
        icon,
        color: AppColors.lightOrange,
        size: layoutSize.width * 0.06,
      ),
      onPressed: handler,
    );
  }

  Widget menuSection(
      Size layoutSize, String title, IconData icon, Function handler) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.lightOrange,
            size: layoutSize.width * 0.05,
          ),
          SizedBox(width: layoutSize.width * 0.02),
          Text(
            title,
            textScaleFactor: 1,
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontSize: layoutSize.width * 0.042,
                ),
          ),
        ],
      ),
      onPressed: handler,
    );
  }

  void launch(Uri url) async {
    try {
      await launchUrl(url);
    } catch (e) {}
  }
}
