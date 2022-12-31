import 'package:Hutaf/ui/views/auth/forget_password.dart';
import 'package:Hutaf/ui/views/auth/login.dart';
import 'package:Hutaf/ui/views/auth/otp.dart';
import 'package:Hutaf/ui/views/main/books/book_chapter.dart';
import 'package:Hutaf/ui/views/main/books/book_details.dart';
import 'package:Hutaf/ui/views/main/books/books_category.dart';
import 'package:Hutaf/ui/views/main/books/chapters.dart';
import 'package:Hutaf/ui/views/main/books/sample_book_chapter.dart';
import 'package:Hutaf/ui/views/main/courses/about_lecturer.dart';
import 'package:Hutaf/ui/views/main/courses/course_category.dart';
import 'package:Hutaf/ui/views/main/courses/course_details.dart';
import 'package:Hutaf/ui/views/main/courses/courses.dart';
import 'package:Hutaf/ui/views/main/books/library.dart';
import 'package:Hutaf/ui/views/main/courses/session_details.dart';
import 'package:Hutaf/ui/views/main/courses/sessions.dart';
import 'package:Hutaf/ui/views/main/menu_screens/add_note.dart';
import 'package:Hutaf/ui/views/main/menu_screens/edit_note.dart';
import 'package:Hutaf/ui/views/main/menu_screens/notes_list.dart';
import 'package:Hutaf/ui/views/main/menu_screens/privacy_policy.dart';
import 'package:Hutaf/ui/views/auth/registration.dart';
import 'package:Hutaf/ui/views/auth/user_interests.dart';
import 'package:Hutaf/ui/views/main/menu_screens/about_hutaf.dart';
import 'package:Hutaf/ui/views/main/home/home_screen.dart';
import 'package:Hutaf/ui/views/main/main_navigation_screen.dart';
import 'package:Hutaf/ui/views/main/menu_screens/rules.dart';
import 'package:Hutaf/ui/views/main/menu_screens/success.dart';
import 'package:Hutaf/ui/views/main/menu_screens/view_note.dart';
import 'package:Hutaf/ui/views/main/search.dart';
import 'package:Hutaf/ui/views/main/books/view_more_books.dart';
import 'package:Hutaf/ui/views/main/courses/view_more_courses.dart';
import 'package:Hutaf/ui/views/main/settings/change_email.dart';
import 'package:Hutaf/ui/views/main/settings/change_password.dart';
import 'package:Hutaf/ui/views/main/settings/edit_profile.dart';
import 'package:Hutaf/ui/views/main/settings/notifications.dart';
import 'package:Hutaf/ui/views/start/onboarding.dart';
import 'package:Hutaf/ui/views/start/splash.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'screens_name.dart';

class AppRouter {
  static FluroRouter router = FluroRouter();

  /// Start screens
  static Handler _splashHandler = Handler(
    handlerFunc: (context, parameters) => Splash(),
  );
  static Handler _onBoardingHandler = Handler(
    handlerFunc: (context, parameters) => OnBoarding(),
  );

