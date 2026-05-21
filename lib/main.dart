import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import '/src/ui/app/app.dart';
import '/src/ui/app/theme_provider.dart';
import '/src/ui/dashboard/dashboard_provider.dart';
import '/src/data/db/app_database.dart';
import '/src/data/db/dao/attempt_dao.dart';
import '/src/data/db/dao/fact_card_dao.dart';
import '/src/data/db/dao/fact_dao.dart';
import '/src/data/db/dao/lesson_progress_dao.dart';
import '/src/data/repository/fact_repository.dart';
import '/src/data/repository/lesson_repository.dart';
import '/src/data/srs/sm2_lite_scheduler.dart';
import '/src/data/srs/srs_scheduler.dart';
import '/src/data/timing/timing_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Uncomment the following lines when enabling Firebase Crashlytics
// import 'package:firebase_core/firebase_core.dart';
// import '/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Animate.restartOnHotReload = true;
  }

  FirebaseAnalytics? firebaseAnalytics;
  FirebaseCrashlytics? crashlytics;

  // To enable Firebase Crashlytics and Analytics, uncomment the following lines and
  // the import statements at the top of this file.
  // See the 'Crashlytics and Analytics' section of the main README.md file for details.

  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   firebaseAnalytics = FirebaseAnalytics.instance;
  //   crashlytics = FirebaseCrashlytics.instance;
  // } catch (e) {
  //   debugPrint("Firebase couldn't be initialized: $e");
  // }

  if (kDebugMode) {
    // ignore: dead_code
    await crashlytics?.setCrashlyticsCollectionEnabled(false);
    // ignore: dead_code
    await firebaseAnalytics?.setAnalyticsCollectionEnabled(false);
  }

  // ignore: unnecessary_null_comparison
  if (crashlytics != null) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  await setupServiceLocator(sharedPreferences);
  runApp(
    MultiProvider(
      providers: [
        // Provider<SharedPreferences>(create: (context) => sharedPreferences),
        ChangeNotifierProvider(
          create: (context) =>
              ThemeProvider(sharedPreferences: sharedPreferences),
        ),
        ChangeNotifierProvider<DashboardProvider>(
          create: (context) => GetIt.I.get<DashboardProvider>(),
        ),
      ],
      child: MyApp(firebaseAnalytics: firebaseAnalytics),
    ),
  );
}

Future<void> setupServiceLocator(SharedPreferences sharedPreferences) async {
  final getIt = GetIt.I;

  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  }

  final appDatabase = await AppDatabase.open();
  if (!getIt.isRegistered<AppDatabase>()) {
    getIt.registerSingleton<AppDatabase>(appDatabase);
  }

  if (!getIt.isRegistered<FactDao>()) {
    getIt.registerSingleton<FactDao>(FactDao(getIt<AppDatabase>()));
  }

  if (!getIt.isRegistered<FactCardDao>()) {
    getIt.registerSingleton<FactCardDao>(FactCardDao(getIt<AppDatabase>()));
  }

  if (!getIt.isRegistered<AttemptDao>()) {
    getIt.registerSingleton<AttemptDao>(AttemptDao(getIt<AppDatabase>()));
  }

  if (!getIt.isRegistered<LessonProgressDao>()) {
    getIt.registerSingleton<LessonProgressDao>(
      LessonProgressDao(getIt<AppDatabase>()),
    );
  }

  if (!getIt.isRegistered<FactRepository>()) {
    getIt.registerSingleton<FactRepository>(FactRepository(getIt<FactDao>()));
  }

  if (!getIt.isRegistered<LessonRepository>()) {
    getIt.registerSingleton<LessonRepository>(LessonRepository());
  }

  if (!getIt.isRegistered<SrsScheduler>()) {
    getIt.registerSingleton<SrsScheduler>(Sm2LiteScheduler());
  }

  if (!getIt.isRegistered<TimingService>()) {
    getIt.registerSingleton<TimingService>(TimingService());
  }

  await getIt<FactRepository>().seedIfEmpty();
}
