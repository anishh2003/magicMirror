import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicmirror/feature/workout/screen/workout_screen.dart';
import 'package:magicmirror/feature/workoutList/screen/workout_list_screen.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  final routes = RouteMap(
    routes: {
      '/': (_) => const MaterialPage(child: WorkoutListScreen()),
      '/workout': (_) => const MaterialPage(child: WorkoutScreen()),
    },
  );

  testWidgets('WorkoutScreen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routeInformationParser: const RoutemasterParser(),
          routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
        ),
      ),
    );

    // Navigate to WorkoutScreen
    final routemaster =
        Routemaster.of(tester.element(find.byType(WorkoutListScreen)));
    routemaster.push('/workout');
    await tester.pumpAndSettle();

    expect(find.text('Select an Exercise:'), findsOneWidget);
    expect(find.text('Select a weight:'), findsOneWidget);
    expect(find.text('Select repetitions:'), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsNWidgets(1));
    expect(find.byType(DropdownButton<double>), findsNWidgets(1));
    expect(find.byType(DropdownButton<int>), findsNWidgets(1));
    expect(find.text('Add Set'), findsOneWidget);
  });

  testWidgets('Add Set button adds a set', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routeInformationParser: const RoutemasterParser(),
          routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
        ),
      ),
    );

    // Navigate to WorkoutScreen
    final routemaster =
        Routemaster.of(tester.element(find.byType(WorkoutListScreen)));
    routemaster.push('/workout');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Set'));
    await tester.pump();

    expect(find.text('Set 1: Barbell row'), findsOneWidget);
    expect(find.text('20.0kg, 1 reps'), findsOneWidget);
  });

  testWidgets('Delete Set button removes the set', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routeInformationParser: const RoutemasterParser(),
          routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
        ),
      ),
    );

    // Navigate to WorkoutScreen
    final routemaster =
        Routemaster.of(tester.element(find.byType(WorkoutListScreen)));
    routemaster.push('/workout');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Set'));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('Set 1: Barbell row'), findsNothing);
  });

  testWidgets('Save workout button works', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routeInformationParser: const RoutemasterParser(),
          routerDelegate: RoutemasterDelegate(routesBuilder: (_) => routes),
        ),
      ),
    );

    // Navigate to WorkoutScreen
    final routemaster =
        Routemaster.of(tester.element(find.byType(WorkoutListScreen)));
    routemaster.push('/workout');
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.save));
    await tester.pumpAndSettle();

    // Since saving pops the screen, expect WorkoutListScreen to be shown
    expect(find.byType(WorkoutListScreen), findsOneWidget);
  });
}
