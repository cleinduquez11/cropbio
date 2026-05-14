import 'package:cropbio/UpdatesPage/Widgets/UpdatesPost.dart';
import 'package:flutter/material.dart';

class UpdatesGrid extends StatelessWidget {
  final String query;

  const UpdatesGrid({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final posts = [
      UpdatesPost(
        title: "Drone Mapping Expands Field Coverage",
        excerpt:
            "Recent UAV deployments have increased orthomosaic coverage across experimental fields.",
        category: "Technology",
        date: "May 2026",
      ),
      UpdatesPost(
        title: "New Crop Varieties Documented",
        excerpt:
            "Over 50 new accessions have been catalogued in the biodiversity system.",
        category: "Research",
        date: "April 2026",
      ),
      UpdatesPost(
        title: "Climate Resilience Study Ongoing",
        excerpt:
            "Field trials are underway to assess drought and flood resistance traits.",
        category: "Field Work",
        date: "March 2026",
      ),
    ];

    final filtered = posts.where((p) {
      return p.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        int cols = constraints.maxWidth > 1200
            ? 4
            : constraints.maxWidth > 800
                ? 3
                : constraints.maxWidth > 500
                    ? 2
                    : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (_, i) {
            return UpdatesCard(post: filtered[i]);
          },
        );
      },
    );
  }
}
