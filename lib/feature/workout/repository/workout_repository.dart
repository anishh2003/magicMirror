import 'package:magicmirror/model/exercise_set.dart';

class SetRepository {
  List<ExerciseSet> _sets = [];

  List<ExerciseSet> get sets => _sets;

  void initializeSets(List<ExerciseSet> workoutSets) {
    _sets = workoutSets;
  }

  void addSet(ExerciseSet newSet) {
    _sets.add(newSet);
  }

  void updateSet(int index, ExerciseSet updatedSet) {
    _sets[index] = updatedSet;
  }

  void deleteSet(int index) {
    _sets.removeAt(index);
  }

  void clearSets() {
    _sets = [];
  }
}
