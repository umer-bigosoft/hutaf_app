class SuccessModal {
  String id;
  String title;
  String url;
  String image;
  String type;

  SuccessModal({
    this.id,
    this.title,
    this.url,
    this.image,
    this.type,
  });

  SuccessModal.fromSnapshot(String id, Map<String, dynamic> snapshot) {
    this.id = id;
    title = snapshot['title'];
    url = snapshot['url'];
    image = snapshot['image'];
    type = snapshot['type'];
  }
}
