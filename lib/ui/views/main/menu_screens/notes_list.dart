import 'package:Hutaf/models/main/note_model.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/menu/note_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/loading/note_list_item_loading.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:Hutaf/ui/widgets/others/note_list_item.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class NotesList extends StatefulWidget {
  NotesList({Key key}) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  // bool _isLoading = true;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      String uid = Provider.of<AuthProvider>(context, listen: false).user.uid;
      Provider.of<NoteProvider>(context, listen: false).getUserNotes(uid);
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'notes.notes_list_title'.tr(),
        actions: [
          CupertinoButton(
            child: Icon(
              Icons.add_rounded,
              color: AppColors.black,
              size: layoutSize.width * 0.065,
            ),
            onPressed: () {
              Navigator.pushNamed(context, ScreensName.addNote);
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Container(
          child: Consumer<NoteProvider>(
            builder: (context, note, child) {
              if (note.isLoading) {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: layoutSize.height * 0.015,
                      right: layoutSize.width * 0.045,
                      left: layoutSize.width * 0.045),
                  separatorBuilder: (context, index) {
                    return CustomDivider(
                      lineWidth: layoutSize.width * 0.8,
                      lineColor: AppColors.lightGrey3,
                      // marginTop: layoutSize.height * 0.04,
                      // marginBottom: layoutSize.height * 0.04,
                    );
                  },
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return NoteListItemLoading();
                  },
                );
              } else if (note.notes.length == 0 && !note.isError) {
                return EmptyResult(text: 'لا توجد ملاحظات مضافة :)');
              } else if (note.isError) {
                return ErrorResult(
                  text: 'حدث خطأ ما ، الرجاء إعادة المحاولة !',
                );
              } else {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: layoutSize.height * 0.015,
                      right: layoutSize.width * 0.045,
                      left: layoutSize.width * 0.045),
                  separatorBuilder: (context, index) {
                    return CustomDivider(
                      lineWidth: layoutSize.width * 0.8,
                      lineColor: AppColors.lightGrey3,
                      // marginTop: layoutSize.height * 0.04,
                      // marginBottom: layoutSize.height * 0.04,
                    );
                  },
                  itemCount: note.notes.length,
                  itemBuilder: (context, index) {
                    return NoteListItem(
                      NoteModel(
                        note.notes[index].docId,
                        note.notes[index].title,
                        note.notes[index].text,
                        note.notes[index].date,
                      ),
                      // onDelete: onDelete,
                      // onShare: onShare,
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
