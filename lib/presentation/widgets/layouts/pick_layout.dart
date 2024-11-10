import 'package:flutter/material.dart';

class PickLayout extends StatelessWidget {
  final Widget child;
  const PickLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            child
          ],
        ),
      ),
    );
  }
}
