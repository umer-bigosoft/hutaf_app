import 'package:Hutaf/models/main/note_model.dart';
import 'package:Hutaf/providers/menu/note_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/buttons/rectangle_button.dart';
import 'package:Hutaf/ui/widgets/loading/rectangle_button_loading.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class EditNote extends StatefulWidget {
  EditNote(this.note, {Key key}) : super(key: key);
  final NoteModel note;
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final titleController = TextEditingController();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.note.title;
    textController.text = widget.note.text;
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
                          provider.editNote(titleController.text,
                              textController.text, widget.note,
                              onDone: noteEdited);
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

  void noteEdited() {
    Navigator.pop(context, widget.note);
  }

  // void editNote(String title, String text) {
  //   String uid = Provider.of<AuthProvider>(context, listen: false).user.uid;

  //   FocusScope.of(context).unfocus();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Provider.of<NoteProvider>(context, listen: false)
  //       .editNote(title, text, widget.note.docId)
  //       .then((value) {
  //     Provider.of<NoteProvider>(context, listen: false).getUserNotes(uid);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     widget.note.text = text;
  //     widget.note.title = title;
  //     Navigator.pop(context, widget.note);
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    textController.dispose();
  }
}
