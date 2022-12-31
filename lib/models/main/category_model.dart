class CategoryModel {
  String docId;
  String categoryId;
  String categoryName;
  String categoryIcon;
  String categoryType;
  Map<String, dynamic> tr;

  CategoryModel(
    this.docId,
    this.categoryId,
    this.categoryName,
    this.categoryIcon,
    this.categoryType,
    this.tr,
  );

  CategoryModel.fromSnapshot(String id, Map<String, dynamic> snapshot) {
    this.docId = id;
    categoryId = snapshot['category_id'];
    categoryName = snapshot['category_name'];
    categoryIcon = snapshot['image'];
    categoryType = snapshot['type'];
    tr = snapshot['tr'];
  }
}
