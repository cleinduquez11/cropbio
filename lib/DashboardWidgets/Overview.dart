import 'package:cropbio/Models/Crop_data_source.dart';
import 'package:cropbio/Models/crop_model.dart';
import 'package:cropbio/Models/plot_model.dart';
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
        plotData: PlotData.fromMongo(record),
        capCover: record['Cap_Cover'] ?? "",
        chlA: (record['Chl_A'] ?? 0).toDouble(),
        chlB: (record['Chl_B'] ?? 0).toDouble(),
        caretenoid: (record['Caretenoid'] ?? 0).toDouble(),
        ldmc: (record['LDMC'] ?? 0).toDouble(),
        leafWaterConcentration:
            (record['Leaf_Water_Concentration'] ?? 0).toDouble(),
        equivalentWaterThickness:
            (record['Equivalent_Water_Thickness_(EWT)'] ?? 0).toDouble(),
        specificLeafArea:
            (record['Specific_Leaf_Area_(cm2/g)'] ?? 0).toDouble(),
        lai: (record['LAI'] ?? 0).toDouble(),
        difn: (record['DIFN'] ?? 0).toDouble(),
        mta: (record['MTA'] ?? 0).toDouble(),
        sem: (record['SEM'] ?? 0).toDouble(),
        smp: (record['SMP'] ?? 0).toDouble(),
        sel: (record['SEL'] ?? 0).toDouble(),
        chloropyllVal: (record['Chloropyll_Val'] ?? 0).toDouble(),
        field: record['FIELD'] ?? '',
        plot: record['PLOT'] ?? '',
        plantSample: record['PLANT_SAMPLE'] ?? 0,
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
        width: 2200,
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
                    showHorizontalScrollbar:
                        true, // ✅ horizontal scrollbar enable
                    allowEditing: true,
                    selectionMode: SelectionMode.single,
                    navigationMode: GridNavigationMode.cell,
                    isScrollbarAlwaysShown: true,
                    columnWidthMode: ColumnWidthMode.fill,
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
                      // GridColumn(
                      //     allowSorting: false,
                      //     allowFiltering: false,
                      //     columnName: 'Actions',
                      //     label: _header('Actions')),
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
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
