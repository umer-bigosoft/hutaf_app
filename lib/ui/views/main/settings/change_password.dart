import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/ui/widgets/loading/button_loading.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String _oldPasswordError;
  String _newPasswordError;
  String _repeatPasswordError;
  bool _isLoading = false;
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'settings.change_password'.tr(),
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
        children: [
          oldPasswordTextField(layoutSize),
          SizedBox(height: layoutSize.height * 0.05),
          newPasswordTextField(layoutSize),
          SizedBox(height: layoutSize.height * 0.05),
          repeatPasswordTextField(layoutSize),
          SizedBox(height: layoutSize.height * 0.13),
          !_isLoading
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
                    String oldPassword = _oldPasswordController.text;
                    String newPassword = _newPasswordController.text;
                    String repeatPassword = _repeatPasswordController.text;

                    if (oldPassword.length < 6) {
                      setState(() {
                        _oldPasswordError = 'auth.invalid_password'.tr();
                      });
                      return;
                    } else
                      _oldPasswordError = null;

                    if (newPassword.length < 6) {
                      setState(() {
                        _newPasswordError = 'auth.invalid_password'.tr();
                      });
                      return;
                    } else
                      _newPasswordError = null;

                    if (newPassword == oldPassword) {
                      setState(() {
                        _newPasswordError = 'auth.invalid_new_password'.tr();
                      });
                      return;
                    } else
                      _newPasswordError = null;

                    if (newPassword != repeatPassword) {
                      setState(() {
                        _repeatPasswordError =
                            'auth.invalid_repeat_password'.tr();
                      });
                      return;
                    } else
                      _repeatPasswordError = null;
                    setState(() {
                      _isLoading = true;
                    });

                    Provider.of<AuthProvider>(context, listen: false)
                        .updatePassword(oldPassword, newPassword)
                        .then(
                      (value) {
                        if (value == null) // password changed
                        {
                          Navigator.pop(context);
                          return;
                        } else if (value == 'invalid') {
                          _oldPasswordError = 'auth.wrong_password'.tr();
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          _newPasswordError =
                              'auth.failed_change_password'.tr();

                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                    );
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
        ],
      ),
    );
  }

  Widget oldPasswordTextField(Size layoutSize) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: TextFormField(
        controller: _oldPasswordController,
        cursorColor: AppColors.black,
        textInputAction: TextInputAction.next,
        cursorWidth: 1,
        maxLines: 1,
        obscureText: true,
        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
              fontSize: layoutSize.width * 0.042,
            ),
        decoration: InputDecoration(
          errorText: _oldPasswordError,
          labelText: 'settings.old_password'.tr(),
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
          return null;
        },
      ),
    );
  }

  Widget newPasswordTextField(Size layoutSize) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: TextFormField(
        controller: _newPasswordController,
        cursorColor: AppColors.black,
        textInputAction: TextInputAction.next,
        cursorWidth: 1,
        maxLines: 1,
        obscureText: true,
        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
              fontSize: layoutSize.width * 0.042,
            ),
        decoration: InputDecoration(
          errorText: _newPasswordError,
          labelText: 'settings.new_password'.tr(),
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
          return null;
        },
      ),
    );
  }

  Widget repeatPasswordTextField(Size layoutSize) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: TextFormField(
        controller: _repeatPasswordController,
        cursorColor: AppColors.black,
        textInputAction: TextInputAction.done,
        cursorWidth: 1,
        maxLines: 1,
        obscureText: true,
        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
              fontSize: layoutSize.width * 0.042,
            ),
        decoration: InputDecoration(
          errorText: _repeatPasswordError,
          labelText: 'settings.repeat_password'.tr(),
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
          return null;
        },
      ),
    );
  }
}
