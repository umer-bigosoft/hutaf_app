class HomeAdvertisementModel {
  String id;
  int date;
  String title;
  String image;
  String url;
  String bookOrCourseId;
  String type;
  bool isTitle;

  HomeAdvertisementModel({
    this.id,
    this.date,
    this.title,
    this.url,
    this.image,
    this.bookOrCourseId,
    this.type,
    this.isTitle,
  });

  HomeAdvertisementModel.fromSpanshot(
      String id, Map<String, dynamic> snapshot) {
    this.id = id;
    title = snapshot['title'];
    date = snapshot['date'];
    image = snapshot['image'];
    url = snapshot['url'];
    bookOrCourseId = snapshot['book_or_course_id'];
    type = snapshot['type'];
    isTitle = snapshot['isTitle'] != null ? snapshot['isTitle'] : null;
  }
}
