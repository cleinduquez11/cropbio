import 'package:flutter/material.dart';

class UserRecords extends StatelessWidget {
  final List<Map<String, dynamic>> records;
  final bool loading;

  const UserRecords({
    super.key,
    required this.records,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (records.isEmpty) {
      return const Center(
        child: Text("No user records found"),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "User Records",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Role")),
                DataColumn(label: Text("Verified")),
              ],
              rows: records.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Text(user["_id"].toString())),
                    DataCell(Text(user["fullName"] ?? "")),
                    DataCell(Text(user["email"] ?? "")),
                    DataCell(Text(user["role"] ?? "")),
                    DataCell(
                      Center(
                        child: Tooltip(
                          message: user["isVerified"] == true
                              ? "Verified"
                              : "Not Verified",
                          child: Icon(
                            user["isVerified"] == true
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: user["isVerified"] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
