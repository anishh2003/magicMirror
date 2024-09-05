import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicmirror/model/workout.dart';

final workoutListRepositoryProvider = Provider(
  (_) => WorkoutListRepository(),
);

class WorkoutListRepository {
  final List<Workout> _workouts = [];

  List<Workout> get workouts => List.unmodifiable(_workouts);

  void addWorkout(Workout workout) {
    _workouts.add(workout);
  }

  void updateWorkout(Workout updatedWorkout) {
    final index =
        _workouts.indexWhere((workout) => workout.id == updatedWorkout.id);
    if (index != -1) {
      _workouts[index] = updatedWorkout;
    }
  }

  void deleteWorkout(String id) {
    _workouts.removeWhere((workout) => workout.id == id);
  }
}
