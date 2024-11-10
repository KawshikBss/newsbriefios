import 'package:flutter/material.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/custom_drawer_menu.dart';

class MenuLayout extends StatelessWidget {
  final Widget child;
  const MenuLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Builder(builder: (context) {
          return Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu)),
          );
        }),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 32,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(child: child)));
      }),
      drawer: const CustomDrawerMenu(),
    );
  }
}
