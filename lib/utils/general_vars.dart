import 'package:firebase_storage/firebase_storage.dart';

class Assets {
  static const String fontName = 'Tajwal';
  static const String englishFontName = 'Poppins';
  static const String imagePlaceholder = 'assets/images/hutaf.png';
  static const String bookImagePlaceholder = 'assets/images/book_loading.png';
  static const String courseImagePlaceholder =
      'assets/images/course_loading.png';
  static const String adsImagePlaceholder = 'assets/images/ads_loading.png';
  static String getPublicMedia(String path) {
    return 'https://firebasestorage.googleapis.com/v0/b/${FirebaseStorage.instance.bucket}/o/${Uri.encodeComponent(path)}?alt=media';
  }
}
