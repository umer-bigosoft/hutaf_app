import 'package:Hutaf/providers/menu/success_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/loading/home_carousel_slider_loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Success extends StatefulWidget {
  Success({Key key}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<SuccessProvider>(context, listen: false)
          .getSuccessDetails()
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
    List<Widget> strategicsSliders = [];
    List<Widget> supportingsSliders = [];
    List<Widget> associatesSliders = [];

    if (!_isLoading) {
      strategicsSliders = Provider.of<SuccessProvider>(context, listen: false)
          .strategics
          .map(
            (item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse(item.url));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item.image,
                            fit: BoxFit.cover, width: 1000.0),
                        Container(
                          color: Color.fromARGB(55, 0, 0, 0),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                    fontSize: layoutSize.width * 0.04,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList();
      supportingsSliders = Provider.of<SuccessProvider>(context, listen: false)
          .supportings
          .map(
            (item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse(item.url));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item.image,
                            fit: BoxFit.cover, width: 1000.0),
                        Container(
                          color: Color.fromARGB(55, 0, 0, 0),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                    fontSize: layoutSize.width * 0.04,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList();
      associatesSliders = Provider.of<SuccessProvider>(context, listen: false)
          .associates
          .map(
            (item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse(item.url));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item.image,
                            fit: BoxFit.cover, width: 1000.0),
                        Container(
                          color: Color.fromARGB(55, 0, 0, 0),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                    fontSize: layoutSize.width * 0.04,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList();
    }

    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'success.success_title'.tr(),
        handler: () {
          Navigator.pop(context);
        },
      ),
      body: _isLoading
          ? ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: layoutSize.height * 0.04,
                bottom: layoutSize.height * 0.04,
              ),
              children: [
                HomeCarouselSliderLoading(),
                SizedBox(height: layoutSize.height * 0.05),
                HomeCarouselSliderLoading(),
                SizedBox(height: layoutSize.height * 0.05),
                HomeCarouselSliderLoading(),
              ],
            )
          : Consumer<SuccessProvider>(
              builder: (context, success, child) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: layoutSize.height * 0.027),
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          right: layoutSize.width * 0.05,
                          left: layoutSize.width * 0.05),
                      child: Text(
                        'success.success_text'.tr(),
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: layoutSize.width * 0.045,
                            ),
                      ),
                    ),
                    SizedBox(height: layoutSize.height * 0.04),
                    success.strategics.length == 0
                        ? Container()
                        : sponsorSectionTitle(
                            layoutSize, 'success.strategic_sponsor'.tr()),
                    success.strategics.length == 0
                        ? Container()
                        : CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 2.0,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              initialPage: 0,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 4),
                            ),
                            items: strategicsSliders,
                          ),
                    success.strategics.length == 0
                        ? Container()
                        : SizedBox(height: layoutSize.height * 0.04),
                    success.supportings.length == 0
                        ? Container()
                        : sponsorSectionTitle(
                            layoutSize, 'success.supporting_sponsor'.tr()),
                    success.supportings.length == 0
                        ? Container()
                        : CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 2.0,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              initialPage: 0,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 4),
                            ),
                            items: supportingsSliders,
                          ),
                    success.supportings.length == 0
                        ? Container()
                        : SizedBox(height: layoutSize.height * 0.04),
                    success.associates.length == 0
                        ? Container()
                        : sponsorSectionTitle(
                            layoutSize, 'success.associate_sponsor'.tr()),
                    success.associates.length == 0
                        ? Container()
                        : CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 2.0,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              initialPage: 0,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 4),
                            ),
                            items: associatesSliders,
                          ),
                    success.associates.length == 0
                        ? Container()
                        : SizedBox(height: layoutSize.height * 0.04),
                  ],
                );
              },
            ),
    );
  }

  Widget sponsorSectionTitle(Size layoutSize, String title) {
    return Container(
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.05,
        left: layoutSize.width * 0.05,
        bottom: layoutSize.height * 0.015,
      ),
      child: Text(
        title,
        textScaleFactor: 1,
        style: Theme.of(context).primaryTextTheme.headline1.copyWith(
              fontSize: layoutSize.width * 0.055,
            ),
      ),
    );
  }

  void launch(Uri url) async {
    try {
      await launchUrl(url);
    } catch (e) {}
  }
}
