class BookModel {
  String id;
  String name;
  String description;
  Map<String, dynamic> category;
  String categoryId;
  List downloadedBy;
  List purchasedBy;
  int duration;
  double evaluation;
  List evaluatedBy;
  String help;
  String image;
  String narrator;
  String otherDetails;
  double price;
  String publisher;
  String recordedBy;
  int usersInvolved;
  String writerName;
  String sampleUrl;
  String productId;
  bool isFree;

  BookModel(
      {this.id,
      this.name,
      this.description,
      this.category,
      this.categoryId,
      this.downloadedBy,
      this.purchasedBy,
      this.duration,
      this.evaluation,
      this.evaluatedBy,
      this.help,
      this.image,
      this.narrator,
      this.otherDetails,
      this.price,
      this.publisher,
      this.recordedBy,
      this.usersInvolved,
      this.writerName,
      this.sampleUrl,
      this.productId,
      this.isFree});

  BookModel.fromSnapshot(String id, Map<String, dynamic> snapshot) {
    this.id = id;
    name = snapshot['book_name'];
    description = snapshot['description'];
    category = snapshot['category'];
    categoryId = snapshot['category_id'];
    downloadedBy = snapshot['downloaded_by'];
    purchasedBy =
        snapshot['purchased_by'] != null ? snapshot['purchased_by'] : [];
    duration = snapshot['duration'];
    evaluation = snapshot['evaluation'] == null
        ? null
        : snapshot['evaluation'].toDouble();
    evaluatedBy = snapshot['evaluated_by'];
    help = snapshot['help'];
    image = snapshot['image'];
    narrator = snapshot['narrator'];
    otherDetails = snapshot['other_details'];
    price = snapshot['price'] == null ? null : snapshot['price'].toDouble();
    publisher = snapshot['publisher'];
    recordedBy = snapshot['recorded_by'];
    usersInvolved = snapshot['total_of_users_involved'];
    writerName = snapshot['writer_name'];
    sampleUrl = snapshot['sample_url'];
    productId = snapshot['product_id'];
    isFree = snapshot['isFree'] ?? false;
  }
}
