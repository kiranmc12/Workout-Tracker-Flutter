import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:workoutapp/models/cardio/cardio_model.dart';

class Cardiodb {
  static Future<bool> addCardio(CardioModel model) async {
    try {
      final userUid = FirebaseAuth.instance.currentUser!.uid;
      final userCardioBox = await Hive.openBox<CardioModel>(userUid);
      model.id = DateTime.now().day +
          DateTime.now().hour +
          DateTime.now().minute +
          DateTime.now().microsecond;
      await userCardioBox.put(model.id, model);

      print("Data added");
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  static Future<List<CardioModel>> retrieveCardio() async {
    final userUid = FirebaseAuth.instance.currentUser!.uid; 
    
    final db = await Hive.openBox<CardioModel>(userUid);
    return db.values.toList();
  }
}
