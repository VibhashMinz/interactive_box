import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'box_state.dart';

final boxControllerProvider = StateNotifierProvider<BoxController, BoxState>((ref) {
  return BoxController();
});

class BoxController extends StateNotifier<BoxState> {
  Timer? _debounceTimer;
  BoxController() : super(BoxState.initial());

  void updateBoxCount(String input) {
    // Cancel any existing debounce timer
    _debounceTimer?.cancel();
    // Set loading to true immediately
    state = state.copyWith(loading: true);

    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      final parsed = int.tryParse(input);
      if (parsed == null || parsed < 5 || parsed > 25) {
        state = state.copyWith(
          errorMessage: "Please enter a number between 5 and 25",
          boxCount: 0,
          boxColors: [],
          clickedOrder: [],
          loading: false,
        );
        return;
      }

      final colors = List<Color>.filled(parsed, Colors.red);
      state = state.copyWith(
        boxCount: parsed,
        boxColors: colors,
        clickedOrder: [],
        errorMessage: null,
        loading: false,
      );
    });
  }

  void toggleBox(int index) {
    if (state.isReverting) return;

    final colors = [...state.boxColors];
    if (colors[index] == Colors.green) return;

    colors[index] = Colors.green;
    final newOrder = [...state.clickedOrder, index];

    state = state.copyWith(boxColors: colors, clickedOrder: newOrder);

    if (newOrder.length == state.boxCount) {
      _startRevertAnimation();
    }
  }

  Future<void> _startRevertAnimation() async {
    state = state.copyWith(isReverting: true);

    final colors = [...state.boxColors];
    final clickOrder = [...state.clickedOrder].reversed;

    for (final index in clickOrder) {
      await Future.delayed(const Duration(seconds: 1));
      colors[index] = Colors.red;
      state = state.copyWith(boxColors: [...colors]);
    }

    state = state.copyWith(clickedOrder: [], isReverting: false);
  }

  void clearInput() {
    _debounceTimer?.cancel();
    state = BoxState.initial();
  }

  void toggleLayout() {
    final newLayoutType = state.layoutType == LayoutType.grid ? LayoutType.cShape : LayoutType.grid;
    state = state.copyWith(layoutType: newLayoutType);
  }
}
