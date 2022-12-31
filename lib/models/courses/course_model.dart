class CourseModel {
  String id;
  String name;
  String description;
  List downloadedBy;
  num duration;
  List evaluatedBy;
  num evaluation;
  String image;
  num price;
  num totalOfUsersInvolved;
  String trainerId;
  String trainerName;
  String trainerJob;
  List purchasedBy;
  Map<String, dynamic> category;
  String categoryId;
  String productId;

  CourseModel({
    this.id,
    this.name,
    this.description,
    this.downloadedBy,
    this.duration,
    this.evaluation,
    this.evaluatedBy,
    this.image,
    this.price,
    this.totalOfUsersInvolved,
    this.trainerId,
    this.trainerName,
    this.trainerJob,
    this.purchasedBy,
    this.categoryId,
    this.category,
    this.productId,
  });

  CourseModel.fromSnapshot(String id, Map<String, dynamic> snapshot) {
    this.id = id;
    name = snapshot['course_name'];
    description = snapshot['description'];
    downloadedBy = snapshot['downloaded_by'];
    duration = snapshot['duration'];
    evaluation = snapshot['evaluation'] == null
        ? null
        : snapshot['evaluation'];
    evaluatedBy = snapshot['evaluated_by'];
    image = snapshot['image'];
    price = snapshot['price'] == null ? null : snapshot['price'];
    totalOfUsersInvolved = snapshot['total_of_users_involved'];
    trainerId = snapshot['trainer_id'];
    trainerName = snapshot['trainer_name'];
    trainerJob = snapshot['trainer_job'];
    purchasedBy =
        snapshot['purchased_by'] != null ? snapshot['purchased_by'] : [];
    category = snapshot['category'];
    categoryId = snapshot['category_id'];
    productId = snapshot['product_id'];
  }
}
