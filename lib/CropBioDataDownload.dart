import 'package:cropbio/AppShell.dart';
import 'package:cropbio/DataPage/Sections/DataHero.dart';
import 'package:cropbio/DataPage/Sections/DataTypeGrid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = context.read<LayoutProvider>();

    return AppShell(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// ================= HERO =================
          SliverToBoxAdapter(
            child: DataHero(),
          ),
      
          /// ================= DASHBOARD SECTION =================
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: layout.verticalPadding * 2,
                horizontal: 20,
              ),
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: layout.contentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      DataTypeGrid(),
                    ],
                  ),
                ),
              ),
            ),
          ),
      
          /// ================= INFO STRIP =================
          SliverToBoxAdapter(
            child: Container(
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
                    child: Column(children: [
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
                    ])),
              ),
            ),
          )
        ],
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