  /// Main screens
  /// Navigation bar
  static Handler _homeHandler = Handler(
    handlerFunc: (context, parameters) => HomeScreen(),
  );
  static Handler _mainNavigationHandler = Handler(
    handlerFunc: (context, parameters) => MainNavigationScreen(),
  );
  static Handler _searchHandler = Handler(
    handlerFunc: (context, parameters) => Search(),
  );
  static Handler _coursesHandler = Handler(
    handlerFunc: (context, parameters) => Courses(),
  );
  static Handler _libraryHandler = Handler(
    handlerFunc: (context, parameters) => Library(),
  );
  static Handler _viewMoreBooksHandler = Handler(
    handlerFunc: (context, parameters) => ViewMoreBooks(),
  );
  static Handler _viewMoreCoursesHandler = Handler(
    handlerFunc: (context, parameters) => ViewMoreCourses(),
  );
  static Handler _booksCategoryHandler = Handler(
    handlerFunc: (context, parameters) =>
        BooksCategory(ModalRoute.of(context).settings.arguments),
  );
  static Handler _courseDetailsHandler = Handler(
    handlerFunc: (context, parameters) =>
        CourseDetails(ModalRoute.of(context).settings.arguments),
  );
  static Handler _bookDetailsHandler = Handler(
    handlerFunc: (context, parameters) =>
        BookDetails(ModalRoute.of(context).settings.arguments),
  );
  static Handler _courseCategoryHandler = Handler(
    handlerFunc: (context, parameters) =>
        CourseCategory(ModalRoute.of(context).settings.arguments),
  );
  static Handler _aboutLecturerHandler = Handler(
    handlerFunc: (context, parameters) =>
        AboutLecturer(ModalRoute.of(context).settings.arguments),
  );
  static Handler _sessionsHandler = Handler(
    handlerFunc: (context, parameters) => Sessions(
        (ModalRoute.of(context).settings.arguments as Map)['course'],
        (ModalRoute.of(context).settings.arguments as Map)['notifyRating']),
  );
  static Handler _sessionDetailsHandler = Handler(
    handlerFunc: (context, parameters) =>
        SessionDetails(ModalRoute.of(context).settings.arguments),
  );
  static Handler _editProfileHandler = Handler(
    handlerFunc: (context, parameters) => EditProfile(),
  );
  static Handler _changePasswordHandler = Handler(
    handlerFunc: (context, parameters) => ChangePassword(),
  );
  static Handler _changeEmailHandler = Handler(
    handlerFunc: (context, parameters) => ChangeEmail(),
  );
  static Handler _notificationsHandler = Handler(
    handlerFunc: (context, parameters) => Notifications(),
  );
  static Handler _bookChapterHandler = Handler(
    handlerFunc: (context, parameters) =>
        BookChapter(ModalRoute.of(context).settings.arguments),
  );
  static Handler _sampleBookChapterHandler = Handler(
    handlerFunc: (context, parameters) =>
        SampleBookChapter(ModalRoute.of(context).settings.arguments),
  );
  static Handler _chaptersHandler = Handler(
    handlerFunc: (context, parameters) => Chapters(
        (ModalRoute.of(context).settings.arguments as Map)['book'],
        (ModalRoute.of(context).settings.arguments as Map)['notifyRating']),
  );

  /// Auth screens
  static Handler _loginHandler = Handler(
    handlerFunc: (context, parameters) => Login(),
  );
  static Handler _forgetPasswordHandler = Handler(
    handlerFunc: (context, parameters) => ForgetPassword(),
  );
  static Handler _registrationHandler = Handler(
    handlerFunc: (context, parameters) => Registration(),
  );
  static Handler _otpHandler = Handler(
    handlerFunc: (context, parameters) => Otp(),
  );
  static Handler _userInterestsHandler = Handler(
    handlerFunc: (context, parameters) => UserInterests(),
  );
  static Handler _privacyPolicyHandler = Handler(
    handlerFunc: (context, parameters) => PrivacyPolicy(),
  );

  /// Main screens
  /// Menu
  static Handler _rulesHandler = Handler(
    handlerFunc: (context, parameters) => Rules(),
  );
  static Handler _aboutHutafHandler = Handler(
    handlerFunc: (context, parameters) => AboutHutaf(),
  );
  static Handler _successHandler = Handler(
    handlerFunc: (context, parameters) => Success(),
  );
  static Handler _notesListHandler = Handler(
    handlerFunc: (context, parameters) => NotesList(),
  );
  static Handler _viewNoteHandler = Handler(
    handlerFunc: (context, parameters) =>
        ViewNote(ModalRoute.of(context).settings.arguments),
  );
  static Handler _addNoteHandler = Handler(
    handlerFunc: (context, parameters) => AddNote(),
  );
  static Handler _editNoteHandler = Handler(
    handlerFunc: (context, parameters) =>
        EditNote(ModalRoute.of(context).settings.arguments),
  );

