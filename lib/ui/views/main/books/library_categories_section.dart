import 'package:Hutaf/providers/main/library_provider.dart';
import 'package:Hutaf/ui/widgets/buttons/category_button.dart';
import 'package:Hutaf/ui/widgets/loading/category_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryCategoriesSection extends StatefulWidget {
  const LibraryCategoriesSection({
    Key key,
  }) : super(key: key);

  @override
  _LibraryCategoriesSectionState createState() =>
      _LibraryCategoriesSectionState();
}

class _LibraryCategoriesSectionState extends State<LibraryCategoriesSection> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<LibraryProvider>(context, listen: false)
          .getBooksCategories()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    if (_isLoading) {
      return GridView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(
          right: 13,
          bottom: layoutSize.height * 0.03,
          left: 13,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: (layoutSize.width / layoutSize.height) * 2,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return CategoryLoading();
        },
      );
    } else {
      return Expanded(
        child: Consumer<LibraryProvider>(builder: (context, library, child) {
          if (library.isCategotyBooksError) {
            return Column(
              children: [
                SizedBox(height: layoutSize.height * 0.06),
                ErrorResult(
                  isSizedBox: false,
                  text: 'هممم، يبدو أنه قد حدث خطأ ما أثناء جلب التصنيفات !',
                ),
              ],
            );
          } else if (library.categoriesList.length == 0) {
            return Column(
              children: [
                SizedBox(height: layoutSize.height * 0.06),
                EmptyResult(
                  isSizedBox: false,
                  text: 'هممم، يبدو أنه لا توجد تصنيفات !',
                ),
              ],
            );
          } else {
            return GridView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  right: 13, bottom: layoutSize.height * 0.03, left: 13),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: (layoutSize.width / layoutSize.height) * 2,
              ),
              itemCount: library.categoriesList.length,
              itemBuilder: (context, index) {
                return CategoryButton(
                  categoryIcon: library.categoriesList[index].categoryIcon,
                  categoryId: library.categoriesList[index].categoryId,
                  categoryName: library.categoriesList[index].tr['ar'],
                  type: 'book',
                );
              },
            );
          }
        }),
      );
    }
  }
}
