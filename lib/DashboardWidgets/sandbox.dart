import 'package:flutter/material.dart';

class UploadSection extends StatefulWidget {
  final VoidCallback onUploadCropData;
  final VoidCallback onUploadPlotData;
  // final VoidCallback onPostCsv;

  const UploadSection({
    super.key,
    required this.onUploadCropData,
    required this.onUploadPlotData,
    // required this.onPostCsv,
  });

  @override
  State<UploadSection> createState() => _UploadSectionState();
}

class _UploadSectionState extends State<UploadSection> {
  List<List<String>> csvData = []; // Stores CSV rows for viewer

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Upload Buttons Row ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Text(
                  "Upload Crop Data",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC6A432),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 18),
                  ),
                  onPressed: () async {
                    await widget.onUploadCropData;
                    setState(() {
                      // Example: populate csvData after upload
                      // Replace with your actual CSV reading logic
                      csvData = [
                        ["FIELD", "PLOT", "PLANT_SAMPLE"],
                        ["P1", "S1", "2"],
                        ["P2", "S2", "3"],
                      ];
                    });
                  },
                  icon: const Icon(Icons.upload_file, color: Colors.black),
                  label: const Text(
                    "Upload CSV / Excel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  "Upload Plot Data",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC6A432),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 18),
                  ),
                  onPressed: () async {
                    await widget.onUploadPlotData;
                    setState(() {
                      // Example CSV data after upload
                      csvData = [
                        ["LAT", "LON", "HEIGHT"],
                        ["14.65", "120.97", "2.17"],
                        ["14.66", "120.98", "2.20"],
                      ];
                    });
                  },
                  icon: const Icon(Icons.upload_file, color: Colors.black),
                  label: const Text(
                    "Upload CSV / Excel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 30),

        // --- CSV Viewer ---
        csvData.isEmpty
            ? const Text("No CSV uploaded yet")
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: csvData.first
                      .map((header) => DataColumn(
                            label: Text(
                              header,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                      .toList(),
                  rows: csvData
                      .sublist(1)
                      .map(
                        (row) => DataRow(
                          cells: row
                              .map((cell) => DataCell(Text(cell)))
                              .toList(),
                        ),
                      )
                      .toList(),
                ),
              ),

        const SizedBox(height: 20),

        // --- Post Button ---
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
          onPressed: (){},
          icon: const Icon(Icons.send, color: Colors.white),
          label: const Text(
            "Post CSV",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}