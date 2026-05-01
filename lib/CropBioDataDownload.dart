import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:cropbio/Pherips/LayoutWrapper.dart';
import 'package:cropbio/Pherips/Navbar.dart';
import 'package:cropbio/Pherips/TitleBar.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return LayoutWrapper(
      child: Scaffold(
        body: Column(
          children: [
            ResponsiveTitleBar(title: "CropBio Data Access"),
            ResponsiveNavBar(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    /// ================= HERO =================
                    _DataHero(),

                    /// ================= DASHBOARD SECTION =================
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: layout.verticalPadding * 2,
                      ),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      child: Center(
                        child: SizedBox(
                          width: layout.contentWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [

                              /// SECTION TITLE
                              Text(
                                "Select Data Type",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 10),

                              Text(
                                "Choose the type of dataset you want to explore and download.",
                                style: TextStyle(
                                  color: Colors.black54,
                                  height: 1.6,
                                ),
                              ),

                              SizedBox(height: 40),

                              _DataTypeGrid(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// ================= INFO STRIP =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 80,
                        horizontal: 20,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2F4F2F),
                            Color(0xFF1E2E1E),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 700,
                          child: Column(
                            children: [
                              Text(
                                "Data Transparency & Research Access",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "All datasets are curated from validated field research, "
                                "remote sensing analysis, and institutional studies. "
                                "Downloadable formats are optimized for GIS, analytics, "
                                "and academic use.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  height: 1.6,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
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

class _DataHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 50, // 👈 reduced
        horizontal: 20,
      ),
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
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [

              /// 🌱 SMALLER LOGO
              SizedBox(
                height: 70, // 👈 reduced from 130
                child: SvgPicture.asset(
                  "lib/Assets/Cropbio_Logo_Dark.svg",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                "Crop Biodiversity Data Portal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, // 👈 reduced
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              /// SHORT DESCRIPTION
              const Text(
                "Access research datasets including tabular records, GIS layers, and drone imagery.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 20),

              /// MINI CTA
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Select a dataset type below",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataTypeGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _DataType(
        title: "Tabular Data",
        description: "Annual crop summaries, statistics, and reports.",
        icon: Icons.table_chart,
        type: "tabular",
      ),
      _DataType(
        title: "Shapefiles",
        description: "Field boundaries, plots, and spatial vectors.",
        icon: Icons.map,
        type: "shapefile",
      ),
      _DataType(
        title: "Raster Data",
        description: "Satellite layers, NDVI, and environmental grids.",
        icon: Icons.layers,
        type: "raster",
      ),
      _DataType(
        title: "Orthomosaic",
        description: "Drone-stitched high-resolution imagery.",
        icon: Icons.image,
        type: "mosaic",
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;

        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 4; // 💻 large screens
        } else if (constraints.maxWidth >= 800) {
          crossAxisCount = 4; // 📱 tablet
        }
        else if (constraints.maxWidth >= 500) {
          crossAxisCount = 2; // 📱 tablet
        }
         else {
          crossAxisCount = 1; // 📱 mobile
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 1, // tweak height/width balance
          ),
          itemBuilder: (context, index) {
            return _DataTypeCard(item: items[index]);
          },
        );
      },
    );
  }
}
class _DataType {
  final String title;
  final String description;
  final IconData icon;
  final String type;

  _DataType({
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
  });
}


class _DataTypeCard extends StatefulWidget {
  final _DataType item;

  const _DataTypeCard({required this.item});

  @override
  State<_DataTypeCard> createState() => _DataTypeCardState();
}

class _DataTypeCardState extends State<_DataTypeCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),

      child: GestureDetector(
        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DataListPage(
                type: widget.item.type,
              ),
            ),
          );
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: _hover
              ? (Matrix4.identity()..translate(0, -8))
              : Matrix4.identity(),

          width: 260,
          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black.withOpacity(0.08),
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Icon(
                widget.item.icon,
                size: 40,
                color: const Color(0xFF3F6B2A),
              ),

              const SizedBox(height: 20),

              Text(
                widget.item.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                widget.item.description,
                style: const TextStyle(
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 20),

              const Row(
                children: [
                  Spacer(),
                  Icon(Icons.arrow_forward),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DataListPage extends StatelessWidget {
  final String type;

  const DataListPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {

    final mockData = [
      "Dataset A",
      "Dataset B",
      "Dataset C",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Available $type Data"),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: mockData.length,
        itemBuilder: (context, index) {

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              title: Text(mockData[index]),
              subtitle: Text("Description of dataset"),

              trailing: ElevatedButton(
                onPressed: () {
                  /// TODO: download logic
                },
                child: const Text("Download"),
              ),
            ),
          );
        },
      ),
    );
  }
}