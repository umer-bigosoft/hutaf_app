import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/ui/widgets/loading/button_loading.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class ChangeEmail extends StatefulWidget {
  ChangeEmail({Key key}) : super(key: key);

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool _isInit = false;

  String _passwordError;
  String _emailError;

  bool _isVerified = false;
  bool _isLoadingEdit = false;
  bool _isLoadingVerify = false;

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    if (!_isInit) {
      _emailController.text =
          Provider.of<AuthProvider>(context, listen: false).user.email;
      _isInit = true;
    }
    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'settings.change_email'.tr(),
        handler: () {
          Navigator.pop(context);
        },
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: layoutSize.height * 0.03,
          right: layoutSize.width * 0.035,
          left: layoutSize.width * 0.035,
        ),
        children: buildWidgets(layoutSize),
      ),
    );
  }

  List<Widget> buildWidgets(Size layoutSize) {
    if (!_isVerified)
      return [
        // Text(
        //   'auth.change_email_note'.tr(),
        //   textScaleFactor: 1,
        //   style: Theme.of(context).primaryTextTheme.headline2.copyWith(
        //         fontSize: layoutSize.width * 0.042,
        //       ),
        // ),
        // SizedBox(height: layoutSize.height * 0.04),
        MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: TextFormField(
            controller: _passwordController,
            cursorColor: AppColors.black,
            textInputAction: TextInputAction.done,
            cursorWidth: 1,
            obscureText: true,
            maxLines: 1,
            style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                  fontSize: layoutSize.width * 0.042,
                ),
            decoration: InputDecoration(
              errorText: _passwordError,
              labelText: 'auth.password'.tr(),
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 5),
              labelStyle: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
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
            onSaved: (String value) {},
            validator: (String value) {
              return value.length < 6 ? 'Too short.' : null;
            },
          ),
        ),
        SizedBox(height: layoutSize.height * 0.13),
        !_isLoadingVerify
            ? Button(
                text: 'settings.verify'.tr(),
                buttonHeight: layoutSize.width * 0.12,
                buttonWidth: layoutSize.width,
                fontSize: layoutSize.width * 0.045,
                margin: EdgeInsets.only(
                  right: layoutSize.width * 0.1,
                  left: layoutSize.width * 0.1,
                  bottom: layoutSize.height * 0.03,
                ),
                handler: () {
                  var password = _passwordController.text.trim();
                  if (password.length < 6) {
                    setState(() {
                      _emailError = 'auth.invalid_password'.tr();
                    });
                    return;
                  } else {
                    setState(() {
                      _passwordError = null;
                      _isLoadingVerify = true;
                    });
                  }

                  Provider.of<AuthProvider>(context, listen: false)
                      .verifyPassword(password)
                      .then(
                    (value) {
                      if (value) {
                        _isVerified = true;
                      } else {
                        _passwordError = 'auth.wrong_password'.tr();
                      }
                      _isLoadingVerify = false;

                      setState(() {});
                    },
                  ).catchError((error) {
                    setState(() {
                      _isLoadingVerify = false;
                      _passwordError = 'auth.wrong_password'.tr();
                    });
                  });
                },
              )
            : LoadingButton(
                text: 'settings.verify'.tr(),
                buttonHeight: layoutSize.width * 0.12,
                buttonWidth: layoutSize.width,
                fontSize: layoutSize.width * 0.045,
                margin: EdgeInsets.only(
                  right: layoutSize.width * 0.1,
                  left: layoutSize.width * 0.1,
                  bottom: layoutSize.height * 0.03,
                ),
              ),
      ];

    return [
      MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          cursorColor: AppColors.black,
          textInputAction: TextInputAction.done,
          cursorWidth: 1,
          maxLines: 1,
          style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                fontSize: layoutSize.width * 0.042,
              ),
          decoration: InputDecoration(
            errorText: _emailError,
            labelText: 'auth.email'.tr(),
            isDense: true,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelStyle: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
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
          onSaved: (String value) {},
          validator: (String value) {
            return value.contains('@') ? 'Do not use the @ char.' : null;
          },
        ),
      ),
      SizedBox(height: layoutSize.height * 0.13),
      !_isLoadingEdit
          ? Button(
              text: 'settings.edit'.tr(),
              buttonHeight: layoutSize.width * 0.12,
              buttonWidth: layoutSize.width,
              fontSize: layoutSize.width * 0.045,
              margin: EdgeInsets.only(
                right: layoutSize.width * 0.1,
                left: layoutSize.width * 0.1,
                bottom: layoutSize.height * 0.03,
              ),
              handler: () {
                var email = _emailController.text.trim();
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(email);
                if (!emailValid) {
                  setState(() {
                    _emailError = 'auth.invalid_email'.tr();
                  });
                  return;
                } else
                  setState(() {
                    _emailError = null;
                  });

                setState(() {
                  _isLoadingEdit = true;
                });
                Provider.of<AuthProvider>(context, listen: false)
                    .updateEmail(email)
                    .then((value) {
                  setState(() {
                    _isLoadingEdit = false;
                  });
                  Navigator.pop(context);
                }).catchError((error) {
                  // print(error);
                  setState(() {
                    _isLoadingEdit = false;
                    _emailError = 'auth.invalid_email'.tr();
                  });
                });
              },
            )
          : LoadingButton(
              text: 'settings.edit'.tr(),
              buttonHeight: layoutSize.width * 0.12,
              buttonWidth: layoutSize.width,
              fontSize: layoutSize.width * 0.045,
              margin: EdgeInsets.only(
                right: layoutSize.width * 0.1,
                left: layoutSize.width * 0.1,
                bottom: layoutSize.height * 0.03,
              ),
            ),
    ];
  }
}
