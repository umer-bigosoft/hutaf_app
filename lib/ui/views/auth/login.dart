import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/home_provider.dart';
import 'package:Hutaf/ui/widgets/loading/button_loading.dart';
import 'package:Hutaf/ui/widgets/others/auth_rich_text.dart';
import 'package:Hutaf/ui/widgets/titles/auth_top_title_with_image.dart';
import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/ui/widgets/headers/auth_top_header.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String errorEmail = '';
  String errorPassword = '';

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
                        return AuthTopTitleWithImage(
                          title: 'auth.happy_to_see_you_again'.tr(
                            args: [auth.userName],
                          ),
                          subtitle: 'auth.please_login'.tr(),
                          type: auth.gender == 1 ? 'girl' : 'boy',
                        );
                      },
                    ),
                    SizedBox(height: layoutSize.height * 0.06),
                    MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: AppColors.black,
                        textInputAction: TextInputAction.next,
                        cursorWidth: 1,
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2
                            .copyWith(
                              fontSize: layoutSize.width * 0.042,
                            ),
                        decoration: InputDecoration(
                          labelText: 'auth.email'.tr(),
                          errorText: errorEmail,
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
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.lightGrey2,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.purple,
                              width: 1,
                            ),
                          ),
                        ),
                        onChanged: (String value) {
                          errorEmail = '';
                          errorPassword = '';
                        },
                        validator: (String value) {
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: layoutSize.height * 0.04),
                    MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                      child: TextFormField(
                        controller: passwordController,
                        cursorColor: AppColors.black,
                        textInputAction: TextInputAction.done,
                        cursorWidth: 1,
                        maxLines: 1,
                        obscureText: true,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2
                            .copyWith(
                              fontSize: layoutSize.width * 0.042,
                            ),
                        decoration: InputDecoration(
                          labelText: 'auth.password'.tr(),
                          errorText: errorPassword,
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
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.lightGrey2,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.purple,
                              width: 1,
                            ),
                          ),
                        ),
                        onChanged: (String value) {
                          errorPassword = '';
                        },
                        validator: (String value) {
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: layoutSize.height * 0.1),
                    !_isLoading
                        ? Button(
                            text: 'auth.login'.tr(),
                            buttonHeight: layoutSize.width * 0.12,
                            buttonWidth: layoutSize.width,
                            fontSize: layoutSize.width * 0.045,
                            margin: EdgeInsets.only(
                              right: layoutSize.width * 0.1,
                              left: layoutSize.width * 0.1,
                              bottom: layoutSize.height * 0.03,
                            ),
                            handler: () {
                              var email = emailController.text.trim();
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email);
                              if (!emailValid) {
                                setState(() {
                                  errorEmail = 'auth.invalid_email'.tr();
                                });
                                return;
                              }
                              var password = passwordController.text;
                              if (password.length < 6) {
                                setState(() {
                                  errorPassword = 'auth.invalid_password'.tr();
                                });
                                return;
                              }
                              setState(() {
                                _isLoading = true;
                              });
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              )
                                  .then(
                                (value) {
                                  Provider.of<HomeProvider>(context,
                                          listen: false)
                                      .getCoursesByInterests(value.user.uid);
                                  Provider.of<HomeProvider>(context,
                                          listen: false)
                                      .getBooksByInterests(value.user.uid);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pop(context);
                                },
                              ).catchError(
                                (error) {
                                  setState(() {
                                    _isLoading = false;

                                    errorPassword = 'auth.invalid_login'.tr();
                                  });
                                },
                              );
                            },
                          )
                        : LoadingButton(
                            text: 'auth.login'.tr(),
                            buttonHeight: layoutSize.width * 0.12,
                            buttonWidth: layoutSize.width,
                            fontSize: layoutSize.width * 0.045,
                            margin: EdgeInsets.only(
                              right: layoutSize.width * 0.1,
                              left: layoutSize.width * 0.1,
                              bottom: layoutSize.height * 0.03,
                            ),
                          ),
                    CupertinoButton(
                      minSize: 1,
                      padding: EdgeInsets.zero,
                      child: Text(
                        'auth.forget_password_question'.tr(),
                        textScaleFactor: 1,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyText2
                            .copyWith(
                              fontSize: layoutSize.width * 0.04,
                            ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ScreensName.forgetPassword);
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AuthRichText(
                  normalString: 'auth.dont_have_account'.tr() + '  ',
                  underlineString: 'auth.join_hutaf'.tr(),
                  handler: () {
                    Navigator.pushNamed(context, ScreensName.registration);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
