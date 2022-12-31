class SessionModel {
  String id;
  int duration;
  String title;
  String url;
  String objectives;
  Map<String, dynamic> listenedBy;

  SessionModel(
      {this.id,
      this.duration,
      this.title,
      this.url,
      this.objectives,
      this.listenedBy});

  SessionModel.fromSpanshot(String id, Map<String, dynamic> snapshot) {
    this.id = id;
    duration = snapshot['duration'];
    title = snapshot['title'];
    url = snapshot['url'];
    objectives = snapshot['objectives'];
    listenedBy = snapshot['listened_by'];
  }
}
