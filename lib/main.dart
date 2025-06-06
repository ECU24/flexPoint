import 'package:finalyearproject_flutter_application_1/authentication/authentication_repository.dart';
import 'package:finalyearproject_flutter_application_1/data/exerciseData.dart';
import 'package:finalyearproject_flutter_application_1/firebase_options.dart';
import 'package:finalyearproject_flutter_application_1/friends/friendsData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:finalyearproject_flutter_application_1/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ExerciseData()),
          ChangeNotifierProvider(create: (context) => MondayExerciseData()),
          ChangeNotifierProvider(create: (context) => TuesdayExerciseData()),
          ChangeNotifierProvider(create: (context) => WednesdayExerciseData()),
          ChangeNotifierProvider(create: (context) => ThursdayExerciseData()),
          ChangeNotifierProvider(create: (context) => FridayExerciseData()),
          ChangeNotifierProvider(create: (context) => SaturdayExerciseData()),
          ChangeNotifierProvider(create: (context) => SundayExerciseData()),
          ChangeNotifierProvider(create: (context) => FriendsData())
          // Add other providers here
        ],
        child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'AtkinsonHyperlegible'),
            home: SplashScreen()));
  }
}
