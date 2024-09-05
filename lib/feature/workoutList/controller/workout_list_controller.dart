import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicmirror/feature/workoutList/repository/workout_list_repository.dart';
import 'package:magicmirror/model/workout.dart';

final currentWorkoutProvider = StateProvider<Workout?>((ref) {
  return null;
});

final workoutListControllerProvider =
    StateNotifierProvider<WorkoutListController, List<Workout>>((ref) {
  return WorkoutListController(ref.read(workoutListRepositoryProvider));
});

class WorkoutListController extends StateNotifier<List<Workout>> {
  final WorkoutListRepository _repository;

  WorkoutListController(this._repository) : super([]);

  void addWorkout(Workout workout) {
    _repository.addWorkout(workout);
    state = [..._repository.workouts];
  }

  void updateWorkout(Workout workout) {
    _repository.updateWorkout(workout);
    state = [..._repository.workouts];
  }

  void deleteWorkout(String id) {
    _repository.deleteWorkout(id);
    state = [..._repository.workouts];
  }
}
