import 'package:Hutaf/providers/main/home_provider.dart';
import 'package:Hutaf/ui/widgets/books/book_item.dart';
import 'package:Hutaf/ui/widgets/others/row_builder.dart';
import 'package:Hutaf/ui/widgets/headers/main_screen_header_with_show_more.dart';
import 'package:Hutaf/ui/widgets/loading/home_horizantal_list_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeBooksByInterests extends StatefulWidget {
  HomeBooksByInterests({Key key}) : super(key: key);

  @override
  _HomeBooksByInterestsState createState() => _HomeBooksByInterestsState();
}

class _HomeBooksByInterestsState extends State<HomeBooksByInterests> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      String uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        Provider.of<HomeProvider>(context, listen: false)
            .getBooksByInterests(uid)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        }).catchError((onError) {
          if (mounted)
            setState(() {
              _isLoading = false;
            });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    if (_isLoading) {
      return Column(
        children: [
          SizedBox(height: layoutSize.height * 0.03),
          HomeHorizantalListLoading(),
        ],
      );
    } else {
      return Container(
        child: Consumer<HomeProvider>(
          builder: (context, home, child) {
            if (home.isHomeBooksByInterestsError) {
              return Container();
              // return Column(
              //   children: [
              //     Container(
              //       margin: EdgeInsets.only(
              //         right: layoutSize.width * 0.035,
              //         left: layoutSize.width * 0.035,
              //       ),
              //       child: MainScreenHeaderWithShowMore(
              //         title: '',
              //         handler: () {},
              //       ),
              //     ),
              //     SizedBox(height: layoutSize.height * 0.01),
              //     EmptyOrErrorSection(
              //       title: 'حدث خطأ !',
              //       subtitle: 'حدث خطأ ما أثناء جلب البيانات !'.tr(),
              //       imageUrl: 'assets/images/empty_books.svg',
              //     ),
              //   ],
              // );
            } else if (home.homeBooksByInterests.length == 0) {
              return Container();
              // return Column(
              //   children: [
              //     Container(
              //       margin: EdgeInsets.only(
              //         right: layoutSize.width * 0.035,
              //         left: layoutSize.width * 0.035,
              //       ),
              //       child: MainScreenHeaderWithShowMore(
              //         title: 'كتب مُختارة لك',
              //         handler: () {},
              //       ),
              //     ),
              //     SizedBox(height: layoutSize.height * 0.01),
              //     EmptyOrErrorSection(
              //       title: 'main.empty_books'.tr(),
              //       subtitle: 'main.stay_tuned'.tr(),
              //       imageUrl: 'assets/images/empty_books.svg',
              //     ),
              //   ],
              // );
            } else {
              return Column(
                children: [
                  SizedBox(height: layoutSize.height * 0.045),
                  Container(
                    margin: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: MainScreenHeaderWithShowMore(
                      title: 'home.your_interests'.tr(),
                      isLoadMore: false,
                      handler: null,
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.01),
                  Container(
                    width: layoutSize.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(
                        right: layoutSize.width * 0.035,
                        top: layoutSize.height * 0.01,
                      ),
                      child: RowBuilder(
                        itemCount: home.homeBooksByInterests.length > 5
                            ? 5
                            : home.homeBooksByInterests.length,
                        itemBuilder: (context, index) {
                          return BookItem(
                              bookId: home.homeBooksByInterests[index].id,
                              bookName: home.homeBooksByInterests[index].name,
                              bookImage: home.homeBooksByInterests[index].image,
                              bookPrice: home.homeBooksByInterests[index].price
                                  .toDouble(),
                              writerName:
                                  home.homeBooksByInterests[index].writerName,
                              isFree: home.homeBooksByInterests[index].isFree);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      );
    }
  }
}
