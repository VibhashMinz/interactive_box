import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_box/features/box_interaction/application/box_controller.dart';
import 'package:interactive_box/features/box_interaction/presentation/widgets/box_tile.dart';

class BoxGrid extends ConsumerWidget {
  const BoxGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(boxControllerProvider);
    final controller = ref.read(boxControllerProvider.notifier);

    final int boxCount = state.boxCount!;
    final colors = state.boxColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double boxSize = 50;
        final int crossAxisCount = (constraints.maxWidth / (boxSize + 10)).floor();

        return GridView.builder(
          padding: const EdgeInsets.all(4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemCount: boxCount,
          itemBuilder: (context, index) {
            return BoxTile(
              color: colors[index],
              onTap: () => controller.toggleBox(index),
            );
          },
        );
      },
    );
  }
}
