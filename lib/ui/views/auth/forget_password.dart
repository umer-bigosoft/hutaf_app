import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/ui/widgets/loading/button_loading.dart';
import 'package:Hutaf/ui/widgets/others/auth_rich_text.dart';
import 'package:Hutaf/ui/widgets/headers/auth_top_header.dart';
import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:Hutaf/ui/widgets/titles/auth_top_title_without_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              right: layoutSize.width * 0.045, left: layoutSize.width * 0.045),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTopHeader(isClose: true),
              SizedBox(height: layoutSize.height * 0.07),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return AuthTopTitleWithoutImage(
                          title: 'auth.will_help_you'.tr(args: [auth.userName]),
                          subtitle: 'auth.please_write_your_email'.tr(),
                        );
                      },
                    ),
                    SizedBox(height: layoutSize.height * 0.06),
                    MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                      child: TextFormField(
                        cursorColor: AppColors.black,
                        textInputAction: TextInputAction.next,
                        controller: _emailController,
                        cursorWidth: 1,
                        maxLines: 1,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2
                            .copyWith(
                              fontSize: layoutSize.width * 0.042,
                            ),
                        decoration: InputDecoration(
                          labelText: 'auth.email'.tr(),
                          isDense: true,
                          contentPadding: EdgeInsets.only(bottom: 5),
                          labelStyle: Theme.of(context)
                              .primaryTextTheme
                              .bodyText2
                              .copyWith(
                                fontSize: layoutSize.width * 0.042,
                              ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.lightGrey2,
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.purple,
                              width: 1,
                            ),
                          ),
                        ),
                        validator: (String value) {
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: layoutSize.height * 0.13),
                    !_isLoading
                        ? Button(
                            text: 'auth.send'.tr(),
                            buttonHeight: layoutSize.width * 0.12,
                            buttonWidth: layoutSize.width,
                            fontSize: layoutSize.width * 0.045,
                            margin: EdgeInsets.only(
                              right: layoutSize.width * 0.1,
                              left: layoutSize.width * 0.1,
                              bottom: layoutSize.height * 0.03,
                            ),
                            handler: () {
                              if (_emailController.text.trim().length > 0) {
                                resetPassword(_emailController.text);
                              } else {
                                showSimpleNotification(
                                  Text(
                                    'الرجاء إدخال عنوان البريد الالكتروني',
                                    textScaleFactor: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                          fontSize: layoutSize.width * 0.037,
                                        ),
                                  ),
                                  background: AppColors.pink,
                                  duration: Duration(seconds: 2),
                                );
                              }
                            },
                          )
                        : LoadingButton(
                            text: 'auth.send'.tr(),
                            buttonHeight: layoutSize.width * 0.12,
                            buttonWidth: layoutSize.width,
                            fontSize: layoutSize.width * 0.045,
                            margin: EdgeInsets.only(
                              right: layoutSize.width * 0.1,
                              left: layoutSize.width * 0.1,
                              bottom: layoutSize.height * 0.03,
                            ),
                          ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AuthRichText(
                  normalString: 'auth.has_account'.tr() + '  ',
                  underlineString: 'auth.login'.tr(),
                  handler: () {
                    Navigator.pushReplacementNamed(context, ScreensName.login);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword(String email) async {
    setState(() {
      _isLoading = true;
    });
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });
  }
}
