import 'package:flutter/material.dart';

class ProfileTextField extends StatefulWidget {
  final String label;
  final String value;
  final bool disabled;
  final Function(String)? onTextChanged;

  const ProfileTextField({
    super.key,
    this.label = 'Label',
    this.value = '',
    this.disabled = false,
    this.onTextChanged,
  });

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
    _controller.value = TextEditingValue(text: widget.value);
  }

  @override
  void didUpdateWidget(ProfileTextField oldWidget) {
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
      // readOnly: true, // Set to true if the text field is non-editable
      enabled: !widget.disabled,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        filled: true,
        fillColor:
            widget.disabled ? const Color(0xFFe9ecef) : Colors.transparent,
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
