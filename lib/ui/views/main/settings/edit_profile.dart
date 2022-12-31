import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/ui/views/auth/otp.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/loading/rectangle_button_loading.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:country_picker/src/utils.dart';
import 'package:country_picker/src/res/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _infoController = TextEditingController();

  bool _isInit = false;
  bool _isLoading = false;

  String _nameError;
  String _infoError;
  String _phoneError;
  Country selectedCountry;
  bool _isVerified = false;

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    if (!_isInit) {
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      _nameController.text = authProvider.userName;
      _phoneController.text =
          authProvider.phoneNumber.replaceAll('+' + authProvider.phoneCode, '');
      _infoController.text = authProvider.info;
      selectedCountry = Country.from(
          json: countryCodes.singleWhere((element) =>
              element['e164_cc'] == authProvider.phoneCode &&
              element['iso2_cc'] == authProvider.countryCode));
      _isVerified = authProvider.user.phoneNumber != null;
      _isInit = true;
    }
    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'settings.edit_profile'.tr(),
        handler: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          SizedBox(height: layoutSize.height * 0.03),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                right: layoutSize.width * 0.035,
                left: layoutSize.width * 0.035,
              ),
              children: [
                nameTextFormField(layoutSize),
                SizedBox(height: layoutSize.height * 0.04),
                phoneTextFormField(layoutSize),
                SizedBox(height: layoutSize.height * 0.04),
                descriptionTextFormField(layoutSize),
                SizedBox(height: layoutSize.height * 0.05),
              ],
            ),
          ),
          !_isLoading
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 1,
                    child: Container(
                      width: layoutSize.width,
                      height: layoutSize.width * 0.14,
                      color: AppColors.darkPink,
                      child: Center(
                        child: Text(
                          'settings.edit'.tr(),
                          textScaleFactor: 1,
                          style: Theme.of(context).textTheme.headline1.copyWith(
                                fontSize: layoutSize.width * 0.047,
                              ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      String name = _nameController.text.trim();
                      String info = _infoController.text.trim();
                      String phone = '+' +
                          selectedCountry.phoneCode +
                          _phoneController.text.trim();

                      if (name.length < 2) {
                        setState(() {
                          _nameError = 'auth.invalid_name'.tr();
                        });
                        return;
                      } else
                        _nameError = null;
                      setState(() {
                        _isLoading = true;
                      });
                      Provider.of<AuthProvider>(context, listen: false)
                          .updateProfile(
                              name,
                              info,
                              phone,
                              selectedCountry.phoneCode,
                              selectedCountry.countryCode)
                          .then((value) {
                        var provider =
                            Provider.of<AuthProvider>(context, listen: false);
                        if (provider.user.phoneNumber != phone)
                          provider.sendVerificationCode(phone, () {
                            // print('code sent');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Otp(
                                  userName: '',
                                ),
                              ),
                            );
                          }, onError: (error) {
                            // print(error);
                            Navigator.pop(context);
                          });
                        else
                          Navigator.pop(context);
                      }).catchError((onError) {
                        setState(() {
                          _isLoading = false;
                        });
                        showSimpleNotification(
                          Text(
                            'الرجاء إعادة المحاولة !',
                            textScaleFactor: 1,
                            style:
                                Theme.of(context).textTheme.headline1.copyWith(
                                      fontSize: layoutSize.width * 0.037,
                                    ),
                          ),
                          background: AppColors.pink,
                          duration: Duration(seconds: 2),
                        );
                      });
                    },
                  ),
                )
              : RectangleButtonLoading(text: 'settings.edit'.tr()),
        ],
      ),
    );
  }

  Widget nameTextFormField(Size layoutSize) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: TextFormField(
        controller: _nameController,
        cursorColor: AppColors.black,
        textInputAction: TextInputAction.next,
        cursorWidth: 1,
        maxLines: 1,
        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
              fontSize: layoutSize.width * 0.042,
            ),
        decoration: InputDecoration(
          errorText: _nameError,
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
        ),
        onSaved: (String value) {},
        validator: (String value) {
          return null;
        },
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
                child: Text(
                  '${Utils.countryCodeToEmoji(selectedCountry.countryCode)} +${selectedCountry.phoneCode}',
                  style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                        fontSize: layoutSize.width * 0.042,
                        color: AppColors.lightGrey,
                      ),
                ),
                onPressed: () {
                  if (!_isVerified)
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
              controller: _phoneController,
              enabled: !_isVerified,
              cursorColor: AppColors.black,
              textInputAction: TextInputAction.next,
              cursorWidth: 1,
              keyboardType: TextInputType.phone,
              maxLines: 1,
              style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                    fontSize: layoutSize.width * 0.042,
                  ),
              decoration: InputDecoration(
                errorText: _phoneError,
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
                _phoneError = '';
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

  Widget descriptionTextFormField(Size layoutSize) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: TextFormField(
        controller: _infoController,
        cursorColor: AppColors.black,
        textInputAction: TextInputAction.newline,
        cursorWidth: 1,
        maxLines: 6,
        style: Theme.of(context).primaryTextTheme.headline2.copyWith(
              fontSize: layoutSize.width * 0.042,
            ),
        decoration: InputDecoration(
          errorText: _infoError,
          labelText: 'settings.description'.tr(),
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
