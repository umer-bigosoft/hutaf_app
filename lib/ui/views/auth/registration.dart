import 'package:Hutaf/models/auth/new_user_model.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/ui/views/auth/otp.dart';
import 'package:Hutaf/ui/widgets/loading/button_loading.dart';
import 'package:Hutaf/ui/widgets/others/auth_rich_text.dart';
import 'package:Hutaf/ui/widgets/titles/auth_top_title_with_image.dart';
import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/ui/widgets/headers/auth_top_header.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/utils.dart';
import 'package:country_picker/src/res/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  List<Item> gender = <Item>[
    Item(
      'auth.boy'.tr(),
      0,
    ),
    Item(
      'auth.girl'.tr(),
      1,
    ),
  ];
  Item selectedUser;

  String errorEmail = '';
  String errorPassword = '';
  String errorName = '';
  String errorPhone = '';
  String errorGender = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode _phoneFocusNode = FocusNode();

  bool _isLoading = false;
  Country selectedCountry = Country.from(
      json: countryCodes.singleWhere((element) => element['iso2_cc'] == "OM"));

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
                    AuthTopTitleWithImage(
                      title: 'auth.hello_great_person'.tr(),
                      subtitle: 'auth.registeration_text'.tr(),
                      type: selectedUser != null && selectedUser.code == 1
                          ? 'girl'
                          : 'boy',
                    ),
                    SizedBox(height: layoutSize.height * 0.06),
                    emailTextFormField(layoutSize),
                    SizedBox(height: layoutSize.height * 0.04),
                    passwordTextFormField(layoutSize),
                    SizedBox(height: layoutSize.height * 0.04),
                    nameTextFormField(layoutSize),
                    SizedBox(height: layoutSize.height * 0.04),
                    phoneTextFormField(layoutSize),
                    SizedBox(height: layoutSize.height * 0.04),
                    genderDropdownList(layoutSize),
                    Text(
                      errorGender,
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 13,
                            color: Colors.red[700],
                          ),
                    ),
                    SizedBox(height: layoutSize.height * 0.1),
                    !_isLoading
                        ? Button(
                            text: 'auth.register'.tr(),
                            buttonHeight: layoutSize.width * 0.12,
                            buttonWidth: layoutSize.width,
                            fontSize: layoutSize.width * 0.045,
                            margin: EdgeInsets.only(
                              right: layoutSize.width * 0.1,
                              left: layoutSize.width * 0.1,
                              bottom: layoutSize.height * 0.03,
                            ),
                            handler: () {
                              NewUserModel newUser = validateInputs();
                              // print(newUser.phone);
                              if (newUser == null) {
                                return;
                              }
                              setState(() {
                                _isLoading = true;
                              });
                              // Check for the number
                              // If not exist, complete
                              // Otherwise stop the registration & focus the phone number field
                              Provider.of<AuthProvider>(context, listen: false)
                                  .checkIfUserPhoneNumberExist(newUser.phone)
                                  .then((value) {
                                    // print(value);
                                if (value == 0) {
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .register(newUser, () {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    // Navigator.pushNamed(context, ScreensName.otp);
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Otp(
                                          userName: nameController.text,
                                        ),
                                      ),
                                    );
                                  }, onError: (error) {
                                    setState(() {
                                      _isLoading = false;
                                      if (error == 'weak-password')
                                        errorPassword = 'auth.$error'.tr();
                                      else
                                        errorEmail = 'auth.$error'.tr();
                                    });
                                  });
                                } else if (value == 1) {
                                  // The phone number already exist
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showSimpleNotification(
                                    Text(
                                      'رقم الهاتف مسجّل من قبل !',
                                      textScaleFactor: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .copyWith(
                                            fontSize: layoutSize.width * 0.037,
                                          ),
                                    ),
                                    background: AppColors.pink,
                                    duration: Duration(milliseconds: 1000),
                                  );
                                  _phoneFocusNode.requestFocus();
                                } else {
                                  // Something went wrong
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showSimpleNotification(
                                    Text(
                                      'حدث خطأ ما ، الرجاء المحاولة مرة أخرى',
                                      textScaleFactor: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .copyWith(
                                            fontSize: layoutSize.width * 0.037,
                                          ),
                                    ),
                                    background: AppColors.pink,
                                    duration: Duration(milliseconds: 1000),
                                  );
                                }
                              });
                            },
                          )
                        : LoadingButton(
                            text: 'auth.register'.tr(),
                            buttonHeight: layoutSize.width * 0.12,
                            buttonWidth: layoutSize.width,
                            fontSize: layoutSize.width * 0.045,
                            margin: EdgeInsets.only(
                              right: layoutSize.width * 0.1,
                              left: layoutSize.width * 0.1,
                              bottom: layoutSize.height * 0.03,
                            ),
                          ),
                    AuthRichText(
                      normalString: 'auth.has_account'.tr() + '  ',
                      underlineString: 'auth.login'.tr(),
                      handler: () {
                        Navigator.pushReplacementNamed(
                            context, ScreensName.login);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: layoutSize.height * 0.05),
              Align(
                alignment: Alignment.bottomCenter,
                child: privacyCupertinoButton(layoutSize),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget privacyCupertinoButton(Size layoutSize) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'auth.registeration_agreement'.tr(),
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
                  fontSize: layoutSize.width * 0.032,
                ),
          ),
          Text(
            'auth.privacy'.tr(),
            textScaleFactor: 1,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: layoutSize.width * 0.037,
                  decoration: TextDecoration.underline,
                  decorationThickness: 20,
                ),
          ),
        ],
      ),
      onPressed: () {
        Navigator.pushNamed(context, ScreensName.privacyPolicy);
      },
    );
  }

  Widget genderDropdownList(Size layoutSize) {
    return DropdownButton(
      icon: Icon(Icons.keyboard_arrow_down_rounded),
      isExpanded: true,
      value: selectedUser,
      items: gender.map((Item user) {
        return DropdownMenuItem<Item>(
          value: user,
          child: Text(
            user.name,
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                  fontSize: layoutSize.width * 0.042,
                ),
          ),
          //     Row(
          //   children: <Widget>[
          //     user.icon,
          //     SizedBox(
          //       width: 10,
          //     ),

          //   ],
          // ),
        );
      }).toList(),
      onChanged: (selectedItem) => setState(
        () {
          selectedUser = selectedItem;
          errorGender = '';
        },
      ),
      hint: Text(
        'auth.gender'.tr(),
        textScaleFactor: 1,
        style: Theme.of(context).primaryTextTheme.bodyText2.copyWith(
              fontSize: layoutSize.width * 0.042,
            ),
      ),
    );
  }

  Widget phoneTextFormField(Size layoutSize) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: layoutSize.height * 0.075,
            width: layoutSize.height * 0.125,
            child: TextButton(
                Widget: Text(
                  '${Utils.countryCodeToEmoji(selectedCountry.countryCode)} +${selectedCountry.phoneCode}',
                  style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                        fontSize: layoutSize.width * 0.042,
                        color: AppColors.lightGrey,
                      ),
                ),
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    exclude: <String>['IL'],
                    showPhoneCode:
                        true, // optional. Shows phone code before the country name.
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = country;
                        FocusScope.of(context).unfocus();
                      });
                    },
                  );
                }),
          ),
          Expanded(
            child: TextFormField(
              controller: phoneController,
              cursorColor: AppColors.black,
              textInputAction: TextInputAction.next,
              cursorWidth: 1,
              keyboardType: TextInputType.phone,
              focusNode: _phoneFocusNode,
              maxLines: 1,
              style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                    fontSize: layoutSize.width * 0.042,
                  ),
              decoration: InputDecoration(
                errorText: errorPhone,
                labelText: 'auth.phone'.tr(),
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 5),
                labelStyle:
                    Theme.of(context).primaryTextTheme.bodyText2.copyWith(
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
              onChanged: (String vlaue) {
                errorPhone = '';
              },
              validator: (String value) {
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget nameTextFormField(Size layoutSize) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: TextFormField(
        controller: nameController,
        cursorColor: AppColors.black,
        textInputAction: TextInputAction.next,
        cursorWidth: 1,
        maxLines: 1,
        maxLength: 10,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
              fontSize: layoutSize.width * 0.042,
            ),
        decoration: InputDecoration(
          errorText: errorName,
          labelText: 'auth.name'.tr(),
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
        onChanged: (String vlaue) {
          errorName = '';
        },
        validator: (String value) {
          return null;
        },
      ),
    );
  }

  Widget passwordTextFormField(Size layoutSize) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: TextFormField(
        controller: passwordController,
        cursorColor: AppColors.black,
        textInputAction: TextInputAction.next,
        cursorWidth: 1,
        maxLines: 1,
        obscureText: true,
        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
              fontSize: layoutSize.width * 0.042,
            ),
        decoration: InputDecoration(
          errorText: errorPassword,
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
        onChanged: (String vlaue) {
          errorPassword = '';
        },
        validator: (String value) {
          return null;
        },
      ),
    );
  }

  Widget emailTextFormField(Size layoutSize) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: TextFormField(
        controller: emailController,
        cursorColor: AppColors.black,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        cursorWidth: 1,
        maxLines: 1,
        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
              fontSize: layoutSize.width * 0.042,
            ),
        decoration: InputDecoration(
          errorText: errorEmail,
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
        onChanged: (String vlaue) {
          errorEmail = '';
        },
        validator: (String value) {
          return null;
        },
      ),
    );
  }

  NewUserModel validateInputs() {
    bool valid = true;

    var email = emailController.text.trim();
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      errorEmail = 'auth.invalid_email'.tr();
      valid = false;
    }

    var password = passwordController.text;
    if (password.length < 6) {
      errorPassword = 'auth.invalid_password'.tr();
      valid = false;
    }

    var name = nameController.text.trim();
    if (name.length < 2) {
      errorName = 'auth.invalid_name'.tr();
      valid = false;
    }

    var phone = phoneController.text.trim();
    if (phone.length < 4) {
      errorPhone = 'auth.invalid_phone'.tr();
      valid = false;
    }

    if (selectedUser == null) {
      errorGender = 'auth.invalid_gender'.tr();
      valid = false;
    }
    var gender = selectedUser.code;

    if (!valid) {
      setState(() {});
      return null;
    }
    return NewUserModel(
      name: name,
      email: email,
      password: password,
      phone: '+' + selectedCountry.phoneCode + phone,
      code: selectedCountry.phoneCode,
      countryCode: selectedCountry.countryCode,
      gender: gender,
    );
  }
}

class Item {
  const Item(
    this.name,
    this.code,
  );
  final String name;
  final int code;
  // final Icon icon;
}

// src country picker
final OMAN = {
  "e164_cc": "968",
  "iso2_cc": "OM",
  "e164_sc": 0,
  "geographic": true,
  "level": 1,
  "name": "Oman",
  "example": "92123456",
  "display_name": "Oman (OM) [+968]",
  "full_example_with_plus_sign": "+96892123456",
  "display_name_no_e164_cc": "Oman (OM)",
  "e164_key": "968-OM-0"
};
