import 'package:cropbio/Models/crop_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class CropDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];

  CropDataSource(List<CropData> data) {
    _rows = data.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'Field', value: e.field),
        DataGridCell(columnName: 'Plot', value: e.plot),
        DataGridCell(columnName: 'Sample', value: e.plantSample),
        DataGridCell(columnName: 'Code', value: e.code),
        DataGridCell(columnName: 'Crop', value: e.cropType),
        DataGridCell(columnName: 'FreshWeight', value: e.freshWeight),
        DataGridCell(columnName: 'DryWeight', value: e.dryWeight),
        DataGridCell(columnName: 'SPAD', value: e.spad),
        DataGridCell(columnName: 'Temp', value: e.temperature),
        DataGridCell(columnName: 'Height', value: e.plantHeight),
        DataGridCell(columnName: 'Actions', value: e),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: Colors.white,
      cells: row.getCells().map((cell) {
        if (cell.columnName == 'Actions') {
          final CropData data = cell.value;
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.show_chart,
                    color: Color(0xFF3F6B2A)),
                onPressed: () {
                  debugPrint("View Graph ${data.code}");
                },
              ),
              IconButton(
                icon: const Icon(Icons.analytics,
                    color: Color(0xFFC6A432)),
                onPressed: () {
                  debugPrint("Analyze ${data.code}");
                },
              ),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}