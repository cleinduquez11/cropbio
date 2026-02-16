import 'package:flutter/material.dart';



class ResponsiveNavMenu extends StatelessWidget {
  final bool isMobile;

  const ResponsiveNavMenu({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final items = const [
      'About CropBio',
      'News',
      'Multimedia',
      'Biodiversity',
      'Data',
      'Publications',
      'Contact'
    ];

    if (isMobile) {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.menu, color: Colors.white),
        onSelected: (value) {},
        itemBuilder: (context) =>
            items.map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
      );
    }

    return Center(
      child: Row(
        children: items
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      e,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
