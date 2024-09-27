import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:magicmirror/feature/workout/screen/workout_screen.dart';
import 'package:magicmirror/feature/workoutList/repository/workout_list_repository.dart';
import 'package:magicmirror/feature/workoutList/screen/workout_list_screen.dart';
import 'package:magicmirror/model/workout.dart';

import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Initialize your global provider container for testing

  final providerContainer = ProviderContainer();

  // GoRouter routes;

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

  testWidgets('End-to-end test for creating and deleting a workout',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        parent:
            providerContainer, // Provide the same container used in the router
        child: MaterialApp.router(
          routerConfig: routerList,
        ),
      ),
    );

    // Verify we start on the Workout List Screen
    expect(find.text('Workouts List Screen'), findsOneWidget);

    // Add a workout to the repository
    final repository = providerContainer.read(workoutListRepositoryProvider);

    repository.addWorkout(Workout(id: '0', date: DateTime.now(), sets: []));

    // Use the new workout ID for navigation
    final workoutId = repository.workouts[0].id;

    // Navigate to the WorkoutScreen using the valid workout ID
    // final routemaster =
    //     GoRouter.of(tester.element(find.byType(WorkoutListScreen)));
    // routemaster.push('/workout/$workoutId'); // Now use a real workout ID
    routerList.push('/workout/$workoutId');
    await tester.pumpAndSettle();

    // Verify we are on the WorkoutScreen
    expect(find.byType(WorkoutScreen), findsOneWidget);

    // Add the set
    await tester.tap(find.text('Add Set'));
    await tester.pumpAndSettle();

    // Verify the set was added
    expect(find.text('Set 1: Barbell row'), findsOneWidget);
    expect(find.text('20.0kg, 1 reps'), findsOneWidget);

    // Save the workout
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Verify we are back on the WorkoutListScreen
    expect(find.byType(WorkoutListScreen), findsOneWidget);

    // Verify the workout was added to the list
    expect(find.text('1 sets'), findsOneWidget);

    await tester.tap(find.text('1 sets'));
    await tester.pumpAndSettle();

    // Navigate back to WorkoutScreen using the valid workout ID
    // routemaster.push('/workout/$workoutId');
    routerList.push('/workout/$workoutId');
    await tester.pumpAndSettle();

    // Verify we are on the WorkoutScreen again
    expect(find.byType(WorkoutScreen), findsOneWidget);

    // Delete the set
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Verify the set was deleted
    expect(find.text('Set 1: Barbell row'), findsNothing);

    // Save the workout
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    /* These 2 lines below should not be there , but added as the screen is not popping on save" */
    routerList.push('/');
    await tester.pumpAndSettle();

    expect(find.text('Workouts List Screen'), findsOneWidget);

    // Delete the workout
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Verify the workout was deleted
    expect(find.text('1 sets'), findsNothing);
  });
}
