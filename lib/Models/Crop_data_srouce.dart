import 'package:cropbio/Models/crop_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CropDataSource extends DataGridSource {
  final List<CropData> _data;

  CropDataSource(this._data);

  @override
  List<DataGridRow> get rows => _data.map((e) {
        return DataGridRow(cells: [
          DataGridCell(columnName: 'Code', value: e.code),
          DataGridCell(columnName: 'Crop', value: e.cropType),
          DataGridCell(columnName: 'FreshWeight', value: e.freshWeight),
          DataGridCell(columnName: 'DryWeight', value: e.dryWeight),
          DataGridCell(columnName: 'SPAD', value: e.spad),
          DataGridCell(columnName: 'Temp', value: e.temperature),
          DataGridCell(columnName: 'Height', value: e.plantHeight),
          DataGridCell(columnName: 'Actions', value: e),
        ]);
      }).toList(growable: false);

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: Colors.white,
      cells: row.getCells().map((cell) {
        if (cell.columnName == 'Actions') {
          final CropData data = cell.value;

          return Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min, // important optimization
              children: [
                IconButton(
                  splashRadius: 18,
                  icon: const Icon(Icons.show_chart,
                      size: 18, color: Color(0xFF3F6B2A)),
                  onPressed: () => debugPrint("View Graph ${data.code}"),
                ),
                IconButton(
                  splashRadius: 18,
                  icon: const Icon(Icons.analytics,
                      size: 18, color: Color(0xFFC6A432)),
                  onPressed: () => debugPrint("Analyze ${data.code}"),
                ),
              ],
            ),
          );
        }

        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            cell.value?.toString() ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(growable: false),
    );
  }
}