import 'package:Hutaf/ui/views/main/home/books_home_tab.dart';
import 'package:Hutaf/ui/views/main/home/course_home_tab.dart';
import 'package:Hutaf/ui/widgets/app_bar/main_screens_app_bar.dart';
import 'package:Hutaf/ui/widgets/categories/categories_corousel.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  int selectedIndex = 0;

  bool showTab = true;

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: layoutSize.height * 0.03),
            MainScreensAppBar(),
            SizedBox(height: layoutSize.height * 0.005),
            showTab
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6)),
                    margin: EdgeInsets.symmetric(
                        horizontal: layoutSize.width * 0.045),
                    padding: EdgeInsets.symmetric(vertical: 4.5, horizontal: 8),
                    child: DefaultTabController(
                      length: 2,
                      initialIndex: selectedIndex,
                      child: TabBar(
                        labelPadding: EdgeInsets.only(top: 7.5),
                        indicator: BoxDecoration(
                            color: AppColors.darkPink,
                            borderRadius: BorderRadius.circular(8)),
                        indicatorColor: Colors.white,
                        isScrollable: false,
                        labelColor: AppColors.white,
                        unselectedLabelColor: AppColors.darkPink,
                        tabs: <Widget>[
                          Text('main.audio_books'.tr()),
                          Text('main.courses'.tr())
                        ],
                        onTap: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ),
                    ),
                  )
                : CategoriesCorousel(
                    title: 'library.categories'.tr(),
                    isBookTab: selectedIndex == 0,
                  ),

            SizedBox(height: 20),
            Expanded(
              child: [
                BooksHomeTab(
                    onScrollPast: (past) => {
                          setState(() {
                            showTab = !past;
                          })
                        }),
                CourseHomeTab(
                    onScrollPast: (past) => {
                          setState(() {
                            showTab = !past;
                          })
                        }),
              ][selectedIndex],
            )
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Column(
            //       children: [
            //         HomeCarouselSlider(),
            //         SizedBox(height: layoutSize.height * 0.045),
            //         HomeBooksList(title: 'main.new_book'.tr()),
            //         // if (Provider.of<HomeProvider>(context, listen: false)
            //         //         .homeBooksByInterests
            //         //         .length >
            //         //     0)
            //         //   SizedBox(height: layoutSize.height * 0.045),
            //         HomeBooksByInterests(),
            //         SizedBox(height: layoutSize.height * 0.045),
            //         HomeCoursesList(),
            //         // if (Provider.of<HomeProvider>(context, listen: false)
            //         //         .homeCoursesByInterests
            //         //         .length >
            //         //     0)
            //         //   SizedBox(height: layoutSize.height * 0.045),
            //         HomeCoursesByInterests(),
            //         SizedBox(height: layoutSize.height * 0.05),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
