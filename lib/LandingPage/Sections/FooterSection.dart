
import 'package:cropbio/LandingPage/Widgets/Footers.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {

    final layout = context.read<LayoutProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 60,
        horizontal: 20,
      ),

      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.contentWidth,
          ),

          child: layout.isMobile

              ? const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    FooterBrand(),

                    SizedBox(height: 40),

                    FooterLinks(),
                  ],
                )

              : const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    FooterBrand(),

                    FooterLinks(),
                  ],
                ),
        ),
      ),
    );
  }
}
