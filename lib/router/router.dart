import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magicmirror/feature/workout/screen/workout_screen.dart';
import 'package:magicmirror/feature/workoutList/repository/workout_list_repository.dart';
import 'package:magicmirror/feature/workoutList/screen/workout_list_screen.dart';
import 'package:routemaster/routemaster.dart';

final providerContainer = ProviderContainer();

final routesList = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: WorkoutListScreen()),
  '/workout/:workoutId': (routeData) {
    final workoutId = routeData.pathParameters['workoutId'];

    // Use the global provider container to read the repository provider
    final repository = providerContainer.read(workoutListRepositoryProvider);

    // Fetch the workout by ID
    final workout =
        workoutId != null ? repository.getWorkoutById(workoutId) : null;

    return MaterialPage(
      child: WorkoutScreen(
        workout: workout,
      ),
    );
  },
});
