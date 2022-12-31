import 'package:Hutaf/models/main/note_model.dart';
import 'package:Hutaf/providers/menu/note_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/others/custom_dialog.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class ViewNote extends StatefulWidget {
  ViewNote(this.note, {Key key}) : super(key: key);
  final NoteModel note;
  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    final DateFormat dateFormat = DateFormat('dd MMMM yyyy');

    Intl.defaultLocale = "ar_OM";

    DateTime formatedDate =
        DateTime.fromMillisecondsSinceEpoch(widget.note.date);
    var dayOfTheWeek = DateFormat('EEEE').format(formatedDate);

    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'notes.notes_list_title'.tr(),
        actions: [
          CupertinoButton(
            child: Icon(
              Icons.edit,
              color: AppColors.black,
              size: layoutSize.width * 0.065,
            ),
            onPressed: () async {
              dynamic note = await Navigator.pushNamed(
                  context, ScreensName.editNote,
                  arguments: widget.note);
              setState(() {
                widget.note.text = note.text;
                widget.note.title = note.title;
              });
            },
          ),
        ],
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
                Text(
                  widget.note.title,
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: layoutSize.width * 0.05,
                      ),
                ),
                Text(
                  'يوم ' +
                      dayOfTheWeek +
                      ' ، ' +
                      dateFormat.format(formatedDate),
                  textScaleFactor: 1,
                  style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                        fontSize: layoutSize.width * 0.03,
                      ),
                ),
                CustomDivider(
                  lineWidth: layoutSize.width,
                  lineColor: AppColors.lightGrey3,
                  marginTop: layoutSize.height * 0.02,
                  marginBottom: layoutSize.height * 0.04,
                ),
                Text(
                  widget.note.text,
                  textScaleFactor: 1,
                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                        fontSize: layoutSize.width * 0.04,
                      ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(
                right: layoutSize.width * 0.055,
                left: layoutSize.width * 0.055,
                top: layoutSize.height * 0.035,
                bottom: layoutSize.height * 0.035,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightGrey3,
                    blurRadius: 6,
                    offset: Offset(0, -3.5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  actionButton(
                      layoutSize, 'notes.delete'.tr(), Icons.delete_rounded,
                      () {
                    return showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return CustomDialog(
                          title: 'notes.are_you_sure_you_will_delete'.tr(),
                          buttonText: 'menu.yes'.tr(),
                          buttonHandler: () {
                            Navigator.pop(context);
                            Provider.of<NoteProvider>(context, listen: false)
                                .deleteNote(widget.note.docId);
                            Navigator.pop(context);
                          },
                          textButtonText: 'menu.no'.tr(),
                          textHandler: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }, 'pink'),
                  actionButton(
                      layoutSize, 'notes.share'.tr(), Icons.share_rounded, () {
                    Provider.of<NoteProvider>(context, listen: false)
                        .shareNote(widget.note.title, widget.note.text);
                  }, 'grey'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButton(
    Size layoutSize,
    String text,
    IconData icon,
    Function handler,
    String color,
  ) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: layoutSize.width * 0.047,
            color: color == 'pink' ? AppColors.darkPink : AppColors.darkGrey,
          ),
          SizedBox(width: layoutSize.width * 0.025),
          Text(
            text,
            textScaleFactor: 1,
            style: color == 'pink'
                ? Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: layoutSize.width * 0.045,
                    )
                : Theme.of(context).primaryTextTheme.headline6.copyWith(
                      fontSize: layoutSize.width * 0.045,
                    ),
          ),
        ],
      ),
      onPressed: handler,
    );
  }
}
