import 'package:cropbio/API/UploadCsv.dart';
import 'package:cropbio/API/FetchAll.dart';
import 'package:cropbio/API/UserAPi.dart';
import 'package:cropbio/Configs/config.dart';
import 'package:cropbio/DashboardWidgets/Overview.dart';
import 'package:cropbio/DashboardWidgets/PlotRecords.dart';
import 'package:cropbio/DashboardWidgets/UploadSection.dart';
import 'package:cropbio/DashboardWidgets/UserRecords.dart';
import 'package:cropbio/Widgets/CustomSnackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Cropbiodashboard extends StatefulWidget {
  const Cropbiodashboard({super.key});

  @override
  State<Cropbiodashboard> createState() => _CropbiodashboardState();
}

class _CropbiodashboardState extends State<Cropbiodashboard> {
  int _selectedIndex = 0;

  PlatformFile? _selectedFile;

  Future<void> _pickAndUploadCropData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true, // Important! get bytes for web
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedFile = result.files.single;
      });

      await uploadCropData(
          result.files.single.bytes!, result.files.single.name, "", "");
    } else {
      CustomSnackBar.show(
        context,
        message: "No file selected",
        backgroundColor: Colors.orange, // optional
        icon: Icons.warning, // optional
        bottomMargin: 40, // optional
        leftMarginFactor: 0.8, // optional (0.0 left, 0.5 center, 0.8 right)
      );
    }
  }

  Future<void> _pickAndUploadPlotData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true, // Important! get bytes for web
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedFile = result.files.single;
      });

      await uploadPlotData(
          result.files.single.bytes!, result.files.single.name, "", "");
    } else {
      CustomSnackBar.show(
        context,
        message: "No file selected",
        backgroundColor: Colors.orange, // optional
        icon: Icons.warning, // optional
        bottomMargin: 40, // optional
        leftMarginFactor: 0.8, // optional (0.0 left, 0.5 center, 0.8 right)
      );
    }
  }

  List<Map<String, dynamic>> _records = [];
  bool _loading = true;

  List<Map<String, dynamic>> _userRecords = [];
  bool _userLoading = true;

  @override
  void initState() {
    super.initState();
    loadCropSamples(); // call function on init
      loadUsers();
  }

  /// Call the API service
  Future<void> loadCropSamples() async {
    setState(() => _loading = true);

    final apiUrl = '${Config.baseUrl}/fetch_all'; // your Flask API
    final data = await fetchCropSamples(apiUrl: apiUrl);
if (!mounted) return;
    setState(() {
      _records = data;
      _loading = false;
    });
  }


  Future<void> loadUsers() async {
  setState(() => _userLoading = true);

  final apiUrl = '${Config.baseUrl}/fetch_users';

  final data = await fetchUsers(apiUrl: apiUrl);

  if (!mounted) return;

  setState(() {
    _userRecords = data;
    _userLoading = false;
  });
}

  final List<String> _menuItems = [
    "Overview",
    "Plot Records",
    "Upload Data",
    "User Records",
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
              "© 2026 CropBio MMSU",
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
    return IndexedStack(
      index: _selectedIndex,
      children: [
        _buildOverview(),
        _buildPlotRecords(),
        UploadSection(),
         _buildUserRecords(),   
        // UploadSection(
        //   onUploadCropData: _pickAndUploadCropData,
        //   onUploadPlotData: _pickAndUploadPlotData,
        // ),
        // UploadSection(
        //   onUploadCropData: _pickAndUploadCropData,
        //   onUploadPlotData: _pickAndUploadPlotData,
        // ),
        // UploadSection(
        //   onUploadCropData: _pickAndUploadCropData,
        //   onUploadPlotData: _pickAndUploadPlotData,
        // ),
        // UploadSection(
        //   onUploadCropData: _pickAndUploadCropData,
        //   onUploadPlotData: _pickAndUploadPlotData,
        // ),
      ],
    );
  }



Widget _buildUserRecords() {
  return UserRecords(
    records: _userRecords,
    loading: _userLoading,
  );
}


  // ================= OVERVIEW =================

  Widget _buildOverview() {
    return OverviewTable(records: _records, loading: _loading);
  }
  // ================= CROP RECORDS =================

  Widget _buildPlotRecords() {
    return PlotRecords(
      records: _records,
      loading: _loading,
    );
  }

  // ================= UPLOAD SECTION =================

  // Widget _buildUploadSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "Upload Crop Data",
  //         style: TextStyle(
  //           fontSize: 28,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 30),
  //       ElevatedButton.icon(
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: const Color(0xFFC6A432),
  //           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
  //         ),
  //         onPressed: _pickCsvFile,
  //         icon: const Icon(Icons.upload_file, color: Colors.black),
  //         label: const Text(
  //           "Upload CSV / Excel",
  //           style: TextStyle(color: Colors.black),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
