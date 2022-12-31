class NoteModel {
  String docId;
  String title;
  String text;
  int date;

  NoteModel(this.docId, this.title, this.text, this.date);

  NoteModel.fromSpanshot(String id, Map<String, dynamic> snapshot) {
    this.docId = id;
    text = snapshot['text'];
    title = snapshot['title'];
    date = snapshot['date'];
  }
}
