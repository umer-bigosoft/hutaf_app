class TrainerModel {
  String id;
  String name;
  String image;
  String description;
  String job;

  TrainerModel({this.id, this.name, this.image, this.description, this.job});

  TrainerModel.fromSnapshot(String id, Map<String, dynamic> snapshot) {
    this.id = id;
    name = snapshot['name'];
    image = snapshot['image'];
    description = snapshot['descrioption'];
    job = snapshot['job_title'];
  }
}
