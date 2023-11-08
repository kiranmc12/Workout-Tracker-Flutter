import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:workoutapp/functions/workoutdb.dart';
import 'package:workoutapp/models/cardio/cardio_model.dart';
import 'package:workoutapp/models/workoutguide/workout_guide_model.dart';
import 'package:workoutapp/screens/login/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(WorkoutGuideAdapter().typeId)) {
    Hive.registerAdapter(WorkoutGuideAdapter());
  }
  await Hive.openBox<WorkoutGuide>('exercise_guide');

  if (!Hive.isAdapterRegistered(CardioModelAdapter().typeId)) {
    Hive.registerAdapter(CardioModelAdapter());
  }
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userUid = user.uid;
    await Hive.openBox<CardioModel>(userUid);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: AnimatedSplashScreen(
          splashTransition: SplashTransition.rotationTransition,
          backgroundColor: const Color.fromRGBO(19, 18, 18, 1),
          splash: Image.asset(
            'assets/dumbell.png',
            color: Colors.amber,
          ),
          nextScreen: const SplashScreen(),
        ),
      ),
    );
  }
}
