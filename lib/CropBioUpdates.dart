

import 'package:cropbio/Pherips/LayoutWrapper.dart';
import 'package:cropbio/Pherips/Navbar.dart';
import 'package:cropbio/Pherips/TitleBar.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


class _NewsPost {
  final String title;
  final String excerpt;
  final String category;
  final String date;

  _NewsPost({
    required this.title,
    required this.excerpt,
    required this.category,
    required this.date,
  });
}


class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return LayoutWrapper(
      child: Scaffold(
        body: Column(
          children: [
            ResponsiveTitleBar(title: "News & Updates"),
            ResponsiveNavBar(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    /// HERO
                    const _NewsHero(),

                    /// SEARCH BAR
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: layout.verticalPadding,
                      ),
                      color: const Color(0xFFF4F6F1),
                      child: Center(
                        child: SizedBox(
                          width: layout.contentWidth,
                          child: _SearchBar(
                            onChanged: (val) {
                              setState(() => query = val);
                            },
                          ),
                        ),
                      ),
                    ),

                    /// POSTS GRID
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: layout.verticalPadding * 2,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: layout.contentWidth,
                          child: _NewsGrid(query: query),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _NewsHero extends StatelessWidget {
  const _NewsHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2F4F2F),
            Color(0xFF1E2E1E),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children:  [

              SizedBox(
                height: 70, // 👈 reduced from 130
                child: SvgPicture.asset(
                  "lib/Assets/Cropbio_Logo_Dark.svg",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "News & Research Updates",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Stay informed with the latest developments in crop biodiversity, "
                "research initiatives, and institutional collaborations.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Search news, updates, or keywords...",
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _NewsGrid extends StatelessWidget {
  final String query;

  const _NewsGrid({required this.query});

  @override
  Widget build(BuildContext context) {

    final posts = [
      _NewsPost(
        title: "Drone Mapping Expands Field Coverage",
        excerpt:
            "Recent UAV deployments have increased orthomosaic coverage across experimental fields.",
        category: "Technology",
        date: "May 2026",
      ),
      _NewsPost(
        title: "New Crop Varieties Documented",
        excerpt:
            "Over 50 new accessions have been catalogued in the biodiversity system.",
        category: "Research",
        date: "April 2026",
      ),
      _NewsPost(
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
                : constraints.maxWidth > 500? 2
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
            return _NewsCard(post: filtered[i]);
          },
        );
      },
    );
  }
}

class _NewsCard extends StatefulWidget {
  final _NewsPost post;

  const _NewsCard({required this.post});

  @override
  State<_NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<_NewsCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: hover
            ? (Matrix4.identity()..translate(0, -8))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black.withOpacity(0.08),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// CATEGORY TAG
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF3F6B2A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.post.category,
                style: const TextStyle(
                  color: Color(0xFF3F6B2A),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// TITLE
            Text(
              widget.post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// EXCERPT
            Text(
              widget.post.excerpt,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.6,
              ),
            ),

            const Spacer(),

            /// FOOTER
            Row(
              children: [
                Text(
                  widget.post.date,
                  style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward),
              ],
            )
          ],
        ),
      ),
    );
  }
}