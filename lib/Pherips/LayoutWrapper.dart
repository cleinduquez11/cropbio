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



class ResponsiveContentWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveContentWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return Container(
      width: double.infinity,

      margin: EdgeInsets.symmetric(
        horizontal: layout.isMobile
            ? 16   // mobile side margin
            : layout.outerMargin,
      ),

      child: SizedBox(
        width: layout.contentWidth,
        child: child,
      ),
    );
  }
}