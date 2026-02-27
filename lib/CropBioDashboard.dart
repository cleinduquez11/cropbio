import 'dart:io';
import 'dart:typed_data';

import 'package:cropbio/API/UploadCsv.dart';
import 'package:cropbio/API/fetchAll.dart';
import 'package:cropbio/Models/Crop_data_srouce.dart';
import 'package:cropbio/Models/crop_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
class Cropbiodashboard extends StatefulWidget {
  const Cropbiodashboard({super.key});

  @override
  State<Cropbiodashboard> createState() => _CropbiodashboardState();
}

class _CropbiodashboardState extends State<Cropbiodashboard> {
  int _selectedIndex = 0;
  
  PlatformFile? _selectedFile;

  Future<void> _pickCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true, // Important! get bytes for web
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedFile = result.files.single;
      });

   await uploadCsvWeb(result.files.single.bytes!, result.files.single.name, context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No file selected")));
    }
  }


  List<Map<String, dynamic>> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadCropSamples(); // call function on init
  }

  /// Call the API service
  Future<void> loadCropSamples() async {
    setState(() => _loading = true);

    final apiUrl = 'http://192.168.10.106:5000/fetch_all'; // your Flask API
    final data = await fetchCropSamples(apiUrl: apiUrl);

    setState(() {
      _records = data;
      _loading = false;
    });
  }


  final List<String> _menuItems = [
    "Overview",
    "Plot Records",
    "Upload Data",
    "Reports",
    "Settings"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF4F6F1),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: _buildMainContent(),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SIDEBAR =================

  Widget _buildSidebar() {
    return Container(
      width: 300,
      color: const Color(0xFF1E2E1E),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: "logo",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: 100,
                width: 260,
                child: SvgPicture.asset(
                  "lib/Assets/Cropbio_Logo_par.svg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          ...List.generate(_menuItems.length, (index) {
            return _sidebarItem(index);
          }),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "© 2026 CropBio",
              style: TextStyle(color: Colors.white38),
            ),
          )
        ],
      ),
    );
  }

  Widget _sidebarItem(int index) {
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3F6B2A) : Colors.transparent,
        ),
        child: Text(
          _menuItems[index],
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ================= MAIN AREA =================

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 1:
        return _buildCropRecords();
      case 2:
        return _buildUploadSection();
      case 3:
        return _buildUploadSection();
      case 4:
        return _buildUploadSection();
      default:
        return _buildOverview();
    }
  }

  // ================= OVERVIEW =================

  Widget _buildOverview() {
   return OverviewTable(records: _records, loading: _loading);
  }
  // ================= CROP RECORDS =================

  Widget _buildCropRecords() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Plot Records",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
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
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.05),
                )
              ],
            ),
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Crop")),
                DataColumn(label: Text("Accession ID")),
                DataColumn(label: Text("Region")),
                DataColumn(label: Text("Status")),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text("Rice")),
                  DataCell(Text("CRB-001")),
                  DataCell(Text("Ilocos Norte")),
                  DataCell(Text("Conserved")),
                ]),
                DataRow(cells: [
                  DataCell(Text("Corn")),
                  DataCell(Text("CRB-002")),
                  DataCell(Text("Region II")),
                  DataCell(Text("Active Study")),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= UPLOAD SECTION =================

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Crop Data",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC6A432),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          ),
          onPressed: _pickCsvFile,
          icon: const Icon(Icons.upload_file, color: Colors.black),
          label: const Text(
            "Upload CSV / Excel",
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
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
      icon: Icon(
        icon,
        size: 18,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

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
        correctedLeafArea: (record['Corrected_Leaf_Area_(CF=0.75)'] ?? 0).toDouble(),
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
                const Text(
                  "Crop Biodiversity Records",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _search,
                    decoration: InputDecoration(
                      hintText: "Search code or crop...",
                      hintStyle: TextStyle(color: Colors.white),
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
                child: SfDataGrid(
                  source: _dataSource,
                  controller: _controller,
                  editingGestureType: EditingGestureType.tap,
                  allowSorting: true,
                  allowFiltering: true,
                  allowMultiColumnSorting: true,
                  showVerticalScrollbar: true,
                  allowEditing: true,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,
                  isScrollbarAlwaysShown: true,
                  columnWidthMode: ColumnWidthMode.auto,
                  columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                  columns: [
                    GridColumn(columnName: 'Code', label: _header('Code')),
                    GridColumn(columnName: 'Crop', label: _header('Crop')),
                    GridColumn(columnName: 'FreshWeight', label: _header('Fresh W.')),
                    GridColumn(columnName: 'DryWeight', label: _header('Dry W.')),
                    GridColumn(columnName: 'SPAD', label: _header('SPAD')),
                    GridColumn(columnName: 'Temp', label: _header('Temp')),
                    GridColumn(columnName: 'Height', label: _header('Height')),
                    GridColumn(
                        allowSorting: false,
                        allowFiltering: false,
                        columnName: 'Actions',
                        label: _header('Actions')),
                  ],
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
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}