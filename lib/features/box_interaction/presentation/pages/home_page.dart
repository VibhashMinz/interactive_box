import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_box/features/box_interaction/application/box_controller.dart';
import 'package:interactive_box/features/box_interaction/application/box_state.dart';
import 'package:interactive_box/features/box_interaction/presentation/widgets/box_grid.dart';
import 'package:interactive_box/features/box_interaction/presentation/widgets/c_shape_grid.dart';
import 'package:interactive_box/features/box_interaction/presentation/widgets/input_field.dart';
import 'package:interactive_box/features/box_interaction/presentation/widgets/fancy_loader.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxState = ref.watch(boxControllerProvider);
    final controller = ref.read(boxControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Boxes'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside input field
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              InputField(
                errorText: boxState.errorMessage,
                onChanged: controller.updateBoxCount,
                onClear: controller.clearInput,
              ),
              const SizedBox(height: 16),
              if (boxState.loading) const Expanded(child: FancyLoader()),
              if (!boxState.loading && boxState.boxCount != null && boxState.boxCount! > 0 && boxState.errorMessage == null) ...[
                // Layout Toggle Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.toggleLayout,
                      icon: Icon(
                        boxState.layoutType == LayoutType.grid ? Icons.grid_view : Icons.view_agenda,
                      ),
                      label: Text(
                        boxState.layoutType == LayoutType.grid ? 'Switch to C-Shape' : 'Switch to Grid',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Layout Title
                Text(
                  boxState.layoutType == LayoutType.grid ? 'Grid Layout' : 'C-Shape Layout (Bonus)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Show only one layout based on layoutType
                Expanded(
                  child: boxState.layoutType == LayoutType.grid ? BoxGrid() : CShapeGrid(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
