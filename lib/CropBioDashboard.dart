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
      allowedExtensions: ['csv'],
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
      allowedExtensions: ['csv'],
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

      final normalizedRecords = _normalizeCropResponse(data);

      setState(() {
        _records = normalizedRecords;
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

      final normalizedUsers = _normalizeGenericResponse(data);

      setState(() {
        _userRecords = normalizedUsers;
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

  // ================= NORMALIZATION / REMAPPING =================

  List<Map<String, dynamic>> _normalizeCropResponse(dynamic response) {
    final rawRecords = _extractCropRecordList(response);

    return rawRecords.map<Map<String, dynamic>>((item) {
      if (item is Map<String, dynamic>) {
        return _normalizeSingleRecord(item);
      }

      if (item is Map) {
        return _normalizeSingleRecord(Map<String, dynamic>.from(item));
      }

      return <String, dynamic>{};
    }).where((record) => record.isNotEmpty).toList();
  }

  List<Map<String, dynamic>> _normalizeGenericResponse(dynamic response) {
    final rawRecords = _extractGenericRecordList(response);

    return rawRecords.map<Map<String, dynamic>>((item) {
      if (item is Map<String, dynamic>) {
        return item;
      }

      if (item is Map) {
        return Map<String, dynamic>.from(item);
      }

      return <String, dynamic>{};
    }).where((record) => record.isNotEmpty).toList();
  }

  List<dynamic> _extractCropRecordList(dynamic response) {
    if (response == null) return [];

    if (response is List) {
      return response;
    }

    if (response is Map) {
      if (response['collection'] is List) {
        final List<dynamic> flattened = [];

        for (final collectionItem in response['collection']) {
          if (collectionItem is Map) {
            final collectionMap = Map<String, dynamic>.from(collectionItem);

            final sourceCollection = collectionMap['source_collection'] ??
                collectionMap['collection_name'] ??
                collectionMap['name'];

            final collectionData = collectionMap['data'];

            if (collectionData is List) {
              for (final record in collectionData) {
                if (record is Map) {
                  final mappedRecord = Map<String, dynamic>.from(record);

                  if (sourceCollection != null &&
                      mappedRecord['source_collection'] == null) {
                    mappedRecord['source_collection'] = sourceCollection;
                  }

                  flattened.add(mappedRecord);
                }
              }
            }
          }
        }

        return flattened;
      }

      final possibleKeys = [
        'data',
        'records',
        'samples',
        'results',
        'items',
        'crop_samples',
        'cropSamples',
      ];

      for (final key in possibleKeys) {
        final value = response[key];

        if (value is List) {
          return value;
        }

        if (value is Map) {
          final nested = _extractCropRecordList(value);

          if (nested.isNotEmpty) {
            return nested;
          }
        }
      }

      for (final value in response.values) {
        if (value is List) {
          return value;
        }

        if (value is Map) {
          final nested = _extractCropRecordList(value);

          if (nested.isNotEmpty) {
            return nested;
          }
        }
      }
    }

    return [];
  }

  List<dynamic> _extractGenericRecordList(dynamic response) {
    if (response == null) return [];

    if (response is List) {
      return response;
    }

    if (response is Map) {
      final possibleKeys = [
        'data',
        'records',
        'users',
        'results',
        'items',
        'collection',
      ];

      for (final key in possibleKeys) {
        final value = response[key];

        if (value is List) {
          if (key == 'collection') {
            final List<dynamic> flattened = [];

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
          final nested = _extractGenericRecordList(value);

          if (nested.isNotEmpty) {
            return nested;
          }
        }
      }

      for (final value in response.values) {
        if (value is List) {
          return value;
        }

        if (value is Map) {
          final nested = _extractGenericRecordList(value);

          if (nested.isNotEmpty) {
            return nested;
          }
        }
      }
    }

    return [];
  }

  Map<String, dynamic> _normalizeSingleRecord(Map<String, dynamic> record) {
    final normalized = Map<String, dynamic>.from(record);
    final plotInfo = _asMap(record['plot_info']);

    _setIfMissing(
      normalized,
      'CODE',
      _firstValue(record, ['CODE', 'Code', 'code']),
    );

    _setIfMissing(
      normalized,
      'CROP_TYPE',
      _firstValue(record, ['CROP_TYPE', 'Crop', 'crop', 'crop_type']),
    );

    _setIfMissing(
      normalized,
      'FRESH_WEIGHT',
      _numberOrNull(
        _firstValue(record, ['FRESH_WEIGHT', 'FreshWeight', 'fresh_weight']),
      ),
    );

    _setIfMissing(
      normalized,
      'DRY_WEIGHT',
      _numberOrNull(
        _firstValue(record, ['DRY_WEIGHT', 'DryWeight', 'dry_weight']),
      ),
    );

    _setIfMissing(
      normalized,
      'Average_Leaf_Area',
      _numberOrNull(
        _firstValue(record, ['Average_Leaf_Area', 'average_leaf_area']),
      ),
    );

    _setIfMissing(
      normalized,
      'Corrected_Leaf_Area_(CF=0.75)',
      _numberOrNull(
        _firstValue(record, [
          'Corrected_Leaf_Area_(CF=0.75)',
          'corrected_leaf_area',
        ]),
      ),
    );

    _setIfMissing(
      normalized,
      'SPAD__values',
      _numberOrNull(
        _firstValue(record, ['SPAD__values', 'SPAD', 'spad']),
      ),
    );

    _setIfMissing(
      normalized,
      'Chl_A',
      _numberOrNull(
        _firstValue(record, ['Chl_A', 'ChlA', 'chl-a', 'chl_a', 'CHL_A']),
      ),
    );

    _setIfMissing(
      normalized,
      'Chl_B',
      _numberOrNull(
        _firstValue(record, ['Chl_B', 'ChlB', 'chl-b', 'chl_b', 'CHL_B']),
      ),
    );

    _setIfMissing(
      normalized,
      'Caretenoid',
      _numberOrNull(
        _firstValue(record, [
          'Caretenoid',
          'Carotenoid',
          'carotenoid',
          'caretenoid',
        ]),
      ),
    );

    _setIfMissing(
      normalized,
      'LDMC',
      _numberOrNull(
        _firstValue(record, [
          'LDMC',
          'Leaf_Dry_Matter_Content_(LDMC)',
          'leaf_dry_matter_content',
        ]),
      ),
    );

    _setIfMissing(
      normalized,
      'Chloropyll_Val',
      _numberOrNull(
        _firstValue(record, [
          'Chloropyll_Val',
          'Chloropyll__Value_(mg/m2)',
          'Chlorophyll_Value',
          'chlorophyll_value',
        ]),
      ),
    );

    _setIfMissing(
      normalized,
      'Leaf_Water_Concentration',
      _numberOrNull(
        _firstValue(record, [
          'Leaf_Water_Concentration',
          'leaf_water_concentration',
        ]),
      ),
    );

    _setIfMissing(
      normalized,
      'Equivalent_Water_Thickness_(EWT)',
      _numberOrNull(
        _firstValue(record, [
          'Equivalent_Water_Thickness_(EWT)',
          'EWT',
          'equivalent_water_thickness',
        ]),
      ),
    );

    _setIfMissing(
      normalized,
      'Specific_Leaf_Area_(cm2/g)',
      _numberOrNull(
        _firstValue(record, [
          'Specific_Leaf_Area_(cm2/g)',
          'specific_leaf_area',
        ]),
      ),
    );

    _setIfMissing(
      normalized,
      'LAI',
      _numberOrNull(_firstValue(record, ['LAI', 'lai'])),
    );

    _setIfMissing(
      normalized,
      'DIFN',
      _numberOrNull(_firstValue(record, ['DIFN', 'difn'])),
    );

    _setIfMissing(
      normalized,
      'MTA',
      _numberOrNull(_firstValue(record, ['MTA', 'mta'])),
    );

    _setIfMissing(
      normalized,
      'SEM',
      _numberOrNull(_firstValue(record, ['SEM', 'sem'])),
    );

    _setIfMissing(
      normalized,
      'SMP',
      _numberOrNull(_firstValue(record, ['SMP', 'smp'])),
    );

    _setIfMissing(
      normalized,
      'SEL',
      _numberOrNull(_firstValue(record, ['SEL', 'sel'])),
    );

    _setIfMissing(
      normalized,
      'FIELD',
      _firstValue(record, ['FIELD', 'Field', 'field']),
    );

    _setIfMissing(
      normalized,
      'PLOT',
      _firstValue(record, ['PLOT', 'Plot', 'plot']),
    );

    _setIfMissing(
      normalized,
      'PLANT_SAMPLE',
      _numberOrNull(
        _firstValue(record, ['PLANT_SAMPLE', 'PlantSample', 'plant_sample']),
      ),
    );

    _setIfMissing(
      normalized,
      'Plant_Height',
      _numberOrNull(
        _firstValueFromRecordAndPlotInfo(
          record,
          plotInfo,
          ['Plant_Height', 'PLANT_HEIGHT', 'plant_height'],
        ),
      ),
    );

    _setIfMissing(
      normalized,
      'Plant',
      _numberOrNull(
        _firstValueFromRecordAndPlotInfo(
          record,
          plotInfo,
          ['Plant', 'PLANT_SPACING', 'plant_spacing'],
        ),
      ),
    );

    _setIfMissing(
      normalized,
      'Row',
      _numberOrNull(
        _firstValueFromRecordAndPlotInfo(
          record,
          plotInfo,
          ['Row', 'ROW_SPACING', 'row_spacing'],
        ),
      ),
    );

    _setIfMissing(
      normalized,
      'Temperature',
      _numberOrNull(
        _firstValueFromRecordAndPlotInfo(
          record,
          plotInfo,
          ['Temperature', 'SOIL_TEMPERATURE', 'soil_temperature'],
        ),
      ),
    );

    _setIfMissing(
      normalized,
      'Moisture',
      _numberOrNull(
        _firstValueFromRecordAndPlotInfo(
          record,
          plotInfo,
          ['Moisture', 'SOIL_MOISTURE', 'soil_moisture'],
        ),
      ),
    );

    _setIfMissing(
      normalized,
      'Type',
      _firstValueFromRecordAndPlotInfo(
        record,
        plotInfo,
        ['Type', 'SOIL_TYPE', 'soil_type'],
      ),
    );

    _setIfMissing(
      normalized,
      'Length',
      _numberOrNull(
        _firstValueFromRecordAndPlotInfo(
          record,
          plotInfo,
          ['Length', 'LENGTH', 'length'],
        ),
      ),
    );

    _setIfMissing(
      normalized,
      'Width',
      _numberOrNull(
        _firstValueFromRecordAndPlotInfo(
          record,
          plotInfo,
          ['Width', 'WIDTH', 'width'],
        ),
      ),
    );

    _setIfMissing(
      normalized,
      'LAT',
      _numberOrNull(
        _firstValueFromRecordAndPlotInfo(
          record,
          plotInfo,
          ['LAT', 'lat', 'latitude'],
        ),
      ),
    );

    _setIfMissing(
      normalized,
      'LON',
      _numberOrNull(
        _firstValueFromRecordAndPlotInfo(
          record,
          plotInfo,
          ['LON', 'lon', 'longitude'],
        ),
      ),
    );

    final sourceCollection = normalized['source_collection'];

    if (sourceCollection != null) {
      final source = sourceCollection.toString();

      final yearMatch = RegExp(r'(20\d{2})').firstMatch(source);

      if (yearMatch != null) {
        _setIfMissing(
          normalized,
          'YEAR',
          int.tryParse(yearMatch.group(1)!),
        );
      }

      final lowerSource = source.toLowerCase();

      if (lowerSource.contains('dry')) {
        _setIfMissing(normalized, 'SEASON', 'Dry Season');
      } else if (lowerSource.contains('wet')) {
        _setIfMissing(normalized, 'SEASON', 'Wet Season');
      }
    }

    return normalized;
  }

  bool _hasPlotData(Map<String, dynamic> record) {
    final plotInfo = record['plot_info'];

    if (plotInfo is Map && plotInfo.isNotEmpty) {
      return true;
    }

    final plotKeys = [
      'FIELD',
      'PLOT',
      'LAT',
      'LON',
      'Plant_Height',
      'Plant',
      'Row',
      'Temperature',
      'Moisture',
      'Type',
      'Length',
      'Width',
    ];

    return plotKeys.any((key) {
      final value = record[key];

      if (value == null) return false;

      if (value is String) return value.trim().isNotEmpty;

      return true;
    });
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  dynamic _firstValue(Map<String, dynamic> record, List<String> keys) {
    for (final key in keys) {
      if (record.containsKey(key) && record[key] != null) {
        return record[key];
      }
    }

    return null;
  }

  dynamic _firstValueFromRecordAndPlotInfo(
    Map<String, dynamic> record,
    Map<String, dynamic> plotInfo,
    List<String> keys,
  ) {
    for (final key in keys) {
      if (record.containsKey(key) && record[key] != null) {
        return record[key];
      }

      if (plotInfo.containsKey(key) && plotInfo[key] != null) {
        return plotInfo[key];
      }
    }

    return null;
  }

  num? _numberOrNull(dynamic value) {
    if (value == null) return null;

    if (value is num) return value;

    if (value is String) {
      final cleaned = value.replaceAll(',', '').trim();

      return num.tryParse(cleaned);
    }

    return null;
  }

  void _setIfMissing(
    Map<String, dynamic> record,
    String key,
    dynamic value,
  ) {
    final currentValue = record[key];

    final isCurrentMissing = currentValue == null ||
        currentValue.toString().trim().isEmpty ||
        currentValue.toString().trim().toLowerCase() == 'null';

    if (isCurrentMissing && value != null) {
      record[key] = value;
    }
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
    } else if (value == "Upload Crop Data") {
      _pickAndUploadCropData();
    } else if (value == "Upload Plot Data") {
      _pickAndUploadPlotData();
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
        return "Upload crop and plot CSV files";
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