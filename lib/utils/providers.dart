import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/archive_provider.dart';
import 'package:Hutaf/providers/main/audio_provider.dart';
import 'package:Hutaf/providers/main/books_provider.dart';
import 'package:Hutaf/providers/main/chapters_provider.dart';
import 'package:Hutaf/providers/main/courses_provider.dart';
import 'package:Hutaf/providers/main/home_provider.dart';
import 'package:Hutaf/providers/main/iap_provider.dart';
import 'package:Hutaf/providers/main/library_provider.dart';
import 'package:Hutaf/providers/main/new_audio_provider.dart';
import 'package:Hutaf/providers/main/search_provider.dart';
import 'package:Hutaf/providers/main/sessions_provider.dart';
import 'package:Hutaf/providers/main/trainer_provider.dart';
import 'package:Hutaf/providers/menu/note_provider.dart';
import 'package:Hutaf/providers/menu/success_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(
    create: (_) => AuthProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => NoteProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => HomeProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => BooksProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => AudioProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => ChaptersProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => SuccessProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => CoursesProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => SessionsProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => LibraryProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => TrainerProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => ArchiveProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => IAPProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => SearchProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => NewAudioProvider(),
  ),
];
