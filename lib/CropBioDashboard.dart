import 'package:cropbio/API/UploadCsv.dart';
import 'package:cropbio/API/FetchAll.dart';
import 'package:cropbio/API/UserAPi.dart';
import 'package:cropbio/Configs/config.dart';
import 'package:cropbio/DashboardWidgets/AllColumnsRecordsTable.dart';
import 'package:cropbio/DashboardWidgets/UploadSection.dart';
import 'package:cropbio/DashboardWidgets/UserRecords.dart';
import 'package:cropbio/Pherips/LayoutWrapper.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:cropbio/Widgets/CustomSnackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Cropbiodashboard extends StatefulWidget {
  const Cropbiodashboard({super.key});

  @override
  State<Cropbiodashboard> createState() => _CropbiodashboardState();
}

class _CropbiodashboardState extends State<Cropbiodashboard> {
  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSidebar = Color(0xFF111C14);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  int _selectedIndex = 0;

  PlatformFile? _selectedFile;

  List<Map<String, dynamic>> _records = [];
  bool _loading = true;

  List<Map<String, dynamic>> _userRecords = [];
  bool _userLoading = true;

  final List<_DashboardMenuItem> _menuItems = const [
    _DashboardMenuItem(
      title: "Overview",
      icon: Icons.dashboard_rounded,
    ),
    _DashboardMenuItem(
      title: "Upload Data",
      icon: Icons.upload_file_rounded,
    ),
    _DashboardMenuItem(
      title: "User Records",
      icon: Icons.people_alt_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    loadCropSamples();
    loadUsers();
  }

  int get _plotRecordCount {
    return _records.where(_hasPlotData).length;
  }

  // ================= UPLOAD FUNCTIONS =================

  Future<void> _pickAndUploadCropData() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedFile = result.files.single;
      });

      try {
        await uploadCropData(
          result.files.single.bytes!,
          result.files.single.name,
          "",
          "",
        );

        await loadCropSamples();

        if (!mounted) return;

        CustomSnackBar.show(
          context,
          message: "Crop data uploaded successfully",
          backgroundColor: primaryGreen,
          icon: Icons.check_circle_rounded,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );
      } catch (e) {
        if (!mounted) return;

        CustomSnackBar.show(
          context,
          message: "Failed to upload crop data: $e",
          backgroundColor: Colors.red,
          icon: Icons.error_outline_rounded,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );
      }
    } else {
      CustomSnackBar.show(
        context,
        message: "No file selected",
        backgroundColor: Colors.orange,
        icon: Icons.warning,
        bottomMargin: 40,
        leftMarginFactor: 0.8,
      );
    }
  }

  Future<void> _pickAndUploadPlotData() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedFile = result.files.single;
      });

      try {
        await uploadPlotData(
          result.files.single.bytes!,
          result.files.single.name,
          "",
          "",
        );

        await loadCropSamples();

        if (!mounted) return;

        CustomSnackBar.show(
          context,
          message: "Plot data uploaded successfully",
          backgroundColor: primaryGreen,
          icon: Icons.check_circle_rounded,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );
      } catch (e) {
        if (!mounted) return;

        CustomSnackBar.show(
          context,
          message: "Failed to upload plot data: $e",
          backgroundColor: Colors.red,
          icon: Icons.error_outline_rounded,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );
      }
    } else {
      CustomSnackBar.show(
        context,
        message: "No file selected",
        backgroundColor: Colors.orange,
        icon: Icons.warning,
        bottomMargin: 40,
        leftMarginFactor: 0.8,
      );
    }
  }

  // ================= API LOADERS =================

  Future<void> loadCropSamples() async {
    setState(() {
      _loading = true;
    });

    try {
      final apiUrl = '${Config.baseUrl}/fetch_all';
      final data = await fetchCropSamples(apiUrl: apiUrl);

      if (!mounted) return;

      final records = _recordsFromResponse(data);

      setState(() {
        _records = records;
        _loading = false;
      });

      debugPrint(
        "CropBio Dashboard: loaded ${_records.length} crop records",
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _records = [];
        _loading = false;
      });

      CustomSnackBar.show(
        context,
        message: "Failed to load crop records: $e",
        backgroundColor: Colors.red,
        icon: Icons.error_outline_rounded,
        bottomMargin: 40,
        leftMarginFactor: 0.8,
      );
    }
  }

  Future<void> loadUsers() async {
    setState(() {
      _userLoading = true;
    });

    try {
      final apiUrl = '${Config.baseUrl}/fetch_users';
      final data = await fetchUsers(apiUrl: apiUrl);

      if (!mounted) return;

      final users = _recordsFromResponse(data);

      setState(() {
        _userRecords = users;
        _userLoading = false;
      });

      debugPrint(
        "CropBio Dashboard: loaded ${_userRecords.length} user records",
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _userRecords = [];
        _userLoading = false;
      });

      CustomSnackBar.show(
        context,
        message: "Failed to load user records: $e",
        backgroundColor: Colors.red,
        icon: Icons.error_outline_rounded,
        bottomMargin: 40,
        leftMarginFactor: 0.8,
      );
    }
  }

  // ================= DIRECT RECORD READING =================
  //
  // No normalization, remapping, renaming, or fixed-column conversion is done here.
  // Every record is displayed using the exact keys returned by the backend.

  List<Map<String, dynamic>> _recordsFromResponse(dynamic response) {
    final rawRecords = _extractRecordList(response);

    return rawRecords.map<Map<String, dynamic>>((item) {
      if (item is Map<String, dynamic>) {
        return Map<String, dynamic>.from(item);
      }

      if (item is Map) {
        return Map<String, dynamic>.from(item);
      }

      return <String, dynamic>{};
    }).where((record) => record.isNotEmpty).toList();
  }

  List<dynamic> _extractRecordList(dynamic response) {
    if (response == null) return [];

    if (response is List) {
      return response;
    }

    if (response is Map) {
      final possibleKeys = [
        'data',
        'records',
        'samples',
        'results',
        'items',
        'crop_samples',
        'cropSamples',
        'users',
        'collection',
      ];

      for (final key in possibleKeys) {
        final value = response[key];

        if (value is List) {
          if (key == 'collection') {
            final flattened = <dynamic>[];

            for (final item in value) {
              if (item is Map && item['data'] is List) {
                flattened.addAll(item['data'] as List);
              } else {
                flattened.add(item);
              }
            }

            return flattened;
          }

          return value;
        }

        if (value is Map) {
          final nested = _extractRecordList(value);

          if (nested.isNotEmpty) {
            return nested;
          }
        }
      }

      // If no wrapper list exists, treat the map itself as one record.
      return [response];
    }

    return [];
  }

  bool _hasPlotData(Map<String, dynamic> record) {
    // No values are created or remapped here. This only checks whether the
    // original record already appears to contain plot/location information.
    if (record['plot_info'] is Map && (record['plot_info'] as Map).isNotEmpty) {
      return true;
    }

    final lowerKeys = record.keys.map((key) => key.toString().toLowerCase()).toSet();

    return lowerKeys.any(
      (key) =>
          key == 'plot' ||
          key == 'field' ||
          key == 'lat' ||
          key == 'lon' ||
          key == 'latitude' ||
          key == 'longitude' ||
          key.contains('plot'),
    );
  }

  // ================= ACTIONS =================

  Future<void> _refreshCurrentPage() async {
    if (_selectedIndex == 0 || _selectedIndex == 1) {
      await loadCropSamples();
    } else if (_selectedIndex == 2) {
      await loadUsers();
    }
  }

  void _showActionMessage(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: darkSurface2,
        content: Text(
          '$action action triggered.',
          style: GoogleFonts.nunito(
            color: lightText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(String value) {
    if (value == "Refresh") {
      _refreshCurrentPage();
    } else if (value == "Upload Crop Data" || value == "Upload Plot Data") {
      // The UploadSection owns its own selected-file and preview state.
      // Do not pick/upload files here because doing so bypasses the preview table.
      // Instead, open the Upload Data page and let the user select the file there.
      setState(() {
        _selectedIndex = 1;
      });

      _showActionMessage("Open Upload Data and select the CSV/Excel file there to preview it before storing");
    } else {
      _showActionMessage(value);
    }
  }

  String get _currentTitle {
    return _menuItems[_selectedIndex].title;
  }

  String get _currentSubtitle {
    switch (_selectedIndex) {
      case 0:
        return "Complete CropBio laboratory-derived crop and plot records";
      case 1:
        return "Preview and upload CSV or Excel files with any columns";
      case 2:
        return "System users and access records";
      default:
        return "CropBio dashboard";
    }
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<LayoutProvider>();

    return LayoutWrapper(
      child: Theme(
        data: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: darkBg,
          primaryColor: primaryGreen,
          colorScheme: const ColorScheme.dark(
            primary: primaryGreen,
            surface: darkSurface,
            secondary: accentGreen,
          ),
          textTheme: GoogleFonts.nunitoTextTheme(
            ThemeData.dark().textTheme,
          ),
        ),
        child: Scaffold(
          backgroundColor: darkBg,
          drawer: layout.isMobile
              ? Drawer(
                  backgroundColor: darkSidebar,
                  child: SafeArea(
                    child: _buildSidebar(
                      layout: layout,
                      isDrawer: true,
                    ),
                  ),
                )
              : null,
          body: SafeArea(
            child: layout.isMobile
                ? _buildMobileLayout(layout)
                : _buildDesktopLayout(layout),
          ),
        ),
      ),
    );
  }
Widget _buildDesktopLayout(LayoutProvider layout) {
  return Row(
    children: [
      _buildSidebar(layout: layout),
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth;
            final double targetWidth = layout.contentWidth > availableWidth
                ? availableWidth
                : layout.contentWidth;

            return Center(
              child: SizedBox(
                width: targetWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: availableWidth < 900 ? 16 : 28,
                    vertical: layout.verticalPadding,
                  ),
                  child: Column(
                    children: [
                      _buildTopStatsRow(layout),
                      const SizedBox(height: 18),
                      _buildTitleBar(layout),
                      const SizedBox(height: 24),
                      Expanded(
                        child: _buildMainContent(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}


Widget _buildMobileLayout(LayoutProvider layout) {
  final bool showStats = _selectedIndex == 0;

  return Center(
    child: SizedBox(
      width: layout.contentWidth,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: layout.verticalPadding,
        ),
        child: Column(
          children: [
            _buildTitleBar(layout),

            if (showStats) ...[
              const SizedBox(height: 10),
              _buildTopStatsRow(layout),
            ],

            const SizedBox(height: 10),

            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    ),
  );
}

  // ================= SIDEBAR / DRAWER =================

  Widget _buildSidebar({
    required LayoutProvider layout,
    bool isDrawer = false,
  }) {
    return Container(
      width: isDrawer ? double.infinity : 280,
      padding: EdgeInsets.symmetric(
        horizontal: layout.isMobile ? 16 : 20,
        vertical: layout.isMobile ? 20 : 28,
      ),
      decoration: BoxDecoration(
        color: darkSidebar,
        border: Border(
          right: BorderSide(
            color: isDrawer ? Colors.transparent : darkBorder,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cropBioLogoCard(layout),
          SizedBox(height: layout.isMobile ? 24 : 32),
          Text(
            'MAIN MENU',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: mutedText,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              itemCount: _menuItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _sidebarItem(
                  index,
                  closeDrawerOnTap: isDrawer,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _cropBioLogoCard(LayoutProvider layout) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 14 : 16),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryGreen.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.25),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: "logo",
            child: Container(
              height: layout.isMobile ? 50 : 58,
              width: layout.isMobile ? 50 : 58,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                    color: Colors.black.withValues(alpha: 0.18),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                "lib/Assets/Cropbio_LOGO_dark.svg",
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CropBio",
                  style: GoogleFonts.nunito(
                    fontSize: layout.isMobile ? 19 : 21,
                    fontWeight: FontWeight.w900,
                    color: lightText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Data Dashboard",
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(
    int index, {
    bool closeDrawerOnTap = false,
  }) {
    final item = _menuItems[index];
    final isSelected = _selectedIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });

        if (closeDrawerOnTap) {
          Navigator.pop(context);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : darkSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryGreen : darkBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 20,
              color: isSelected ? Colors.white : accentGreen,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                style: GoogleFonts.nunito(
                  color: isSelected ? Colors.white : lightText,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: darkBorder,
        ),
      ),
      child: Text(
        "© 2026 CropBio MMSU",
        textAlign: TextAlign.center,
        style: GoogleFonts.nunito(
          color: mutedText,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }


  Widget _mobileTopStatCard({
  required String label,
  required String value,
  required IconData icon,
}) {
  return Container(
    height: 66,
    padding: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: darkSurface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: darkBorder,
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 14,
          offset: const Offset(0, 6),
          color: Colors.black.withValues(alpha: 0.22),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: primaryGreen.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: primaryGreen.withValues(alpha: 0.30),
            ),
          ),
          child: Icon(
            icon,
            color: accentGreen,
            size: 18,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: lightText,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: mutedText,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _mobileTitleBar() {
  return Builder(
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: darkSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: darkBorder,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: 0.24),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: "Open menu",
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minHeight: 38,
                minWidth: 38,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu_rounded,
                color: lightText,
                size: 24,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              height: 36,
              width: 36,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
              "lib/Assets/Cropbio_LOGO_dark.svg",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentTitle.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: lightText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _currentSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      color: mutedText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 2),
            SizedBox(
              width: 38,
              height: 38,
              child: PopupMenuButton<String>(
                tooltip: 'More options',
                color: darkSurface2,
                iconColor: lightText,
                padding: EdgeInsets.zero,
                iconSize: 22,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onSelected: _handleMenuAction,
                itemBuilder: (context) => [
                  _darkPopupItem(
                    value: 'Refresh',
                    icon: Icons.refresh_rounded,
                    label: 'Refresh',
                  ),
                  _darkPopupItem(
                    value: 'Upload Crop Data',
                    icon: Icons.upload_file_rounded,
                    label: 'Upload Crop Data',
                  ),
                  _darkPopupItem(
                    value: 'Upload Plot Data',
                    icon: Icons.map_rounded,
                    label: 'Upload Plot Data',
                  ),
                  _darkPopupItem(
                    value: 'Export',
                    icon: Icons.download_rounded,
                    label: 'Export',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
  // ================= TOP STATS =================

Widget _buildTopStatsRow(LayoutProvider layout) {
  if (layout.isMobile) {
    return Row(
      children: [
        Expanded(
          child: _mobileTopStatCard(
            label: "Crops",
            value: _loading ? "..." : _records.length.toString(),
            icon: Icons.table_chart_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _mobileTopStatCard(
            label: "Plots",
            value: _loading ? "..." : _plotRecordCount.toString(),
            icon: Icons.map_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _mobileTopStatCard(
            label: "Users",
            value: _userLoading ? "..." : _userRecords.length.toString(),
            icon: Icons.people_alt_rounded,
          ),
        ),
      ],
    );
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final double width = constraints.maxWidth;

      final cards = [
        _topStatCard(
          label: "Crop Records",
          value: _loading ? "..." : _records.length.toString(),
          icon: Icons.table_chart_rounded,
          layout: layout,
        ),
        _topStatCard(
          label: "Plot Records",
          value: _loading ? "..." : _plotRecordCount.toString(),
          icon: Icons.map_rounded,
          layout: layout,
        ),
        _topStatCard(
          label: "User Records",
          value: _userLoading ? "..." : _userRecords.length.toString(),
          icon: Icons.people_alt_rounded,
          layout: layout,
        ),
      ];

      if (width < 900) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: cards.map((card) {
            return SizedBox(
              width: (width - 16) / 2,
              child: card,
            );
          }).toList(),
        );
      }

      return Row(
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 16),
          Expanded(child: cards[1]),
          const SizedBox(width: 16),
          Expanded(child: cards[2]),
        ],
      );
    },
  );
}

Widget _topStatCard({
  required String label,
  required String value,
  required IconData icon,
  required LayoutProvider layout,
}) {
  return Container(
    constraints: const BoxConstraints(
      minHeight: 88,
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 16,
    ),
    decoration: BoxDecoration(
      color: darkSurface,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: darkBorder,
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 24,
          offset: const Offset(0, 10),
          color: Colors.black.withValues(alpha: 0.28),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: primaryGreen.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryGreen.withValues(alpha: 0.30),
            ),
          ),
          child: Icon(
            icon,
            color: accentGreen,
            size: 25,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: lightText,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: mutedText,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
  
  // ================= TITLE BAR =================

  Widget _buildTitleBar(LayoutProvider layout) {
    if (layout.isMobile) {
      return _mobileTitleBar();
    }

    return _desktopTitleBar();
  }


 
  Widget _desktopTitleBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: darkBorder,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.28),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SvgPicture.asset(
              "lib/Assets/Cropbio_LOGO_dark.svg",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentTitle.toUpperCase(),
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentSubtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _refreshCurrentPage,
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.white,
            ),
            label: const Text("Refresh"),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(width: 10),
          PopupMenuButton<String>(
            tooltip: 'More options',
            color: darkSurface2,
            iconColor: lightText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              _darkPopupItem(
                value: 'Refresh',
                icon: Icons.refresh_rounded,
                label: 'Refresh',
              ),
              _darkPopupItem(
                value: 'Upload Crop Data',
                icon: Icons.upload_file_rounded,
                label: 'Upload Crop Data',
              ),
              _darkPopupItem(
                value: 'Upload Plot Data',
                icon: Icons.map_rounded,
                label: 'Upload Plot Data',
              ),
              _darkPopupItem(
                value: 'Export',
                icon: Icons.download_rounded,
                label: 'Export',
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _darkPopupItem({
    required String value,
    required IconData icon,
    required String label,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: accentGreen,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ================= MAIN CONTENT =================

  Widget _buildMainContent() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        _buildOverview(),
        _buildUploadSection(),
        _buildUserRecords(),
      ],
    );
  }

  Widget _buildOverview() {
    return _darkContentShell(
      child: AllColumnsRecordsTable(
        key: ValueKey('overview_all_columns_${_records.length}_$_loading'),
        title: 'Overview Records',
        records: _records,
        loading: _loading,
      ),
    );
  }

  Widget _buildUploadSection() {
    return _darkContentShell(
      padding: const EdgeInsets.all(24),
      child: UploadSection(),
    );
  }

  Widget _buildUserRecords() {
    return _darkContentShell(
      child: UserRecords(
        key: ValueKey('users_${_userRecords.length}_$_userLoading'),
        records: _userRecords,
        loading: _userLoading,
      ),
    );
  }

  Widget _darkContentShell({
    required Widget child,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: darkBorder,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.28),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: child,
      ),
    );
  }
}

class _DashboardMenuItem {
  final String title;
  final IconData icon;

  const _DashboardMenuItem({
    required this.title,
    required this.icon,
  });
}