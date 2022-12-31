class ChapterModel {
  String id;
  int duration;
  String title;
  String url;
  Map<String,dynamic> listenedBy;

  ChapterModel({this.id, this.duration, this.title, this.url});

  ChapterModel.fromSpanshot(String id, Map<String, dynamic> snapshot) {
    this.id = id;
    duration = snapshot['duration'];
    title = snapshot['title'];
    url = snapshot['url'];
    listenedBy = snapshot['listened_by'];
  }
}
