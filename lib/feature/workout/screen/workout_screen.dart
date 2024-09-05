import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicmirror/data/dropDownOptions.dart';
import 'package:magicmirror/feature/workout/controller/workout_controller.dart';
import 'package:magicmirror/model/exercise_set.dart';
import 'package:magicmirror/model/workout.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({this.workout, super.key});

  final Workout? workout;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  String selectedExercise = exerciseList[0];
  double selectedWeight = weightOptions[0];
  int selectedRepetitions = repetitionOptions[0];

  void _showEditDialog(BuildContext context, int index) {
    var exerciseSets = ref.read(exerciseSetControllerProvider);
    var set = exerciseSets[index];

    // Initialize dialog values
    String localExercise = set.exercise;
    double localWeight = set.weight;
    int localRepetitions = set.repetitions;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Edit Set'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    key: const ValueKey('exercise'),
                    value: localExercise,
                    items: exerciseList
                        .map((exercise) => DropdownMenuItem(
                              value: exercise,
                              child: Text(exercise),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        localExercise = value!;
                      });
                    },
                  ),
                  DropdownButton<double>(
                    key: const ValueKey('weight'),
                    value: localWeight,
                    items: weightOptions
                        .map((weight) => DropdownMenuItem(
                              value: weight,
                              child: Text('$weight kg'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        localWeight = value!;
                      });
                    },
                  ),
                  DropdownButton<int>(
                    key: const ValueKey('repetitions'),
                    value: localRepetitions,
                    items: repetitionOptions
                        .map((reps) => DropdownMenuItem(
                              value: reps,
                              child: Text('$reps repetitions'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        localRepetitions = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  key: const ValueKey('saveButton'),
                  onPressed: () {
                    // Update the set directly in the workout's list
                    ref.read(exerciseSetControllerProvider.notifier).updateSet(
                        index,
                        ExerciseSet(
                            exercise: localExercise,
                            weight: localWeight,
                            repetitions: localRepetitions));

                    // Trigger a UI update in the WorkoutScreen
                    setState(() {});
                    Navigator.of(ctx).pop();
                    setState(() {});
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveWorkout() {
    final workout = Workout(
      id: widget.workout?.id ?? UniqueKey().toString(),
      date: DateTime.now(),
      sets: ref.read(exerciseSetControllerProvider),
    );

    //TODO : add or update workout and pop screen
  }

  @override
  Widget build(BuildContext context) {
    var setControllerProvider = ref.watch(exerciseSetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Screen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveWorkout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Select an Exercise:"),
                DropdownButton<String>(
                  value: selectedExercise,
                  items: exerciseList
                      .map((exercise) => DropdownMenuItem(
                            value: exercise,
                            child: Text(exercise),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedExercise = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Select a weight:"),
                DropdownButton<double>(
                  value: selectedWeight,
                  items: weightOptions
                      .map((weight) => DropdownMenuItem(
                            value: weight,
                            child: Text("$weight kg"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedWeight = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Select repetitions:"),
                DropdownButton<int>(
                  value: selectedRepetitions,
                  items: repetitionOptions
                      .map((reps) => DropdownMenuItem(
                            value: reps,
                            child: Text("$reps"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRepetitions = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Add new set to the workout's set list
                  ref.read(exerciseSetControllerProvider.notifier).addSet(
                        ExerciseSet(
                          exercise: selectedExercise,
                          weight: selectedWeight,
                          repetitions: selectedRepetitions,
                        ),
                      );

                  // Reset to default values
                  selectedExercise = 'Barbell row';
                  selectedWeight = 20.0;
                  selectedRepetitions = 1;
                });
              },
              child: const Text("Add Set"),
            ),
            const SizedBox(height: 20.0),
            const Divider(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: setControllerProvider.length,
                itemBuilder: (BuildContext context, int index) {
                  var set = setControllerProvider[index];
                  return ListTile(
                    title: Text('Set ${index + 1}: ${set.exercise}'),
                    subtitle: Text("${set.weight}kg, ${set.repetitions} reps"),
                    trailing: SizedBox(
                      height: 60,
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditDialog(context, index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref
                                  .read(exerciseSetControllerProvider.notifier)
                                  .deleteSet(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
