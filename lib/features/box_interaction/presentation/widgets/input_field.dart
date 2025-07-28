import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String? errorText;
  final Function(String) onChanged;
  final VoidCallback? onClear;

  const InputField({
    super.key,
    required this.errorText,
    required this.onChanged,
    this.onClear,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged('');
    if (widget.onClear != null) widget.onClear!();
    setState(() {});
  }

  void _handleTextChange(String value) {
    widget.onChanged(value);

    // If the input is empty and we have an onClear callback, call it
    if (value.isEmpty && widget.onClear != null) {
      widget.onClear!();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Enter a number (5-25)",
            border: const OutlineInputBorder(),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _handleClear,
                  )
                : null,
          ),
          onChanged: _handleTextChange,
        ),
        if (widget.errorText != null && _controller.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
