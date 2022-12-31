import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/material.dart';

class CategoryCorouselItem extends StatelessWidget {
  final String categoryName;
  final String categoryId;
  final bool isBookCategory;

  const CategoryCorouselItem(
      {Key key, this.categoryName, this.categoryId, this.isBookCategory = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => {
        Navigator.pushNamed(
          context,
          isBookCategory
              ? ScreensName.booksCategory
              : ScreensName.courseCategory,
          arguments: {
            'id': categoryId,
            'name': categoryName,
          },
        )
      },
      child: Card(
        elevation: 3,
        color: AppColors.purple,
        child: Container(
            child: Center(
          child: Text(
            categoryName.trim(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                fontSize: layoutSize.width * 0.032,
                color: AppColors.white,
                fontWeight: FontWeight.w600),
          ),
        )),
      ),
    );
  }
}
