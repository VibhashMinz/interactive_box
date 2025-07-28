import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_box/main.dart';

void main() {
  group('Interactive Box App Integration Tests', () {
    testWidgets('Complete user flow test', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle();

      // Test 1: Initial state
      expect(find.text('Interactive Boxes'), findsOneWidget);
      expect(find.text('Enter a number (5-25)'), findsOneWidget);
      expect(find.text('Grid Layout'), findsNothing);
      expect(find.text('C-Shape Layout (Bonus)'), findsNothing);

      // Test 2: Enter valid input
      await tester.enterText(find.byType(TextField), '6');
      await tester.pump();

      // Should show loading indicator
      expect(find.text('Generating boxes...'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should show grid layout
      expect(find.text('Grid Layout'), findsOneWidget);
      expect(find.text('Switch to C-Shape'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);

      // Test 3: Switch to C-shape layout
      await tester.tap(find.text('Switch to C-Shape'));
      await tester.pumpAndSettle();

      expect(find.text('C-Shape Layout (Bonus)'), findsOneWidget);
      expect(find.text('Switch to Grid'), findsOneWidget);

      // Test 4: Switch back to grid
      await tester.tap(find.text('Switch to Grid'));
      await tester.pumpAndSettle();

      expect(find.text('Grid Layout'), findsOneWidget);
      expect(find.text('Switch to C-Shape'), findsOneWidget);

      // Test 5: Clear input
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(find.text('Grid Layout'), findsNothing);
      expect(find.text('C-Shape Layout (Bonus)'), findsNothing);
      expect(find.text('Switch to C-Shape'), findsNothing);
    });

    testWidgets('Input validation test', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle();

      // Test invalid input (too low)
      await tester.enterText(find.byType(TextField), '4');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      expect(find.text('Please enter a number between 5 and 25'), findsOneWidget);
      expect(find.text('Grid Layout'), findsNothing);

      // Test invalid input (too high)
      await tester.enterText(find.byType(TextField), '26');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      expect(find.text('Please enter a number between 5 and 25'), findsOneWidget);
      expect(find.text('Grid Layout'), findsNothing);

      // Test non-numeric input
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      expect(find.text('Please enter a number between 5 and 25'), findsOneWidget);
      expect(find.text('Grid Layout'), findsNothing);

      // Test valid input
      await tester.enterText(find.byType(TextField), '10');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      expect(find.text('Please enter a number between 5 and 25'), findsNothing);
      expect(find.text('Grid Layout'), findsOneWidget);
    });

    testWidgets('Box interaction test', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle();

      // Generate boxes
      await tester.enterText(find.byType(TextField), '5');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Find and tap first box
      final boxes = find.byType(GestureDetector);
      expect(boxes, findsWidgets);

      if (boxes.evaluate().isNotEmpty) {
        await tester.tap(boxes.first);
        await tester.pumpAndSettle();
      }

      // Wait for revert animation to complete
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('Debounce functionality test', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle();

      // Type rapidly
      await tester.enterText(find.byType(TextField), '1');
      await tester.pump();
      await tester.enterText(find.byType(TextField), '12');
      await tester.pump();
      await tester.enterText(find.byType(TextField), '123');
      await tester.pump();

      // Should show loading
      expect(find.text('Generating boxes...'), findsOneWidget);

      // Wait for debounce
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should show error for invalid input
      expect(find.text('Please enter a number between 5 and 25'), findsOneWidget);
    });

    testWidgets('Error state handling test', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle();

      // Enter invalid input
      await tester.enterText(find.byType(TextField), '30');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should show error but not layout controls
      expect(find.text('Please enter a number between 5 and 25'), findsOneWidget);
      expect(find.text('Switch to C-Shape'), findsNothing);
      expect(find.text('Grid Layout'), findsNothing);

      // Clear error by entering valid input
      await tester.enterText(find.byType(TextField), '10');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should show layout controls
      expect(find.text('Please enter a number between 5 and 25'), findsNothing);
      expect(find.text('Switch to C-Shape'), findsOneWidget);
      expect(find.text('Grid Layout'), findsOneWidget);
    });
  });
}
