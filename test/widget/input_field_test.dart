import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_box/features/box_interaction/presentation/widgets/input_field.dart';

void main() {
  group('InputField Widget Tests', () {
    late Function(String) onChanged;
    late VoidCallback onClear;
    late String? errorText;

    setUp(() {
      onChanged = (String value) {};
      onClear = () {};
      errorText = null;
    });

    Widget createInputField() {
      return MaterialApp(
        home: Scaffold(
          body: InputField(
            errorText: errorText,
            onChanged: onChanged,
            onClear: onClear,
          ),
        ),
      );
    }

    group('Basic Rendering', () {
      testWidgets('should render input field with correct label', (WidgetTester tester) async {
        await tester.pumpWidget(createInputField());

        expect(find.text('Enter a number (5-25)'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should not show clear button when input is empty', (WidgetTester tester) async {
        await tester.pumpWidget(createInputField());

        expect(find.byIcon(Icons.clear), findsNothing);
      });

      testWidgets('should show clear button when input has text', (WidgetTester tester) async {
        await tester.pumpWidget(createInputField());

        await tester.enterText(find.byType(TextField), '10');
        await tester.pump();

        expect(find.byIcon(Icons.clear), findsOneWidget);
      });
    });

    group('Input Functionality', () {
      testWidgets('should call onChanged when text is entered', (WidgetTester tester) async {
        String? capturedValue;
        onChanged = (String value) {
          capturedValue = value;
        };

        await tester.pumpWidget(createInputField());

        await tester.enterText(find.byType(TextField), '15');
        await tester.pump();

        expect(capturedValue, '15');
      });

      testWidgets('should call onClear when clear button is pressed', (WidgetTester tester) async {
        bool clearCalled = false;
        onClear = () {
          clearCalled = true;
        };

        await tester.pumpWidget(createInputField());

        // First enter some text
        await tester.enterText(find.byType(TextField), '10');
        await tester.pump();

        // Then press clear button
        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        expect(clearCalled, true);
      });

      testWidgets('should call onClear when input is manually cleared', (WidgetTester tester) async {
        bool clearCalled = false;
        onClear = () {
          clearCalled = true;
        };

        await tester.pumpWidget(createInputField());

        // Enter text
        await tester.enterText(find.byType(TextField), '10');
        await tester.pump();

        // Manually clear text
        await tester.enterText(find.byType(TextField), '');
        await tester.pump();

        expect(clearCalled, true);
      });
    });

    group('Error Display', () {
      testWidgets('should not show error when errorText is null', (WidgetTester tester) async {
        await tester.pumpWidget(createInputField());

        expect(find.text('Please enter a number between 5 and 25'), findsNothing);
      });

      testWidgets('should not show error when input is empty', (WidgetTester tester) async {
        errorText = 'Please enter a number between 5 and 25';
        await tester.pumpWidget(createInputField());

        expect(find.text('Please enter a number between 5 and 25'), findsNothing);
      });

      testWidgets('should show error when errorText is provided and input has text', (WidgetTester tester) async {
        errorText = 'Please enter a number between 5 and 25';
        await tester.pumpWidget(createInputField());

        await tester.enterText(find.byType(TextField), '30');
        await tester.pump();

        expect(find.text('Please enter a number between 5 and 25'), findsOneWidget);
      });

      testWidgets('should style error text in red', (WidgetTester tester) async {
        errorText = 'Please enter a number between 5 and 25';
        await tester.pumpWidget(createInputField());

        await tester.enterText(find.byType(TextField), '30');
        await tester.pump();

        final errorTextWidget = tester.widget<Text>(
          find.text('Please enter a number between 5 and 25'),
        );
        expect(errorTextWidget.style?.color, Colors.red);
      });
    });

    group('Keyboard Type', () {
      testWidgets('should have number keyboard type', (WidgetTester tester) async {
        await tester.pumpWidget(createInputField());

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.keyboardType, TextInputType.number);
      });
    });

    group('Integration with State', () {
      testWidgets('should update state when text changes', (WidgetTester tester) async {
        List<String> capturedValues = [];
        onChanged = (String value) {
          capturedValues.add(value);
        };

        await tester.pumpWidget(createInputField());

        await tester.enterText(find.byType(TextField), '1');
        await tester.pump();
        await tester.enterText(find.byType(TextField), '12');
        await tester.pump();
        await tester.enterText(find.byType(TextField), '123');
        await tester.pump();

        expect(capturedValues, ['1', '12', '123']);
      });
    });
  });
}
