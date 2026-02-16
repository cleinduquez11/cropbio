import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LayoutWrapper extends StatelessWidget {
  final Widget child;
  const LayoutWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutProvider =
            Provider.of<LayoutProvider>(context, listen: false);

       WidgetsBinding.instance.addPostFrameCallback((_) {
          layoutProvider.update(constraints, context);
        });

        return child;
      },
    );
  }
}
