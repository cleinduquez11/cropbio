import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserDataSource extends DataGridSource {

  List<DataGridRow> _rows = [];

  UserDataSource(List<Map<String, dynamic>> users) {
    int index = 1;

    _rows = users.map<DataGridRow>((user) {

      return DataGridRow(cells: [

        DataGridCell<int>(
          columnName: '#',
          value: index++,
        ),

        DataGridCell<String>(
          columnName: '_id',
          value: user["_id"] ?? "",
        ),

        DataGridCell<String>(
          columnName: 'fullName',
          value: user["fullName"] ?? "",
        ),

        DataGridCell<String>(
          columnName: 'email',
          value: user["email"] ?? "",
        ),

        DataGridCell<String>(
          columnName: 'role',
          value: user["role"] ?? "",
        ),

        DataGridCell<bool>(
          columnName: 'isVerified',
          value: user["isVerified"] ?? false,
        ),

      ]);

    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {

    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {

        if (cell.columnName == "isVerified") {

          final bool verified = cell.value == true;

          return Center(
            child: Icon(
              verified
                  ? Icons.check_circle
                  : Icons.cancel,
              color: verified
                  ? Colors.green
                  : Colors.red,
            ),
          );
        }

        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: Text(cell.value.toString(), style: const TextStyle(color: Colors.white),),
        );

      }).toList(),
    );
  }
}