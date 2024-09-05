import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicmirror/feature/workout/controller/workout_controller.dart';
import 'package:magicmirror/feature/workout/screen/workout_screen.dart';
import 'package:magicmirror/feature/workoutList/controller/workout_list_controller.dart';

class WorkoutListScreen extends ConsumerWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutList = ref.watch(workoutListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts List Screen'),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            ref.read(exerciseSetControllerProvider.notifier).clearSets();
            ref.read(currentWorkoutProvider.notifier).update((state) => null);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const WorkoutScreen(),
              ),
            );
          }),
      body: ListView.builder(
        itemCount: workoutList.length,
        itemBuilder: (ctx, index) {
          final workout = workoutList[index];
          return ListTile(
            title: Text('Workout on ${workout.date}'),
            subtitle: Text('${workout.sets.length} sets'),
            onTap: () {
              ref.read(exerciseSetControllerProvider.notifier).clearSets();
              ref
                  .read(exerciseSetControllerProvider.notifier)
                  .loadWorkoutSets(workout.sets);
              ref
                  .read(currentWorkoutProvider.notifier)
                  .update((state) => workout);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WorkoutScreen(workout: workout),
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref
                    .read(workoutListControllerProvider.notifier)
                    .deleteWorkout(workout.id);
              },
            ),
          );
        },
      ),
    );
  }
}
