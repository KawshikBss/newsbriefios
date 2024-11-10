import 'package:flutter/material.dart';

class DialogLayout extends StatelessWidget {
  final Widget title;
  final Widget child;
  const DialogLayout(
      {super.key, this.title = const Text('Dialog'), required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.chevron_left)),
          centerTitle: true,
          title: title,
        ),
        body: child);
  }
}
