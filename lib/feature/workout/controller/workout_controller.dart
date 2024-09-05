import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicmirror/feature/workout/repository/workout_repository.dart';
import 'package:magicmirror/model/exercise_set.dart';

final exerciseSetControllerProvider =
    StateNotifierProvider<SetController, List<ExerciseSet>>((ref) {
  return SetController(ref.read(setRepositoryProvider));
});

class SetController extends StateNotifier<List<ExerciseSet>> {
  final SetRepository _repository;

  SetController(this._repository) : super([]);

  void loadWorkoutSets(List<ExerciseSet> workOutSets) {
    _repository.initializeSets(workOutSets);
    state = _repository.sets;
  }

  void addSet(ExerciseSet newSet) {
    _repository.addSet(newSet);
    state = [..._repository.sets];
  }

  void updateSet(int index, ExerciseSet updatedSet) {
    _repository.updateSet(index, updatedSet);
    state = [..._repository.sets];
  }

  void deleteSet(int index) {
    _repository.deleteSet(index);
    state = [..._repository.sets];
  }

  void clearSets() {
    _repository.clearSets();
    state = [];
  }
}
