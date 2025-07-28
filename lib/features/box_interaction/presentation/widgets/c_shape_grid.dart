import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_box/features/box_interaction/application/box_controller.dart';
import 'package:interactive_box/features/box_interaction/presentation/widgets/box_tile.dart';

class CShapeGrid extends ConsumerWidget {
  const CShapeGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(boxControllerProvider);
    final controller = ref.read(boxControllerProvider.notifier);

    final int? boxCount = state.boxCount;
    final colors = state.boxColors;

    if (boxCount == null || boxCount <= 0) {
      return const SizedBox.shrink();
    }

    // Responsive: Use LayoutBuilder to get max width
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate C-shape dimensions
        final topCount = (boxCount / 3).ceil();
        final bottomCount = topCount;
        final middleCount = boxCount - topCount - bottomCount;

        // Calculate box size and spacing
        const minBoxSize = 28.0;
        const maxBoxSize = 50.0;
        const minSpacing = 2.0;
        const maxSpacing = 8.0;
        final totalSpacing = (topCount - 1) * maxSpacing;
        double boxSize = ((constraints.maxWidth - totalSpacing) / topCount).clamp(minBoxSize, maxBoxSize);
        double spacing = boxSize < maxBoxSize ? minSpacing : maxSpacing;

        return SingleChildScrollView(
          child: _buildCShapeLayout(
            boxCount,
            colors,
            controller,
            boxSize,
            spacing,
            topCount,
            middleCount,
            bottomCount,
          ),
        );
      },
    );
  }

  Widget _buildCShapeLayout(
    int boxCount,
    List<Color> colors,
    BoxController controller,
    double boxSize,
    double spacing,
    int topCount,
    int middleCount,
    int bottomCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(topCount, (index) {
              return Padding(
                padding: EdgeInsets.all(spacing),
                child: BoxTile(
                  color: colors[index],
                  onTap: () => controller.toggleBox(index),
                  size: boxSize,
                ),
              );
            }),
          ),
          // Middle section
          ...List.generate(middleCount, (index) {
            final boxIndex = topCount + index;
            return Padding(
              padding: EdgeInsets.all(spacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BoxTile(
                    color: colors[boxIndex],
                    onTap: () => controller.toggleBox(boxIndex),
                    size: boxSize,
                  ),
                ],
              ),
            );
          }),
          // Bottom row
          if (bottomCount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(bottomCount, (index) {
                final boxIndex = topCount + middleCount + index;
                return Padding(
                  padding: EdgeInsets.all(spacing),
                  child: BoxTile(
                    color: colors[boxIndex],
                    onTap: () => controller.toggleBox(boxIndex),
                    size: boxSize,
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
