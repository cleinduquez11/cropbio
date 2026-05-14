import 'package:cropbio/AppShell.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:cropbio/Providers/UpdatesProvider.dart';
import 'package:cropbio/UpdatesPage/Sections/UpdatesGrid.dart';
import 'package:cropbio/UpdatesPage/Sections/UpdatesHero.dart';
import 'package:cropbio/UpdatesPage/Sections/UpdatesSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UpdatesPage extends StatelessWidget {
  const UpdatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.read<LayoutProvider>();

    return AppShell(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// HERO
          const SliverToBoxAdapter(
            child: UpdatesHero(),
          ),
      
          /// SEARCH
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: layout.verticalPadding,
                horizontal: 20,
              ),
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: layout.contentWidth,
                  ),
                  child: UpdatesSearchBar(
                    onChanged: context.read<UpdatesProvider>().updateQuery,
                  ),
                ),
              ),
            ),
          ),
      
          /// POSTS
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: layout.verticalPadding * 2,
              horizontal: 20,
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: layout.contentWidth,
                  ),
                  child: Selector<UpdatesProvider, String>(
                    selector: (_, provider) => provider.query,
                    builder: (_, query, __) {
                      return RepaintBoundary(
                        child: UpdatesGrid(
                          query: query,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




