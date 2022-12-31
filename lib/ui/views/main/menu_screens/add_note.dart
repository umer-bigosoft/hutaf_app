import 'package:Hutaf/providers/menu/note_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/buttons/rectangle_button.dart';
import 'package:Hutaf/ui/widgets/loading/rectangle_button_loading.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  AddNote({Key key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final titleController = TextEditingController();
  final textController = TextEditingController();
  // bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'notes.notes_list_title'.tr(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: layoutSize.height * 0.04),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: layoutSize.width * 0.045,
                right: layoutSize.width * 0.045,
              ),
              children: [
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                  child: TextFormField(
                    controller: titleController,
                    cursorColor: AppColors.black,
                    textInputAction: TextInputAction.next,
                    cursorWidth: 1,
                    maxLines: 1,
                    style:
                        Theme.of(context).primaryTextTheme.headline2.copyWith(
                              fontSize: layoutSize.width * 0.042,
                            ),
                    decoration: InputDecoration(
                      labelText: 'notes.note_title'.tr(),
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
                    ),
                  ),
                ),
                SizedBox(height: layoutSize.height * 0.08),
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                  child: TextFormField(
                    controller: textController,
                    cursorColor: AppColors.black,
                    textInputAction: TextInputAction.newline,
                    cursorWidth: 1,
                    maxLines: 15,
                    style:
                        Theme.of(context).primaryTextTheme.headline2.copyWith(
                              fontSize: layoutSize.width * 0.042,
                            ),
                    decoration: InputDecoration(
                      labelText: 'notes.note_description'.tr(),
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: layoutSize.height * 0.02),
          Consumer<NoteProvider>(
            builder: (context, provider, child) {
              return !provider.isAdding
                  ? RectangleButton(
                      text: 'notes.save'.tr(),
                      handler: () {
                        if (titleController.text == '') {
                          showSimpleNotification(
                            Text(
                              'الرجاء إدخال عنوان الملاحظة',
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
                        } else if (textController.text == '') {
                          showSimpleNotification(
                            Text(
                              'الرجاء إدخال نص الملاحظة',
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
                        } else {
                          FocusScope.of(context).unfocus();
                          provider.addNote(
                              titleController.text, textController.text,
                              onDone: onNoteAdded);
                        }
                      })
                  : RectangleButtonLoading(
                      text: 'notes.save'.tr(),
                    );
            },
          ),
        ],
      ),
    );
  }

  void onNoteAdded() {
    Navigator.pop(context);
  }
  // void addNote(String title, String text) {
  //   String uid = Provider.of<AuthProvider>(context, listen: false).user.uid;

  //   FocusScope.of(context).unfocus();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   FirebaseFirestore.instance.collection('notes').doc().set(
  //     {
  //       'date': DateTime.now().millisecondsSinceEpoch,
  //       'title': title,
  //       'text': text,
  //       'user_id': Provider.of<AuthProvider>(context, listen: false).user.uid,
  //     },
  //   ).then((value) {
  //     Provider.of<NoteProvider>(context, listen: false).getUserNotes(uid);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     Navigator.pop(context);
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    textController.dispose();
  }
}
