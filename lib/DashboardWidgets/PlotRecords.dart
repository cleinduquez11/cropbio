import 'package:cropbio/Models/Plot_data_source.dart';
import 'package:cropbio/Models/plot_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PlotRecords extends StatefulWidget {
  final List<Map<String, dynamic>> records;
  final bool loading;

  const PlotRecords({super.key, required this.records, this.loading = true});

  @override
  State<PlotRecords> createState() => _PlotRecordsState();
}

class _PlotRecordsState extends State<PlotRecords> {

  late PlotDataSource _dataSource;
  final DataGridController _controller = DataGridController();
  final TextEditingController _searchController = TextEditingController();
  List<PlotData> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant PlotRecords oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.records != widget.records) {
      _loadData();
    }
  }

  void _loadData() {
    _data = widget.records.map((e) => PlotData.fromMongo(e)).toList();
    _dataSource = PlotDataSource(_data);
  }

    void _search(String value) {
    final filtered = _data
        .where((element) =>
            element.code.toLowerCase().contains(value.toLowerCase()) ||
            element.field.toLowerCase().contains(value.toLowerCase()) ||
            element.plot.toLowerCase().contains(value.toLowerCase()))
        .toList();

    setState(() {
      _dataSource = PlotDataSource(filtered);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                        Row(
              children: [
                Text(
                  "Plot Records",
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
              child: SfDataGrid(
                source: _dataSource,
                controller: _controller,

                allowSorting: true,
                allowFiltering: true,
                allowMultiColumnSorting: true,
                selectionMode: SelectionMode.single,

                showVerticalScrollbar: true,
                showHorizontalScrollbar: true,

                columnWidthMode: ColumnWidthMode.fill,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,

                columns: [

                  GridColumn(
                      columnName: '#',
                      label: _header('#')
                  ),

                  GridColumn(
                      columnName: 'Code',
                      label: _header('Code')
                  ),

                  GridColumn(
                      columnName: 'Field',
                      label: _header('Field')
                  ),

                  GridColumn(
                      columnName: 'Plot',
                      label: _header('Plot')
                  ),

                  GridColumn(
                      columnName: 'Latitude',
                      label: _header('Latitude')
                  ),

                  GridColumn(
                      columnName: 'Longitude',
                      label: _header('Longitude')
                  ),

                  GridColumn(
                      columnName: 'Height',
                      label: _header('Plant Height')
                  ),
                ],
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