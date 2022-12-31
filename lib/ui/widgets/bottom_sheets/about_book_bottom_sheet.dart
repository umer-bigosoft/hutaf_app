import 'package:Hutaf/models/books/book_model.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutBookBottomSheet extends StatefulWidget {
  AboutBookBottomSheet(this.book, {Key key}) : super(key: key);
  final BookModel book;
  @override
  _AboutBookBottomSheetState createState() => _AboutBookBottomSheetState();
}

class _AboutBookBottomSheetState extends State<AboutBookBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    final double bottomNotch = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(40),
          topRight: const Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.bottomSheetShadow,
            offset: Offset(1.0, -5.0),
            blurRadius: 8.0,
          )
        ],
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          top: false,
          bottom: bottomNotch > 0 ? true : false,
          child: Container(
            margin: EdgeInsets.only(
              right: layoutSize.width * 0.035,
              left: layoutSize.width * 0.035,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: layoutSize.height * 0.03),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/bottom_sheet_line.svg',
                    width: layoutSize.width / 4,
                  ),
                ),
                SizedBox(height: layoutSize.height * 0.04),
                // title('book_details.author'.tr(), layoutSize),
                // SizedBox(height: 5),
                // detailsContainer('ردينة صالح', layoutSize, false),
                // SizedBox(height: 10),
                if (widget.book.duration != null)
                  title(
                    'book_details.duration'.tr(),
                    layoutSize,
                  ),
                if (widget.book.duration != null) SizedBox(height: 5),
                if (widget.book.duration != null)
                  detailsContainer(
                    Duration(seconds: widget.book.duration)
                        .toString()
                        .split('.')
                        .first
                        .padLeft(8, "0"),
                    layoutSize,
                    true,
                  ),
                if (widget.book.duration != null) SizedBox(height: 10),
                title(
                  'book_details.publishers'.tr(),
                  layoutSize,
                ),
                SizedBox(height: 5),
                detailsContainer(
                  widget.book.publisher != '' ? widget.book.publisher : '-',
                  layoutSize,
                  false,
                ),
                SizedBox(height: 10),
                title(
                  'book_details.record'.tr(),
                  layoutSize,
                ),
                SizedBox(height: 5),
                detailsContainer(
                  widget.book.recordedBy != '' ? widget.book.recordedBy : '-',
                  layoutSize,
                  false,
                ),

                SizedBox(height: 10),
                title(
                  'book_details.the_narrator'.tr(),
                  layoutSize,
                ),
                SizedBox(height: 5),
                detailsContainer(
                  widget.book.narrator != '' ? widget.book.narrator : '-',
                  layoutSize,
                  false,
                ),
                SizedBox(height: 10),
                title(
                  'book_details.help_in_production'.tr(),
                  layoutSize,
                ),
                SizedBox(height: 5),
                detailsContainer(
                  widget.book.help != '' ? widget.book.help : '-',
                  layoutSize,
                  false,
                ),
                SizedBox(height: 10),
                title(
                  'book_details.other_descriptions'.tr(),
                  layoutSize,
                ),
                SizedBox(height: 5),
                detailsContainer(
                  widget.book.otherDetails != ''
                      ? widget.book.otherDetails
                      : '-',
                  layoutSize,
                  false,
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'حقوق هذا الكتاب محفوظة لدى هتاف الرقمية',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline1
                        .copyWith(
                            fontSize: layoutSize.width * 0.032,
                            color: AppColors.darkPink),
                  ),
                ),
                Center(
                  child: Text(
                    'Hutafapp@',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline1
                        .copyWith(
                            fontSize: layoutSize.width * 0.032,
                            color: AppColors.darkPink),
                  ),
                ),

                // Text('),
                // Text('@Hutafapp'),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget title(String title, Size layoutSize) {
    return Text(
      title,
      textScaleFactor: 1,
      style: Theme.of(context).primaryTextTheme.headline1.copyWith(
            fontSize: layoutSize.width * 0.045,
          ),
    );
  }

  Widget detailsContainer(String text, Size layoutSize, bool isNumber) {
    return Container(
      width: layoutSize.width,
      padding: EdgeInsets.only(
        right: layoutSize.width * 0.02,
        left: layoutSize.width * 0.02,
        top: layoutSize.height * 0.01,
        bottom: layoutSize.height * 0.01,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.lightPink,
        ),
      ),
      child: Text(
        text,
        textScaleFactor: 1,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: layoutSize.width * 0.045,
              fontFamily: isNumber ? Assets.englishFontName : Assets.fontName,
            ),
      ),
    );
  }
}
