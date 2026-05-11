import 'package:cropbio/NavigationBar.dart';
import 'package:cropbio/Pherips/LayoutWrapper.dart';

import 'package:cropbio/Pherips/TitleBar.dart';
import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [

            const ResponsiveTitleBar(
              title: "Crop Biodiversity",
            ),

            const ResponsiveNavBar(),

            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}