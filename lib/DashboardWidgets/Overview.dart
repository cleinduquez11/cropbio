import 'package:cropbio/Models/Crop_data_source.dart';
import 'package:cropbio/Models/crop_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OverviewTable extends StatefulWidget {
  final List<Map<String, dynamic>> records;
  final bool loading;

  const OverviewTable({super.key, required this.records, this.loading = true});

  @override
  State<OverviewTable> createState() => _OverviewTableState();
}

class _OverviewTableState extends State<OverviewTable> {
  late CropDataSource _dataSource;
  final DataGridController _controller = DataGridController();
  final TextEditingController _searchController = TextEditingController();

  List<CropData> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData(); // initialize with passed records
  }

  @override
  void didUpdateWidget(covariant OverviewTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.records != widget.records) {
      _loadData();
    }
  }

  void _loadData() {
    // Convert _records to CropData
    _data = widget.records.map((record) {
      return CropData(
        code: record['CODE'] ?? '',
        cropType: record['CROP_TYPE'] ?? '',
        freshWeight: (record['FRESH_WEIGHT'] ?? 0).toDouble(),
        dryWeight: (record['DRY_WEIGHT'] ?? 0).toDouble(),
        avgLeafArea: (record['Average_Leaf_Area'] ?? 0).toDouble(),
        correctedLeafArea:
            (record['Corrected_Leaf_Area_(CF=0.75)'] ?? 0).toDouble(),
        spad: (record['SPAD__values'] ?? 0).toDouble(),
        temperature: (record['Temperature'] ?? 0).toDouble(),
        plantHeight: (record['Plant_Height'] ?? 0).toDouble(),
      );
    }).toList();

    _dataSource = CropDataSource(_data);
  }

  void _search(String value) {
    final filtered = _data
        .where((element) =>
            element.code.toLowerCase().contains(value.toLowerCase()) ||
            element.cropType.toLowerCase().contains(value.toLowerCase()))
        .toList();

    setState(() {
      _dataSource = CropDataSource(filtered);
    });
  }

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
          children: [
            Row(
              children: [
                Text(
                  "Crop Records",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _search,
                    decoration: InputDecoration(
                      hintText: "Search code or crop...",
                      hintStyle: GoogleFonts.nunito(
                        color: Colors.white,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(scrollbars: false),
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(
                        Color(0xFFFF7A8F3D)), // scrollbar color
                    thickness: WidgetStateProperty.all(8), // width
                    radius: const Radius.circular(4),
                  ),
                  child: SfDataGrid(
                    source: _dataSource,
                    controller: _controller,
                    editingGestureType: EditingGestureType.tap,
                    allowSorting: true,
                    allowFiltering: true,
                    allowMultiColumnSorting: true,
                    showVerticalScrollbar: true,
                     showHorizontalScrollbar: true, // ✅ horizontal scrollbar enable
                    allowEditing: true,
                    selectionMode: SelectionMode.single,
                    navigationMode: GridNavigationMode.cell,
                    isScrollbarAlwaysShown: true,
                    columnWidthMode: ColumnWidthMode.auto,
                    columnWidthCalculationRange:
                        ColumnWidthCalculationRange.allRows,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    columns: [
                      GridColumn(columnName: '#', label: _header('#')),
                      GridColumn(columnName: 'Code', label: _header('Code')),
                      GridColumn(columnName: 'Crop', label: _header('Crop')),
                      GridColumn(
                          columnName: 'FreshWeight',
                          label: _header('Fresh W.')),
                      GridColumn(
                          columnName: 'DryWeight', label: _header('Dry W.')),
                      GridColumn(columnName: 'SPAD', label: _header('SPAD')),
                      GridColumn(columnName: 'Temp', label: _header('Temp')),
                      GridColumn(
                          columnName: 'Height', label: _header('Height')),
                      GridColumn(
                          allowSorting: false,
                          allowFiltering: false,
                          columnName: 'Actions',
                          label: _header('Actions')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF1E2E1E),
      child: Text(
        title,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
