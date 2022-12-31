import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class MainScreensAppBar extends StatelessWidget {
  const MainScreensAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.035,
        left: layoutSize.width * 0.035,
      ),
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'main.good_morning'.tr(),
                    textScaleFactor: 1,
                    style:
                        Theme.of(context).primaryTextTheme.headline6.copyWith(
                              fontSize: layoutSize.width * 0.035,
                            ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    auth.isLoggedIn
                        ? auth.userName.length > 10
                            ? auth.userName.substring(0, 10)
                            : auth.userName
                        : 'main.kind_person'.tr(),
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: layoutSize.width * 0.0625,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoButton(
                    minSize: 1,
                    padding: EdgeInsets.zero,
                    child: Container(
                      height: layoutSize.width * 0.085,
                      width: layoutSize.width * 0.085,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Ionicons.search_outline,
                        color: AppColors.darkPink2,
                        size: layoutSize.width * 0.057,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ScreensName.search);
                    },
                  ),
                  SizedBox(width: layoutSize.width * 0.02),
                  // CupertinoButton(
                  //   minSize: 1,
                  //   padding: EdgeInsets.zero,
                  //   child: Container(
                  //     height: layoutSize.width * 0.085,
                  //     width: layoutSize.width * 0.085,
                  //     decoration: BoxDecoration(
                  //       color: AppColors.white,
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     child: Icon(
                  //       Ionicons.notifications_outline,
                  //       color: AppColors.orange,
                  //       size: layoutSize.width * 0.057,
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => NotificationsScreen(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // CupertinoButton(
                  //   minSize: 1,
                  //   padding: EdgeInsets.zero,
                  //   child: Icon(
                  //     Icons.search_rounded,
                  //     size: layoutSize.width * 0.07,
                  //     color: AppColors.lightGrey2,
                  //   ),
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, ScreensName.search);
                  //   },
                  // ),

                  // auth.profilePhoto != ''
                  //     ? ClipRRect(
                  //         borderRadius: BorderRadius.circular(7),
                  //         child: Image.network(
                  //           auth.profilePhoto,
                  //           height: layoutSize.height * 0.07,
                  //           fit: BoxFit.cover,
                  //         ),
                  //       )
                  //     : SvgPicture.asset(
                  //         auth.gender == 1
                  //             ? 'assets/images/girl.svg'
                  //             : 'assets/images/boy.svg',
                  //         height: layoutSize.height * 0.07,
                  //       ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
