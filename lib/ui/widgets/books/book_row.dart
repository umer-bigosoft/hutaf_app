import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookRow extends StatelessWidget {
  final String bookId;
  final String bookName;
  final String bookImage;
  final double bookPrice;
  final String writerName;
  const BookRow({
    Key key,
    this.bookId = '',
    this.bookName = '',
    this.bookImage = '',
    this.bookPrice = 0.0,
    this.writerName = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Column(
      children: [
        CupertinoButton(
          minSize: 1,
          padding: EdgeInsets.zero,
          child: Container(
            margin: EdgeInsets.only(
              right: layoutSize.width * 0.01,
              left: layoutSize.width * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        height: 40,
                        width: 30,
                        imageUrl: bookImage,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.bookImagePlaceholder),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.bookImagePlaceholder),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      // Container(
                      //   height: 40,
                      //   width: 30,
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       image: NetworkImage(bookImage),
                      //       fit: BoxFit.cover,
                      //     ),
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      // ),
                      SizedBox(width: layoutSize.width * 0.03),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: layoutSize.width * 0.04,
                                  ),
                            ),
                            Text(
                              writerName,
                              textScaleFactor: 1,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: layoutSize.width * 0.03,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: layoutSize.width * 0.05),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      bookPrice == 0
                          ? 'مجاني'
                          : bookPrice.toStringAsFixed(3) + ' ريال عُماني',
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.headline3.copyWith(
                            fontSize: layoutSize.width * 0.03,
                          ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       '4.5',
                    //       textScaleFactor: 1,
                    //       style: Theme.of(context).textTheme.headline6.copyWith(
                    //             fontSize: layoutSize.width * 0.032,
                    //             fontFamily: Assets.englishFontName,
                    //           ),
                    //     ),
                    //     Icon(
                    //       Icons.star_rounded,
                    //       size: layoutSize.width * 0.035,
                    //       color: AppColors.orange,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              ScreensName.bookDetails,
              arguments: {
                'bookId': bookId,
              },
            );
          },
        ),
        SizedBox(height: layoutSize.height * 0.03),
      ],
    );
  }
}
