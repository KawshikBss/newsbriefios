import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String value;
  final bool secured;
  final Function(String)? onTextChanged;

  const AuthTextField({
    super.key,
    this.label = 'Label',
    this.value = '',
    this.secured = false,
    this.onTextChanged,
  });

  @override
  State<AuthTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<AuthTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
    _controller.value = TextEditingValue(text: widget.value);
  }

  @override
  void didUpdateWidget(AuthTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the controller's text when the widget's value changes
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      obscureText: widget.secured,
      obscuringCharacter: '*',
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFFdee2e6),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onChanged: widget.onTextChanged,
    );
  }
}
