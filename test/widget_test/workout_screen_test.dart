import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:magicmirror/feature/workout/screen/workout_screen.dart';
import 'package:magicmirror/feature/workoutList/screen/workout_list_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  GoRouter? routes;

  setUp(() {
    // Recreate routes before each test to ensure a fresh instance
    routes = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const WorkoutListScreen(),
        ),
        GoRoute(
          path: '/workout',
          builder: (context, state) => const WorkoutScreen(),
        ),
      ],
    );
  });

  tearDown(() {
    // Clean up after each test if necessary
    routes = null;
  });

  testWidgets('WorkoutScreen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: routes!,
        ),
      ),
    );

    // Directly navigate to WorkoutScreen
    routes!.go('/workout');
    await tester.pumpAndSettle();

    // Verify WorkoutScreen contents
    expect(find.text('Select an Exercise:'), findsOneWidget);
  });

  testWidgets('Add Set button adds a set', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: routes!,
        ),
      ),
    );

    // Directly navigate to WorkoutScreen
    routes!.go('/workout');
    await tester.pumpAndSettle();

    // Add set
    await tester.tap(find.text('Add Set'));
    await tester.pump();

    // Verify added set details
    expect(find.text('Set 1: Barbell row'), findsOneWidget);
  });

  testWidgets('Save workout button works', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: routes!,
        ),
      ),
    );

    // Directly navigate to WorkoutScreen
    routes!.push('/workout');
    await tester.pumpAndSettle();

    // Tap on save button
    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Verify that navigation returns to WorkoutListScreen
    expect(find.byType(WorkoutListScreen), findsOneWidget);
  });
}
