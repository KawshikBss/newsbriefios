import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subTitle;
  final bool borderBottom;
  const DrawerMenuItem(
      {super.key,
      this.icon,
      this.title,
      this.subTitle,
      this.borderBottom = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          border: Border(
              bottom: borderBottom
                  ? const BorderSide(width: 1, color: Colors.black)
                  : BorderSide.none)),
      child: Row(
        children: [
          Visibility(
              visible: icon != null,
              child: Icon(
                icon,
                color: Colors.black,
              )),
          SizedBox(
            width: icon != null ? 16 : 0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Title',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Visibility(
                  visible: subTitle != null,
                  child: Text(
                    subTitle ?? '',
                    style: Theme.of(context).textTheme.displayMedium,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
