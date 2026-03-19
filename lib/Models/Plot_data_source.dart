import 'package:cropbio/Models/plot_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PlotDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];

  PlotDataSource(List<PlotData> data) {
    _rows = data.asMap().entries.map<DataGridRow>((entry) {
      final index = entry.key + 1;
      final plot = entry.value;

      return DataGridRow(cells: [
        DataGridCell<int>(columnName: '#', value: index),
        DataGridCell<String>(columnName: 'Code', value: plot.code),
        DataGridCell<String>(columnName: 'Field', value: plot.field),
        DataGridCell<String>(columnName: 'Plot', value: plot.plot),
        DataGridCell<double>(columnName: 'Latitude', value: plot.latitude),
        DataGridCell<double>(columnName: 'Longitude', value: plot.longitude),
        DataGridCell<double>(columnName: 'Height', value: plot.plantHeight),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

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