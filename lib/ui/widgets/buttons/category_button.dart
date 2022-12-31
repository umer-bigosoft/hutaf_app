import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String categoryIcon;
  final String categoryName;
  final String categoryId;
  final String type;
  final Color color;
  final Function onPressed;
  const CategoryButton({
    Key key,
    this.categoryIcon,
    this.categoryName,
    this.categoryId,
    this.type,
    this.color = Colors.white,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Container(
        width: layoutSize.width * 0.6,
        padding: EdgeInsets.only(right: 5, left: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.lightPurple,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              IconData(
                int.parse(categoryIcon),
                fontFamily: 'MaterialIcons',
                matchTextDirection: true,
              ),
              size: layoutSize.width * 0.077,
              color: AppColors.purple,
            ),
            // SizedBox(height: layoutSize.height * 0.02),
            Text(
              categoryName,
              textScaleFactor: 1,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                    fontSize: layoutSize.width * 0.035,
                  ),
            )
          ],
        ),
      ),
      onPressed: onPressed ??
          () {
            Navigator.pushNamed(
              context,
              type == 'book'
                  ? ScreensName.booksCategory
                  : ScreensName.courseCategory,
              arguments: {
                'id': categoryId,
                'name': categoryName,
              },
            );
          },
    );
  }
}
