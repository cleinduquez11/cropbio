import 'package:flutter/material.dart';

class PlotRecords extends StatefulWidget {
  final List<Map<String, dynamic>> records;
  final bool loading;
  const PlotRecords({super.key, required this.records, this.loading = true});

  @override
  State<PlotRecords> createState() => _PlotRecordsState();
}

class _PlotRecordsState extends State<PlotRecords> {
  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
        child: Container(
            width: 1500,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Plot Records",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    _actionButton("Add", Icons.add),
                    const SizedBox(width: 15),
                    _actionButton("Edit", Icons.edit),
                    const SizedBox(width: 15),
                    _actionButton("Delete", Icons.delete),
                    const SizedBox(width: 15),
                    _actionButton("Download", Icons.download),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    width: 550,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.05),
                        )
                      ],
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Crop")),
                        DataColumn(label: Text("Accession ID")),
                        DataColumn(label: Text("Region")),
                        DataColumn(label: Text("Status")),
                      ],
                      rows: const [
                        DataRow(cells: [
                          DataCell(Text("Rice")),
                          DataCell(Text("CRB-001")),
                          DataCell(Text("Ilocos Norte")),
                          DataCell(Text("Conserved")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("Corn")),
                          DataCell(Text("CRB-002")),
                          DataCell(Text("Region II")),
                          DataCell(Text("Active Study")),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget _actionButton(String label, IconData icon) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3F6B2A),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {},
      icon: Icon(
        icon,
        size: 18,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
