import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicmirror/feature/workout/controller/workout_controller.dart';
import 'package:magicmirror/feature/workout/repository/workout_repository.dart';
import 'package:magicmirror/model/exercise_set.dart';

void main() {
  late SetRepository setRepository;
  late ProviderContainer container;
  late SetController setController;

  setUp(() {
    // Initialize the SetRepository and ProviderContainer
    setRepository = SetRepository();
    container = ProviderContainer(
      overrides: [
        setRepositoryProvider.overrideWithValue(setRepository),
      ],
    );
    setController = container.read(exerciseSetControllerProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('SetController tests', () {
    test('Initial state is empty', () {
      expect(container.read(exerciseSetControllerProvider), []);
    });

    test('loadWorkoutSets populates the state', () {
      final testSets = [
        ExerciseSet(exercise: 'Bench Press', weight: 60.0, repetitions: 10),
        ExerciseSet(exercise: 'Squat', weight: 80.0, repetitions: 8),
      ];

      setController.loadWorkoutSets(testSets);
      expect(container.read(exerciseSetControllerProvider), testSets);
    });

    test('addSet adds a set', () {
      final newSet =
          ExerciseSet(exercise: 'Deadlift', weight: 100.0, repetitions: 5);

      setController.addSet(newSet);

      expect(container.read(exerciseSetControllerProvider), [newSet]);
    });

    test('updateSet updates a set', () {
      final initialSet =
          ExerciseSet(exercise: 'Shoulder press', weight: 0.0, repetitions: 12);
      setController.addSet(initialSet);

      final updatedSet = ExerciseSet(
          exercise: 'Shoulder press', weight: 10.0, repetitions: 10);
      setController.updateSet(0, updatedSet);

      expect(container.read(exerciseSetControllerProvider), [updatedSet]);
    });

    test('deleteSet removes a set', () {
      final testSet =
          ExerciseSet(exercise: 'Squat', weight: 0.0, repetitions: 15);
      setController.addSet(testSet);

      setController.deleteSet(0);

      expect(container.read(exerciseSetControllerProvider), []);
    });

    test('clearSets clears all sets', () {
      final testSets = [
        ExerciseSet(exercise: 'Bench Press', weight: 60.0, repetitions: 10),
        ExerciseSet(exercise: 'Squat', weight: 80.0, repetitions: 8),
      ];

      setController.loadWorkoutSets(testSets);
      setController.clearSets();

      expect(container.read(exerciseSetControllerProvider), []);
    });
  });

  group('SetRepository tests', () {
    test('initializeSets sets the list of sets', () {
      final testSets = [
        ExerciseSet(exercise: 'Bench Press', weight: 60.0, repetitions: 10),
        ExerciseSet(exercise: 'Squat', weight: 80.0, repetitions: 8),
      ];

      setRepository.initializeSets(testSets);

      expect(setRepository.sets, testSets);
    });

    test('addSet adds a set to the repository', () {
      final newSet =
          ExerciseSet(exercise: 'Deadlift', weight: 100.0, repetitions: 5);

      setRepository.addSet(newSet);

      expect(setRepository.sets, [newSet]);
    });

    test('updateSet updates an existing set', () {
      final initialSet =
          ExerciseSet(exercise: 'Squat', weight: 0.0, repetitions: 12);
      setRepository.addSet(initialSet);

      final updatedSet =
          ExerciseSet(exercise: 'Squat', weight: 10.0, repetitions: 10);
      setRepository.updateSet(0, updatedSet);

      expect(setRepository.sets[0], updatedSet);
    });

    test('deleteSet removes a set from the repository', () {
      final testSet =
          ExerciseSet(exercise: 'Deadlift', weight: 0.0, repetitions: 15);
      setRepository.addSet(testSet);

      setRepository.deleteSet(0);

      expect(setRepository.sets, []);
    });

    test('clearSets clears all sets in the repository', () {
      final testSets = [
        ExerciseSet(exercise: 'Bench Press', weight: 60.0, repetitions: 10),
        ExerciseSet(exercise: 'Squat', weight: 80.0, repetitions: 8),
      ];

      setRepository.initializeSets(testSets);
      setRepository.clearSets();

      expect(setRepository.sets, []);
    });
  });
}
