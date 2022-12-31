import 'dart:io';

import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/home_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_title_only.dart';
import 'package:Hutaf/ui/widgets/others/custom_dialog.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/ui/widgets/others/not_logged_in_user_content.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'settings/notifications_screen.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    final CustomDivider customDivider = CustomDivider(
      lineWidth: layoutSize.width,
      lineColor: AppColors.lightGrey3,
      marginBottom: layoutSize.height * 0.033,
      marginTop: layoutSize.height * 0.033,
    );
    return Scaffold(
      appBar: AppBarTitleOnly(
        title: 'settings.settings_title'.tr(),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (!auth.isLoggedIn) {
            return NotLoggedInUserContent();
          } else {
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                right: layoutSize.width * 0.035,
                left: layoutSize.width * 0.035,
                bottom: layoutSize.height * 0.04,
              ),
              children: [
                SizedBox(height: layoutSize.height * 0.025),
                header(layoutSize, auth),
                CustomDivider(
                  lineWidth: layoutSize.width * 0.7,
                  lineColor: AppColors.lightGrey3,
                  marginBottom: layoutSize.height * 0.055,
                  marginTop: layoutSize.height * 0.055,
                ),
                settingsOption(
                  layoutSize,
                  'settings.edit_profile'.tr(),
                  Icons.person_rounded,
                  () {
                    Navigator.pushNamed(context, ScreensName.editProfile);
                  },
                ),
                // customDivider,
                // settingsOption(
                //   layoutSize,
                //   'settings.notifications'.tr(),
                //   Icons.notifications_on_rounded,
                //   () {
                //     Navigator.pushNamed(context, ScreensName.notifications);
                //   },
                // ),
                customDivider,
                settingsOption(
                  layoutSize,
                  'settings.change_password'.tr(),
                  Icons.lock_rounded,
                  () {
                    Navigator.pushNamed(context, ScreensName.changePassword);
                  },
                ),
                customDivider,
                settingsOption(
                  layoutSize,
                  'settings.change_email'.tr(),
                  Icons.email_rounded,
                  () {
                    Navigator.pushNamed(context, ScreensName.changeEmail);
                  },
                ),
                customDivider,
                settingsOption(layoutSize, 'settings.notifications'.tr(),
                    Icons.notifications, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsScreen(),
                    ),
                  );
                }),
                customDivider,
                settingsOption(
                  layoutSize,
                  'اهتماماتك',
                  Icons.face,
                  () {
                    Navigator.pushNamed(context, ScreensName.userInterests);
                  },
                ),
                customDivider,
                settingsOption(
                  layoutSize,
                  'settings.logout'.tr(),
                  Icons.logout,
                  () {
                    return showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return CustomDialog(
                          title: 'menu.logout_title'.tr(args: [auth.userName]),
                          buttonText: 'menu.yes'.tr(),
                          buttonHandler: () {
                            Provider.of<HomeProvider>(context, listen: false)
                                .homeBooksByInterests = [];
                            Provider.of<HomeProvider>(context, listen: false)
                                .homeCoursesByInterests = [];
                            FirebaseAuth.instance.signOut().then(
                                  (value) => Navigator.pop(context),
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
                ),
                customDivider,
              ],
            );
          }
        },
      ),
    );
  }

  CupertinoButton settingsOption(
      Size layoutSize, String text, IconData icon, Function handler) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.purple,
            size: layoutSize.width * 0.06,
          ),
          SizedBox(width: layoutSize.width * 0.02),
          Expanded(
            child: Text(
              text,
              textScaleFactor: 1,
              style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                    fontSize: layoutSize.width * 0.042,
                  ),
            ),
          )
        ],
      ),
      onPressed: handler,
    );
  }

  Widget header(Size layoutSize, AuthProvider auth) {
    // print('profile photo');
    // print(auth.profilePhoto);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoButton(
          minSize: 1,
          padding: EdgeInsets.zero,
          child: auth.profilePhoto == ''
              ? SvgPicture.asset(
                  auth.gender == 0
                      ? 'assets/images/boy.svg'
                      : 'assets/images/girl.svg',
                  height: layoutSize.height * 0.22,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: NetworkImage(auth.profilePhoto),
                    fit: BoxFit.cover,
                    height: layoutSize.height * 0.22,
                    width: layoutSize.height * 0.22,
                  ),
                ),
          onPressed: () {
            final action = CupertinoActionSheet(
              title: Text(
                'settings.change_profile_image_title'.tr(),
                textScaleFactor: 1,
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      fontSize: layoutSize.width * 0.03,
                    ),
              ),
              actions: [
                CupertinoActionSheetAction(
                  child: Text(
                    'settings.choose_from_gallery'.tr(),
                    textScaleFactor: 1,
                    style:
                        Theme.of(context).primaryTextTheme.headline2.copyWith(
                              fontSize: layoutSize.width * 0.04,
                            ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      _uploadFile(File(pickedFile.path));
                    }
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(
                    'settings.choose_from_camera'.tr(),
                    textScaleFactor: 1,
                    style:
                        Theme.of(context).primaryTextTheme.headline2.copyWith(
                              fontSize: layoutSize.width * 0.04,
                            ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      _uploadFile(File(pickedFile.path));
                    }
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text(
                  'settings.cancel'.tr(),
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: layoutSize.width * 0.04,
                      ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
            showCupertinoModalPopup(
              context: context,
              builder: (context) => action,
            );
          },
        ),
        SizedBox(width: layoutSize.width * 0.035),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                auth.userName,
                textScaleFactor: 1,
                style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                      fontSize: layoutSize.width * 0.045,
                    ),
              ),
              Text(
                auth.user.email,
                textScaleFactor: 1,
                style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                      fontSize: layoutSize.width * 0.035,
                      fontFamily: Assets.englishFontName,
                    ),
              ),
              SizedBox(height: 8),
              Text(
                auth.info,
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: layoutSize.width * 0.035,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Null> _uploadFile(File file) async {
    final String uid =
        Provider.of<AuthProvider>(context, listen: false).user.uid;
    final Reference ref = FirebaseStorage.instance.ref().child("profiles/$uid");
    final UploadTask uploadTask = ref.putFile(file);
    await uploadTask;
    Provider.of<AuthProvider>(context, listen: false).setProfilePhoto(uid);
  }
}
