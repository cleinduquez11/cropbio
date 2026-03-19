import 'package:cropbio/Models/crop_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CropDataSource extends DataGridSource {
  final List<CropData> _data;

  CropDataSource(this._data);

  @override
 List<DataGridRow> get rows => _data
      .asMap()
      .entries
      .map((entry) {
        final int index = entry.key;
        final CropData e = entry.value;

        return DataGridRow(cells: [
          DataGridCell<int>(columnName: '#', value: index + 1), // ✅ Line number
          DataGridCell<String>(columnName: 'Code', value: e.code),
          DataGridCell<String>(columnName: 'Crop', value: e.cropType),
          DataGridCell<double>(columnName: 'FreshWeight', value: e.freshWeight),
          DataGridCell<double>(columnName: 'DryWeight', value: e.dryWeight),
          DataGridCell<double>(columnName: 'SPAD', value: e.spad),
          DataGridCell<double>(columnName: 'Temp', value: e.plotData.soilTemperature),
          DataGridCell<double>(columnName: 'Height', value: e.plotData.plantHeight),
          // DataGridCell<CropData>(columnName: 'Actions', value: e),
        ]);
      })
      .toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: Colors.black,
      cells: row.getCells().map((cell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            cell.value.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }

}