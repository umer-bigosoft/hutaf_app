import 'package:Hutaf/providers/main/home_provider.dart';
import 'package:Hutaf/ui/widgets/loading/home_carousel_slider_loading.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CorouselType { BOOK, COURSE }

class HomeCarouselSlider extends StatefulWidget {
  final CorouselType type;
  const HomeCarouselSlider({
    Key key,
    this.type,
  }) : super(key: key);

  @override
  _HomeCarouselSliderState createState() => _HomeCarouselSliderState();
}

class _HomeCarouselSliderState extends State<HomeCarouselSlider> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      var temp;
      if (widget.type == CorouselType.BOOK)
        temp = Provider.of<HomeProvider>(context, listen: false)
            .getBookAdvertisements;
      else
        temp = Provider.of<HomeProvider>(context, listen: false)
            .getCourseAdvertisements;

      temp().then((_) {
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
      return HomeCarouselSliderLoading();
    } else {
      return Container(
        child: Consumer<HomeProvider>(
          builder: (context, home, child) {
            final advertisementsImages = widget.type == CorouselType.BOOK
                ? home.bookAdsImages
                : home.courseAdsImages;

            if (home.isAdvertisementsError) {
              return emptyAdvertisements(layoutSize);
            } else if (advertisementsImages.length == 0) {
              return emptyAdvertisements(layoutSize);
            } else {
              return CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2.5,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  initialPage: 1,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 4),
                ),
                items: [
                  for (var i = 0; i < advertisementsImages.length; i++)
                    CupertinoButton(
                      minSize: 1,
                      padding: EdgeInsets.zero,
                      child: Container(
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            child: Stack(
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: advertisementsImages[i].image,
                                  placeholder: (context, url) =>
                                      Image.asset(Assets.adsImagePlaceholder),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(Assets.adsImagePlaceholder),
                                  fit: BoxFit.cover,
                                  width: 1000,
                                ),
                                if (advertisementsImages[i].isTitle != null &&
                                    advertisementsImages[i].isTitle)
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 0, 0, 0),
                                            Color.fromARGB(10, 0, 0, 0)
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      child: Text(
                                        advertisementsImages[i].title,
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
                      onPressed: () {
                        if (advertisementsImages[i].type == 'book') {
                          Navigator.pushNamed(
                            context,
                            ScreensName.bookDetails,
                            arguments: {
                              'bookId': advertisementsImages[i].bookOrCourseId,
                            },
                          );
                        } else if (advertisementsImages[i].type == 'course') {
                          Navigator.pushNamed(
                              context, ScreensName.courseDetails, arguments: {
                            'courseId': advertisementsImages[i].bookOrCourseId
                          });
                        }
                      },
                    ),
                ],
              );
            }
          },
        ),
      );
    }
  }

  Widget emptyAdvertisements(Size layoutSize) {
    return Container(
      margin: EdgeInsets.only(
          right: layoutSize.width * 0.035, left: layoutSize.width * 0.035),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Image.asset('assets/images/hutaf_1.png',
            fit: BoxFit.cover, width: 1000.0),
      ),
    );
  }
}
