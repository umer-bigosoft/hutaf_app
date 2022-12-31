import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/ui/widgets/loading/button_loading.dart';
import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/ui/widgets/headers/auth_top_header.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class SuggestionModal extends StatefulWidget {
  SuggestionModal({Key key}) : super(key: key);

  @override
  _SuggestionModalState createState() => _SuggestionModalState();
}

class _SuggestionModalState extends State<SuggestionModal> {
  TextEditingController emailController = TextEditingController();

  String errorEmail = '';

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
              AuthTopHeader(isClose: true, suggestion: true),
              SizedBox(height: layoutSize.height * 0.07),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: AppColors.black,
                        textInputAction: TextInputAction.next,
                        cursorWidth: 1,
                        minLines: 3,
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2
                            .copyWith(
                              fontSize: layoutSize.width * 0.042,
                            ),
                        decoration: InputDecoration(
                          labelText: 'قم بكتابة اقتراحك لنا',
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
                        },
                        validator: (String value) {
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: layoutSize.height * 0.04),
                    !_isLoading
                        ? Button(
                            text: 'إرسال',
                            buttonHeight: layoutSize.width * 0.12,
                            buttonWidth: layoutSize.width,
                            fontSize: layoutSize.width * 0.045,
                            margin: EdgeInsets.only(
                              right: layoutSize.width * 0.1,
                              left: layoutSize.width * 0.1,
                              bottom: layoutSize.height * 0.03,
                            ),
                            handler: () async {
                              if (emailController.text.isEmpty)
                                return setState(() {
                                  errorEmail = 'الرجاء كتابة شيء ما';
                                });

                              setState(() {
                                _isLoading = true;
                              });
                              await FirebaseFirestore.instance
                                  .collection('suggestions')
                                  .add({
                                'email': Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .user
                                    .email,
                                'usedId': Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .user
                                    .uid,
                                'suggestion': emailController.text
                              });

                              setState(() {
                                _isLoading = false;
                              });
                              showSimpleNotification(
                                Text(
                                  'شكرا لك، تم إرسال اقتراحك لإدارة التطبيق',
                                  textScaleFactor: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                        fontSize: layoutSize.width * 0.037,
                                      ),
                                ),
                                background: AppColors.blue,
                                duration: Duration(seconds: 4),
                              );
                              Navigator.pop(context);
                            },
                          )
                        : LoadingButton(
                            text: 'إرسال',
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
            ],
          ),
        ),
      ),
    );
  }
}
