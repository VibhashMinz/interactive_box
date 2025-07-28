import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_box/features/box_interaction/presentation/widgets/box_tile.dart';

void main() {
  group('BoxTile Widget Tests', () {
    late VoidCallback onTap;
    late Color color;
    late double size;

    setUp(() {
      onTap = () {};
      color = Colors.red;
      size = 50.0;
    });

    Widget createBoxTile() {
      return MaterialApp(
        home: Scaffold(
          body: BoxTile(
            color: color,
            onTap: onTap,
            size: size,
          ),
        ),
      );
    }

    group('Basic Rendering', () {
      testWidgets('should render with correct color', (WidgetTester tester) async {
        await tester.pumpWidget(createBoxTile());

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(AnimatedContainer),
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, Colors.red);
      });

      testWidgets('should render with correct size', (WidgetTester tester) async {
        await tester.pumpWidget(createBoxTile());

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(AnimatedContainer),
            matching: find.byType(Container),
          ),
        );

        expect(container.constraints?.maxWidth, 50.0);
        expect(container.constraints?.maxHeight, 50.0);
      });

      testWidgets('should render with custom size', (WidgetTester tester) async {
        size = 30.0;
        await tester.pumpWidget(createBoxTile());

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(AnimatedContainer),
            matching: find.byType(Container),
          ),
        );

        expect(container.constraints?.maxWidth, 30.0);
        expect(container.constraints?.maxHeight, 30.0);
      });

      testWidgets('should render with default size when not specified', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BoxTile(
                color: color,
                onTap: onTap,
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(AnimatedContainer),
            matching: find.byType(Container),
          ),
        );

        expect(container.constraints?.maxWidth, 50.0);
        expect(container.constraints?.maxHeight, 50.0);
      });
    });

    group('Tap Functionality', () {
      testWidgets('should call onTap when tapped', (WidgetTester tester) async {
        bool tapCalled = false;
        onTap = () {
          tapCalled = true;
        };

        await tester.pumpWidget(createBoxTile());

        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        expect(tapCalled, true);
      });

      testWidgets('should be tappable', (WidgetTester tester) async {
        await tester.pumpWidget(createBoxTile());

        expect(find.byType(GestureDetector), findsOneWidget);
      });
    });

    group('Animation Properties', () {
      testWidgets('should have correct animation duration', (WidgetTester tester) async {
        await tester.pumpWidget(createBoxTile());

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        expect(animatedContainer.duration, const Duration(milliseconds: 400));
      });

      testWidgets('should have correct animation curve', (WidgetTester tester) async {
        await tester.pumpWidget(createBoxTile());

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        expect(animatedContainer.curve, Curves.easeInOut);
      });
    });

    group('Decoration Properties', () {
      testWidgets('should have square shape (no border radius)', (WidgetTester tester) async {
        await tester.pumpWidget(createBoxTile());

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(AnimatedContainer),
            matching: find.byType(Container),
          ),
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, isNull);
      });
    });

    group('Integration Tests', () {
      testWidgets('should handle multiple rapid taps', (WidgetTester tester) async {
        int tapCount = 0;
        onTap = () {
          tapCount++;
        };

        await tester.pumpWidget(createBoxTile());

        // Tap multiple times rapidly
        await tester.tap(find.byType(GestureDetector));
        await tester.tap(find.byType(GestureDetector));
        await tester.tap(find.byType(GestureDetector));
        await tester.pump();

        expect(tapCount, 3);
      });
    });
  });
}
