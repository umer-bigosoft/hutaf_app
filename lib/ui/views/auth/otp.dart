import 'dart:async';

import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/ui/widgets/loading/button_loading.dart';
import 'package:Hutaf/ui/widgets/others/auth_rich_text.dart';
import 'package:Hutaf/ui/widgets/headers/auth_top_header.dart';
import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/ui/widgets/bottom_sheets/success_otp_bottom_sheet.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:Hutaf/ui/widgets/titles/auth_top_title_without_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Otp extends StatefulWidget {
  final String userName;
  Otp({Key key, this.userName}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController otpController = TextEditingController();

  String errorOTP = '';
  bool _isLoading = false;
  // bool _isInit = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

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
              AuthTopHeader(),
              SizedBox(height: layoutSize.height * 0.07),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Consumer<AuthProvider>(
                    // builder: (context, auth, child) {
                    AuthTopTitleWithoutImage(
                      title: 'auth.hello_user'.tr(args: [widget.userName]),
                      subtitle: 'auth.otp_text'.tr(),
                      // );
                      // },
                    ),
                    SizedBox(height: layoutSize.height * 0.06),
                    otpTextFormField(layoutSize),
                    SizedBox(height: layoutSize.height * 0.1),
                    !_isLoading
                        ? Button(
                            text: 'auth.verify'.tr(),
                            buttonHeight: layoutSize.width * 0.12,
                            buttonWidth: layoutSize.width,
                            fontSize: layoutSize.width * 0.045,
                            margin: EdgeInsets.only(
                              right: layoutSize.width * 0.1,
                              left: layoutSize.width * 0.1,
                              bottom: layoutSize.height * 0.03,
                            ),
                            handler: () {
                              if (otpController.text.trim().length == 6) {
                                setState(() {
                                  _isLoading = true;
                                });
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .verify(otpController.text.trim())
                                    .then(
                                  (value) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (widget.userName != '') {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return SuccessOtpBottomSheet();
                                        },
                                      );
                                    } else
                                      Navigator.pop(context);
                                  },
                                ).catchError(
                                  (error) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    // _isLoading = false;
                                    if (error == 'credential-already-in-use' || error == 'unkown')
                                      errorOTP =
                                          'auth.credential-already-in-use'.tr();
                                    else
                                      errorOTP =
                                          'auth.invalid_verification'.tr();
                                  },
                                );
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                                // _isLoading = false;
                                errorOTP = 'auth.invalid_otp'.tr();
                              }
                            },
                          )
                        : LoadingButton(
                            text: 'auth.verify'.tr(),
                            buttonHeight: layoutSize.width * 0.12,
                            buttonWidth: layoutSize.width,
                            fontSize: layoutSize.width * 0.045,
                            margin: EdgeInsets.only(
                              right: layoutSize.width * 0.1,
                              left: layoutSize.width * 0.1,
                              bottom: layoutSize.height * 0.03,
                            ),
                          ),
                    SizedBox(height: layoutSize.height * 0.05),
                    _timeout == 0
                        ? AuthRichText(
                            normalString: 'auth.not_receive_otp'.tr() + '  ',
                            underlineString: 'auth.resend'.tr(),
                            handler: () {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .resendToken(
                                () {
                                  startTimer();
                                },
                              ).catchError(
                                (error) {
                                  errorOTP = 'auth.failed_resend'.tr();
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'إعادة الإرسال بعد ' + '$_timeout' + ' ثانية',
                              textScaleFactor: 1,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText2
                                  .copyWith(
                                    fontSize: layoutSize.width * 0.04,
                                  ),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget otpTextFormField(Size layoutSize) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: TextFormField(
        controller: otpController,
        cursorColor: AppColors.black,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        cursorWidth: 1,
        maxLines: 1,
        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
              fontSize: layoutSize.width * 0.042,
            ),
        decoration: InputDecoration(
          errorText: errorOTP,
          labelText: 'auth.otp'.tr(),
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
          errorOTP = '';
        },
        validator: (String value) {
          return value.trim().length != 6 ? 'auth.invalidOTP'.tr() : null;
        },
      ),
    );
  }

  Timer _timer;
  int _timeout = 60;

  void startTimer() {
    _timeout = 60;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeout == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _timeout--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
