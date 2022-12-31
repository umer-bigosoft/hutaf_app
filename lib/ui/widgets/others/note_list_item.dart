import 'package:Hutaf/models/main/note_model.dart';
import 'package:Hutaf/providers/menu/note_provider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'custom_dialog.dart';

class NoteListItem extends StatefulWidget {
  final NoteModel note;
  const NoteListItem(this.note, {Key key}) : super(key: key);

  @override
  _NoteListItemState createState() => _NoteListItemState();
}

class _NoteListItemState extends State<NoteListItem> {
  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    final DateFormat dateFormat = DateFormat('yyyy/MM/dd');

    Intl.defaultLocale = "ar_OM";

    DateTime formatedDate =
        DateTime.fromMillisecondsSinceEpoch(widget.note.date);
    var dayOfTheWeek = DateFormat('EEEE').format(formatedDate);

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.24,
      child: CupertinoButton(
        minSize: 1,
        padding: EdgeInsets.zero,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
              top: layoutSize.height * 0.03, bottom: layoutSize.height * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book_rounded,
                      color: AppColors.lightGrey2,
                      size: layoutSize.width * 0.055,
                    ),
                    SizedBox(width: layoutSize.width * 0.02),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.note.title,
                            textScaleFactor: 1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline2
                                .copyWith(
                                  fontSize: layoutSize.width * 0.04,
                                ),
                          ),
                          Text(
                            widget.note.text,
                            textScaleFactor: 1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .copyWith(
                                  fontSize: layoutSize.width * 0.035,
                                ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: layoutSize.width * 0.02),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'يوم ' + dayOfTheWeek,
                    textScaleFactor: 1,
                    style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                          fontSize: layoutSize.width * 0.03,
                        ),
                  ),
                  Text(
                    dateFormat.format(formatedDate),
                    textScaleFactor: 1,
                    style:
                        Theme.of(context).primaryTextTheme.headline2.copyWith(
                              fontSize: layoutSize.width * 0.03,
                            ),
                  )
                ],
              )
            ],
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, ScreensName.viewNote,
              arguments: widget.note);
        },
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'notes.share'.tr(),
          color: AppColors.darkGrey2,
          icon: Icons.share_rounded,
          onTap: () {
            Provider.of<NoteProvider>(context, listen: false)
                .shareNote(widget.note.title, widget.note.text);
          },
        ),
        IconSlideAction(
          caption: 'notes.delete'.tr(),
          color: AppColors.darkPink,
          icon: Icons.delete_rounded,
          onTap: () {
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
                  },
                  textButtonText: 'menu.no'.tr(),
                  textHandler: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
