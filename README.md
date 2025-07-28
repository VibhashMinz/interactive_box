# Interactive Box Generator

A Flutter web/mobile application that generates interactive square boxes based on user input, featuring dynamic layouts, color transitions, and responsive design.

## 🚀 Features

### Core Functionality
- **Input Validation**: Accepts numbers between 5-25 with real-time validation
- **Dynamic Box Generation**: Creates N square boxes (50x50px) with red background
- **Interactive Color Changes**: Click boxes to change from red to green
- **Click Order Tracking**: Maintains the sequence of box interactions
- **Auto-Revert Animation**: When all boxes are green, reverts them to red in reverse order (1 per second)
- **Layout Switching**: Toggle between Grid and C-Shape layouts
- **Responsive Design**: Adapts to different screen sizes

### User Experience Enhancements
- **Debounced Input**: 1000ms delay with loading indicator to prevent rapid UI updates
- **Custom Loader**: Animated progress indicator with gradient colors
- **Clear Input**: One-click input clearing with UI reset
- **Keyboard Dismissal**: Tap outside input field to dismiss keyboard
- **Error Handling**: Clear validation messages for invalid inputs

### Bonus Features
- **C-Shape Layout**: Dynamic arrangement of boxes in a 'C' pattern
- **Responsive C-Shape**: Automatically adjusts box size and spacing for small screens
- **Layout Persistence**: Both layouts maintain full interaction functionality

## 📱 Screenshots

### Grid Layout
- Standard grid arrangement of boxes
- Responsive to screen size
- Full interaction capabilities

### C-Shape Layout
- Dynamic 'C' pattern formation
- Responsive sizing for mobile devices
- Identical interaction behavior to grid

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   └── utils/
│       └── validator_mixin.dart
├── features/
│   └── box_interaction/
│       ├── application/
│       │   ├── box_controller.dart
│       │   └── box_state.dart
│       └── presentation/
│           ├── pages/
│           │   └── home_page.dart
│           └── widgets/
│               ├── box_grid.dart
│               ├── box_tile.dart
│               ├── c_shape_grid.dart
│               ├── fancy_loader.dart
│               └── input_field.dart
└── main.dart
```

### State Management
- **Riverpod**: Used for state management with `StateNotifierProvider`
- **BoxController**: Manages application state and business logic
- **BoxState**: Immutable state class with all application data

### Key Components

#### BoxController
- Handles input validation and debouncing
- Manages box generation and color states
- Controls layout switching
- Implements revert animation logic

#### BoxState
```dart
class BoxState {
  final int? boxCount;
  final List<Color> boxColors;
  final List<int> clickedOrder;
  final String? errorMessage;
  final bool loading;
  final bool isReverting;
  final LayoutType layoutType;
}
```

#### Layout Types
- **Grid**: Standard responsive grid layout
- **C-Shape**: Dynamic 'C' pattern with responsive sizing

## 🛠️ Setup & Installation

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Web browser (for web testing)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd interactive_box
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For web
   flutter run -d chrome
   
   # For mobile
   flutter run
   ```

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  state_notifier: ^0.7.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## 🎯 Usage Guide

### Basic Usage
1. **Enter a number** between 5-25 in the input field
2. **Wait for loading** indicator to complete
3. **Click boxes** to change their color from red to green
4. **Watch the revert** animation when all boxes are green
5. **Switch layouts** using the toggle button

### Advanced Features
- **Clear Input**: Click the 'X' button to reset everything
- **Layout Switching**: Toggle between Grid and C-Shape layouts
- **Responsive Design**: App adapts to different screen sizes
- **Keyboard Dismissal**: Tap outside input to hide keyboard

### Input Validation
- **Valid Range**: 5-25 (inclusive)
- **Error Messages**: Clear feedback for invalid inputs
- **Real-time Validation**: Instant feedback as you type

## 🧪 Testing

### Test Coverage
The application includes comprehensive testing:

- **Unit Tests**: Business logic testing (`test/unit/`)
- **Widget Tests**: UI component testing (`test/widget/`)
- **Integration Tests**: End-to-end flow testing (`test/integration/`)

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/box_controller_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure
```
test/
├── unit/
│   └── box_controller_test.dart
├── widget/
│   ├── input_field_test.dart
│   └── box_tile_test.dart
└── integration/
    └── app_integration_test.dart
```

## 🔧 Technical Details

### State Management Flow
1. **User Input** → `BoxController.updateBoxCount()`
2. **Debounce Timer** → 1000ms delay with loading state
3. **Validation** → Check range and format
4. **State Update** → Generate boxes or show error
5. **UI Update** → Rebuild widgets with new state

### Animation System
- **Color Transitions**: `AnimatedContainer` for smooth color changes
- **Revert Animation**: Timer-based sequential color reversion
- **Loader Animation**: Custom gradient rotation and pulsing

### Responsive Design
- **Grid Layout**: Uses `GridView.builder` with automatic sizing
- **C-Shape Layout**: Dynamic box sizing based on screen width
- **Mobile Optimization**: Reduced box sizes and spacing for small screens

## 🚀 Performance Optimizations

### Debouncing
- Prevents excessive UI updates during rapid typing
- 1000ms delay with visual feedback
- Cancels previous timers on new input

### Memory Management
- Proper disposal of timers and controllers
- Efficient state updates with immutable state
- Minimal widget rebuilds

### Responsive Layouts
- Dynamic sizing calculations
- Screen size detection
- Adaptive spacing and box sizes

## 🐛 Troubleshooting

### Common Issues

**Input not working**
- Check if number is between 5-25
- Ensure input field is focused
- Try clearing and re-entering

**Boxes not changing color**
- Verify you're clicking on the box area
- Check if revert animation is running
- Try switching layouts

**Layout issues on mobile**
- App automatically adjusts for small screens
- C-Shape layout reduces box size automatically
- Try rotating device for better layout

### Debug Mode
```bash
flutter run --debug
```

## 📈 Future Enhancements

### Potential Improvements
- **Custom Themes**: Dark/light mode support
- **Animation Settings**: Configurable revert speed
- **Layout Presets**: More arrangement options
- **Export Features**: Save layouts as images
- **Multi-language**: Internationalization support

### Performance Optimizations
- **Lazy Loading**: For large numbers of boxes
- **Memory Pooling**: Reuse box widgets
- **GPU Acceleration**: Hardware-accelerated animations

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable names
- Add comments for complex logic
- Maintain test coverage

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for excellent state management
- Flutter community for best practices and examples

---

**Built with ❤️ using Flutter**
