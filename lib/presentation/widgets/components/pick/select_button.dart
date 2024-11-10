import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  final bool isActive;
  final bool showSymbol;
  final String? label;
  final Function onPressed;
  const SelectButton(
      {super.key,
      this.isActive = false,
      this.label,
      required this.onPressed,
      this.showSymbol = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        onPressed();
      },
      icon: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: isActive ? Colors.black : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: showSymbol
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            Text(
              label != null
                  ? label!.length > 10
                      ? '${label!.substring(0, 10)}...'
                      : label!
                  : 'Label',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isActive ? const Color(0xFFD9D9D9) : Colors.black,
                  fontSize: 16),
            ),
            if (showSymbol)
              Text(
                isActive ? '-' : '+',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isActive ? const Color(0xFFD9D9D9) : Colors.black,
                    fontSize: 20),
              )
          ],
        ),
      ),
    );
  }
}