  static void defineRoutes() {
    /// Start screens
    router.define(
      '${ScreensName.splash}',
      handler: _splashHandler,
    );
    router.define(
      '${ScreensName.onBoarding}',
      handler: _onBoardingHandler,
    );

    /// Main screens
    /// Navigation bar
    router.define(
      '${ScreensName.home}',
      handler: _homeHandler,
    );
    router.define(
      '${ScreensName.mainNavigation}',
      handler: _mainNavigationHandler,
    );
    router.define(
      '${ScreensName.search}',
      handler: _searchHandler,
    );
    router.define(
      '${ScreensName.courses}',
      handler: _coursesHandler,
    );
    router.define(
      '${ScreensName.library}',
      handler: _libraryHandler,
    );
    router.define(
      '${ScreensName.viewMoreBooks}',
      handler: _viewMoreBooksHandler,
    );
    router.define(
      '${ScreensName.viewMoreCourses}',
      handler: _viewMoreCoursesHandler,
    );
    router.define(
      '${ScreensName.booksCategory}',
      handler: _booksCategoryHandler,
    );
    router.define(
      '${ScreensName.courseDetails}',
      handler: _courseDetailsHandler,
    );
    router.define(
      '${ScreensName.bookDetails}',
      handler: _bookDetailsHandler,
    );
    router.define(
      '${ScreensName.courseCategory}',
      handler: _courseCategoryHandler,
    );
    router.define(
      '${ScreensName.aboutLecturer}',
      handler: _aboutLecturerHandler,
    );
    router.define(
      '${ScreensName.sessions}',
      handler: _sessionsHandler,
    );
    router.define(
      '${ScreensName.sessionDetails}',
      handler: _sessionDetailsHandler,
    );
    router.define(
      '${ScreensName.editProfile}',
      handler: _editProfileHandler,
    );
    router.define(
      '${ScreensName.changeEmail}',
      handler: _changeEmailHandler,
    );
    router.define(
      '${ScreensName.changePassword}',
      handler: _changePasswordHandler,
    );
    router.define(
      '${ScreensName.notifications}',
      handler: _notificationsHandler,
    );
    router.define(
      '${ScreensName.bookChapter}',
      handler: _bookChapterHandler,
    );
    router.define(
      '${ScreensName.sampleBookChapter}',
      handler: _sampleBookChapterHandler,
    );
    router.define(
      '${ScreensName.chapters}',
      handler: _chaptersHandler,
    );

    /// Auth screens
    router.define(
      '${ScreensName.login}',
      handler: _loginHandler,
    );
    router.define(
      '${ScreensName.forgetPassword}',
      handler: _forgetPasswordHandler,
    );
    router.define(
      '${ScreensName.registration}',
      handler: _registrationHandler,
    );
    router.define(
      '${ScreensName.otp}',
      handler: _otpHandler,
    );
    router.define(
      '${ScreensName.userInterests}',
      handler: _userInterestsHandler,
    );
    router.define(
      '${ScreensName.privacyPolicy}',
      handler: _privacyPolicyHandler,
    );

    /// Main screens
    /// Menu
    router.define(
      '${ScreensName.rules}',
      handler: _rulesHandler,
    );
    router.define(
      '${ScreensName.aboutHutaf}',
      handler: _aboutHutafHandler,
    );
    router.define(
      '${ScreensName.success}',
      handler: _successHandler,
    );
    router.define(
      '${ScreensName.notesList}',
      handler: _notesListHandler,
    );
    router.define(
      '${ScreensName.viewNote}',
      handler: _viewNoteHandler,
    );
    router.define(
      '${ScreensName.addNote}',
      handler: _addNoteHandler,
    );
    router.define(
      '${ScreensName.editNote}',
      handler: _editNoteHandler,
    );
  }
}
