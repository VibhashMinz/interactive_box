import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_box/features/box_interaction/application/box_controller.dart';
import 'package:interactive_box/features/box_interaction/application/box_state.dart';

void main() {
  group('BoxController Tests', () {
    late ProviderContainer container;
    late BoxController controller;

    setUp(() {
      container = ProviderContainer();
      controller = container.read(boxControllerProvider.notifier);
    });

    tearDown(() async {
      // Wait for any pending timers to complete
      await Future.delayed(const Duration(milliseconds: 700));
      container.dispose();
    });

    // Helper function to wait for debounce completion
    Future<void> waitForDebounce() async {
      await Future.delayed(const Duration(milliseconds: 600));
      // Wait a bit more to ensure state is updated
      await Future.delayed(const Duration(milliseconds: 100));
    }

    group('updateBoxCount', () {
      test('should set loading to true when input changes', () async {
        controller.updateBoxCount('10');

        expect(container.read(boxControllerProvider).loading, true);

        // Wait for debounce to complete
        await waitForDebounce();
      });

      test('should validate input range 5-25', () async {
        // Valid inputs
        controller.updateBoxCount('5');
        await waitForDebounce();
        expect(container.read(boxControllerProvider).errorMessage, isNull);
        expect(container.read(boxControllerProvider).boxCount, 5);

        controller.updateBoxCount('25');
        await waitForDebounce();
        expect(container.read(boxControllerProvider).errorMessage, isNull);
        expect(container.read(boxControllerProvider).boxCount, 25);

        // Invalid inputs
        controller.updateBoxCount('4');
        await waitForDebounce();
        expect(container.read(boxControllerProvider).errorMessage, 'Please enter a number between 5 and 25');
        expect(container.read(boxControllerProvider).boxCount, 0);

        controller.updateBoxCount('26');
        await waitForDebounce();
        expect(container.read(boxControllerProvider).errorMessage, 'Please enter a number between 5 and 25');
        expect(container.read(boxControllerProvider).boxCount, 0);
      });

      test('should handle non-numeric input', () async {
        controller.updateBoxCount('abc');
        await waitForDebounce();
        expect(container.read(boxControllerProvider).errorMessage, 'Please enter a number between 5 and 25');
        expect(container.read(boxControllerProvider).boxCount, 0);
      });

      test('should generate correct number of red boxes', () async {
        controller.updateBoxCount('10');
        await waitForDebounce();

        final state = container.read(boxControllerProvider);
        expect(state.boxCount, 10);
        expect(state.boxColors.length, 10);
        expect(state.boxColors.every((color) => color == Colors.red), true);
        expect(state.clickedOrder.isEmpty, true);
      });

      test('should clear input and reset state', () async {
        // First set some boxes
        controller.updateBoxCount('10');
        await waitForDebounce();
        expect(container.read(boxControllerProvider).boxCount, 10);

        // Then clear
        controller.clearInput();
        final state = container.read(boxControllerProvider);
        expect(state.boxCount, isNull);
        expect(state.boxColors.isEmpty, true);
        expect(state.clickedOrder.isEmpty, true);
        expect(state.errorMessage, isNull);
        expect(state.loading, false);
      });
    });

    group('toggleBox', () {
      setUp(() async {
        controller.updateBoxCount('6');
        await waitForDebounce();
      });

      test('should change box color from red to green', () async {
        controller.toggleBox(0);

        final state = container.read(boxControllerProvider);
        expect(state.boxColors[0], Colors.green);
        expect(state.clickedOrder, [0]);
      });

      test('should track click order', () async {
        controller.toggleBox(0);
        controller.toggleBox(2);
        controller.toggleBox(1);

        final state = container.read(boxControllerProvider);
        expect(state.clickedOrder, [0, 2, 1]);
      });

      test('should not toggle already green boxes', () async {
        controller.toggleBox(0);
        controller.toggleBox(0); // Try to toggle same box again

        final state = container.read(boxControllerProvider);
        expect(state.clickedOrder, [0]); // Should not add duplicate
      });
    });

    group('toggleLayout', () {
      test('should switch between grid and c-shape layouts', () {
        final initialState = container.read(boxControllerProvider);
        expect(initialState.layoutType, LayoutType.grid);

        controller.toggleLayout();
        expect(container.read(boxControllerProvider).layoutType, LayoutType.cShape);

        controller.toggleLayout();
        expect(container.read(boxControllerProvider).layoutType, LayoutType.grid);
      });
    });
  });
}
