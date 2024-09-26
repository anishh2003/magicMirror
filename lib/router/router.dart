import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:magicmirror/feature/workout/screen/workout_screen.dart';
import 'package:magicmirror/feature/workoutList/repository/workout_list_repository.dart';
import 'package:magicmirror/feature/workoutList/screen/workout_list_screen.dart';

final providerContainer = ProviderContainer();

final routerList = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WorkoutListScreen(),
    ),
    GoRoute(
      path: '/workout/:workoutId',
      builder: (context, state) {
        final workoutId = state.pathParameters['workoutId'];

        // Use the global provider container to read the repository provider
        final repository =
            providerContainer.read(workoutListRepositoryProvider);
        // Fetch the workout by ID
        final workout =
            workoutId != null ? repository.getWorkoutById(workoutId) : null;
        return WorkoutScreen(
          workout: workout,
        );
      },
    )
  ],
);
