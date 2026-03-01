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
          DataGridCell<double>(columnName: 'Temp', value: e.temperature),
          DataGridCell<double>(columnName: 'Height', value: e.plantHeight),
          DataGridCell<CropData>(columnName: 'Actions', value: e),
        ]);
      })
      .toList(growable: false);

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
  style: GoogleFonts.nunito(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  ),
)
        );
      }).toList(growable: false),
    );
  }
}