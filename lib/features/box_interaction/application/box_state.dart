import 'package:flutter/material.dart';

enum LayoutType { grid, cShape }

class BoxState {
  final int? boxCount;
  final List<Color> boxColors;
  final List<int> clickedOrder;
  final bool isReverting;
  final String? errorMessage;
  final bool loading;
  final LayoutType layoutType;

  BoxState({
    this.boxCount,
    required this.boxColors,
    required this.clickedOrder,
    required this.isReverting,
    this.errorMessage,
    this.loading = false,
    this.layoutType = LayoutType.grid,
  });

  factory BoxState.initial() {
    return BoxState(
      boxCount: null,
      boxColors: [],
      clickedOrder: [],
      isReverting: false,
      errorMessage: null,
      loading: false,
      layoutType: LayoutType.grid,
    );
  }

  BoxState copyWith({
    int? boxCount,
    List<Color>? boxColors,
    List<int>? clickedOrder,
    bool? isReverting,
    String? errorMessage,
    bool? loading,
    LayoutType? layoutType,
  }) {
    return BoxState(
      boxCount: boxCount ?? this.boxCount,
      boxColors: boxColors ?? this.boxColors,
      clickedOrder: clickedOrder ?? this.clickedOrder,
      isReverting: isReverting ?? this.isReverting,
      errorMessage: errorMessage,
      loading: loading ?? this.loading,
      layoutType: layoutType ?? this.layoutType,
    );
  }
}
