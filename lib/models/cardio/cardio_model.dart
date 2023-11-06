import 'package:hive/hive.dart';
part 'cardio_model.g.dart';

@HiveType(typeId: 1)
class CardioModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String cardioName;

  @HiveField(2)
  late int durationMillis;

  @HiveField(3)
  double caloriesBurnt;

    @HiveField(4)
  late String cardioDate;

  CardioModel({
    required this.id,
    required this.cardioName,
    required this.durationMillis,
    required this.caloriesBurnt,
    required this.cardioDate,
  });
}
