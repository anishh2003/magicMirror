import 'package:magicmirror/model/exercise_set.dart';

class Workout {
  final String id;
  final DateTime date;
  final List<ExerciseSet> sets;

  Workout({
    required this.id,
    required this.date,
    required this.sets,
  });
}
