import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:cropbio/API/fetchAll.dart';
import 'package:cropbio/Configs/config.dart';
import 'package:cropbio/Pherips/LayoutWrapper.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web/web.dart' as web;

class TabularDataListPage extends StatefulWidget {
  final String type;

  const TabularDataListPage({
    super.key,
    required this.type,
  });

  @override
  State<TabularDataListPage> createState() => _TabularDataListPageState();
}

class _TabularDataListPageState extends State<TabularDataListPage> {
  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSidebar = Color(0xFF111C14);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  late DynamicCropDataSource _dataSource;

  final DataGridController _controller = DataGridController();
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _verticalGridScrollController = ScrollController();
  final ScrollController _horizontalGridScrollController = ScrollController();

  List<Map<String, dynamic>> _records = [];
  List<Map<String, dynamic>> _visibleRecords = [];
  List<Map<String, dynamic>> _tableRecords = [];

  List<String> _columns = ['#'];
  Map<String, List<String>> _columnAliases = {};

  bool _loading = true;
  late int selectedYear;

  String selectedSeason = 'All';

  final List<String> seasonOptions = [
    'All',
    'Wet Season',
    'Dry Season',
  ];

  @override
  void initState() {
    super.initState();

    selectedYear = DateTime.now().year < 2025 ? 2025 : DateTime.now().year;

    _dataSource = DynamicCropDataSource(
      const [],
      _columns,
      _columnAliases,
      isMobile: false,
    );

    loadCropSamples();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _verticalGridScrollController.dispose();
    _horizontalGridScrollController.dispose();
    super.dispose();
  }

  List<int> get years {
    final currentYear =
        DateTime.now().year < 2025 ? 2025 : DateTime.now().year;

    return List.generate(
      currentYear - 2025 + 1,
      (index) => 2025 + index,
    ).reversed.toList();
  }

  Future<void> loadCropSamples() async {
    setState(() {
      _loading = true;
    });

    try {
      final apiUrl = '${Config.baseUrl}/fetch_all';
      final data = await fetchCropSamples(apiUrl: apiUrl);

      if (!mounted) return;

      setState(() {
        _records = _normalizeRecords(data);
        _loading = false;
      });

      _loadData();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _records = [];
        _visibleRecords = [];
        _tableRecords = [];
        _columns = ['#'];
        _columnAliases = {};
        _dataSource = DynamicCropDataSource(
          const [],
          _columns,
          _columnAliases,
          isMobile: false,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: darkSurface2,
          content: Text(
            'Failed to load crop samples: $e',
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
  }

  List<Map<String, dynamic>> _normalizeRecords(dynamic response) {
    final List<Map<String, dynamic>> flattenedRecords = [];

    if (response is Map) {
      final collections = response['collection'];

      if (collections is List) {
        for (final collectionGroup in collections) {
          if (collectionGroup is! Map) continue;

          final groupSeason = collectionGroup['season']?.toString();
          final groupYear = collectionGroup['year']?.toString();

          final groupData = collectionGroup['data'];

          if (groupData is! List) continue;

          for (final item in groupData) {
            if (item is! Map) continue;

            final record = _mapFromDynamic(item);

            record['year'] ??= groupYear;
            record['season'] ??= groupSeason;
            record['source_collection'] ??= '${groupYear}_${groupSeason}_crops';

            final cleanedRecord = _flattenPlotInfo(record);

            flattenedRecords.add(cleanedRecord);
          }
        }

        return flattenedRecords;
      }

      final data = response['data'];

      if (data is List) {
        return data.map<Map<String, dynamic>>((item) {
          final record = _mapFromDynamic(item);
          return _flattenPlotInfo(record);
        }).toList();
      }
    }

    if (response is List) {
      return response.map<Map<String, dynamic>>((item) {
        final record = _mapFromDynamic(item);
        return _flattenPlotInfo(record);
      }).toList();
    }

    return [];
  }

  Map<String, dynamic> _flattenPlotInfo(Map<String, dynamic> record) {
    final cleanedRecord = Map<String, dynamic>.from(record);

    final plotInfoKeys = [
      'plot_info',
      'plotInfo',
      'Plot_Info',
      'PLOT_INFO',
      'plotData',
      'plot_data',
      'Plot_Data',
      'PLOT_DATA',
    ];

    for (final key in plotInfoKeys) {
      if (!cleanedRecord.containsKey(key)) continue;

      final plotInfoValue = cleanedRecord.remove(key);
      final plotInfoMap = _toMap(plotInfoValue);

      if (plotInfoMap == null) continue;

      final flattenedPlotInfo = _flattenNestedMap(plotInfoMap);

      flattenedPlotInfo.forEach((plotKey, plotValue) {
        _putValueWithoutDuplicate(
          cleanedRecord,
          plotKey,
          plotValue,
        );
      });
    }

    return cleanedRecord;
  }

  Map<String, dynamic>? _toMap(dynamic value) {
    if (value == null) return null;

    if (value is Map) {
      return _mapFromDynamic(value);
    }

    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(value);

        if (decoded is Map) {
          return _mapFromDynamic(decoded);
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  Map<String, dynamic> _flattenNestedMap(
    Map<String, dynamic> map, {
    String prefix = '',
  }) {
    final flattened = <String, dynamic>{};

    map.forEach((key, value) {
      final cleanKey = key.toString().trim();

      if (cleanKey.isEmpty) return;

      final newKey = prefix.isEmpty ? cleanKey : '${prefix}_$cleanKey';

      if (value is Map) {
        flattened.addAll(
          _flattenNestedMap(
            _mapFromDynamic(value),
            prefix: newKey,
          ),
        );
      } else if (value is List) {
        flattened[newKey] = jsonEncode(value);
      } else {
        flattened[newKey] = value;
      }
    });

    return flattened;
  }

  Map<String, dynamic> _mapFromDynamic(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }

    if (value is Map) {
      return value.map<String, dynamic>(
        (key, dynamic val) => MapEntry(key.toString(), val),
      );
    }

    return {};
  }

  void _putValueWithoutDuplicate(
    Map<String, dynamic> record,
    String newKey,
    dynamic newValue,
  ) {
    final canonicalNewKey = _canonicalColumnName(newKey);

    String? existingKey;

    for (final key in record.keys) {
      final canonicalExistingKey = _canonicalColumnName(key);

      if (canonicalExistingKey == canonicalNewKey) {
        existingKey = key;
        break;
      }
    }

    if (existingKey == null) {
      record[canonicalNewKey] = newValue;
      return;
    }

    final existingValue = record[existingKey];

    if (_isEmptyValue(existingValue) && !_isEmptyValue(newValue)) {
      record[existingKey] = newValue;
    }
  }

  bool _isEmptyValue(dynamic value) {
    if (value == null) return true;

    if (value is String && value.trim().isEmpty) return true;

    return false;
  }

  void _loadData() {
    final hasYearField = _records.any(
      (record) => _extractYear(record) != null,
    );

    final hasSeasonField = _records.any(
      (record) =>
          _extractSeason(record) != null || _extractMonth(record) != null,
    );

    final filteredRecords = _records.where((record) {
      final matchesYear = !hasYearField || _extractYear(record) == selectedYear;

      final matchesSeason =
          !hasSeasonField || _matchesSelectedSeason(record);

      return matchesYear && matchesSeason;
    }).toList();

    filteredRecords.sort((a, b) {
      final yearCompare =
          (_extractYear(b) ?? 0).compareTo(_extractYear(a) ?? 0);

      if (yearCompare != 0) return yearCompare;

      final idA = a['_id']?.toString() ?? '';
      final idB = b['_id']?.toString() ?? '';

      return idB.compareTo(idA);
    });

    final columnBuildResult = _buildColumns(filteredRecords);

    if (!mounted) return;

    final isMobile = MediaQuery.of(context).size.width < 720;

    setState(() {
      _visibleRecords = filteredRecords;
      _tableRecords = filteredRecords;
      _columns = columnBuildResult.columns;
      _columnAliases = columnBuildResult.aliases;

      _dataSource = DynamicCropDataSource(
        _tableRecords,
        _columns,
        _columnAliases,
        isMobile: isMobile,
      );
    });
  }

  ColumnBuildResult _buildColumns(List<Map<String, dynamic>> records) {
    final Map<String, List<String>> aliases = {};

    for (final record in records) {
      for (final key in record.keys) {
        final canonicalName = _canonicalColumnName(key);

        if (canonicalName == 'plot_info') {
          continue;
        }

        aliases.putIfAbsent(canonicalName, () => []);

        if (!aliases[canonicalName]!.contains(key)) {
          aliases[canonicalName]!.add(key);
        }
      }
    }

    final preferredColumns = [
      '#',
      'year',
      'season',
      'source_collection',
      '_id',
      'CODE',
      'CROP_TYPE',
      'FIELD',
      'PLOT',
      'PLANT_SAMPLE',
    ];

    final orderedColumns = <String>[];

    for (final column in preferredColumns) {
      if (column == '#' || aliases.containsKey(column)) {
        orderedColumns.add(column);
      }
    }

    final remainingColumns = aliases.keys
        .where((column) => !orderedColumns.contains(column))
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    orderedColumns.addAll(remainingColumns);

    return ColumnBuildResult(
      columns: orderedColumns.isEmpty ? ['#'] : orderedColumns,
      aliases: aliases,
    );
  }

  String _canonicalColumnName(String key) {
    final normalized = key
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '');

    const canonicalNames = {
      'plotinfo': 'plot_info',
      'plotdata': 'plot_info',

      'id': '_id',
      'objectid': '_id',

      'code': 'CODE',
      'cropcode': 'CODE',

      'croptype': 'CROP_TYPE',
      'crop': 'CROP_TYPE',

      'field': 'FIELD',
      'plot': 'PLOT',
      'row': 'Row',
      'plant': 'Plant',
      'plantsample': 'PLANT_SAMPLE',

      'freshweight': 'FRESH_WEIGHT',
      'dryweight': 'DRY_WEIGHT',

      'averageleafarea': 'Average_Leaf_Area',
      'avgleafarea': 'Average_Leaf_Area',
      'correctedleafareacf075': 'Corrected_Leaf_Area_(CF=0.75)',
      'correctedleafarea': 'Corrected_Leaf_Area_(CF=0.75)',

      'spad': 'SPAD__values',
      'spadvalues': 'SPAD__values',

      'chloropyllval': 'Chloropyll__Value_(mg/m2)',
      'chloropyllvalue': 'Chloropyll__Value_(mg/m2)',
      'chloropyllvaluemgm2': 'Chloropyll__Value_(mg/m2)',
      'chlorophyllval': 'Chloropyll__Value_(mg/m2)',
      'chlorophyllvalue': 'Chloropyll__Value_(mg/m2)',
      'chlorophyllvaluemgm2': 'Chloropyll__Value_(mg/m2)',

      'chla': 'chl-a',
      'chlorophylla': 'chl-a',

      'chlb': 'chl-b',
      'chlorophyllb': 'chl-b',

      'caretenoid': 'carotenoid',
      'carotenoid': 'carotenoid',

      'ldmc': 'Leaf_Dry_Matter_Content_(LDMC)',
      'leafdrymattercontentldmc': 'Leaf_Dry_Matter_Content_(LDMC)',
      'leafdrymattercontent': 'Leaf_Dry_Matter_Content_(LDMC)',

      'leafwaterconcentration': 'Leaf_Water_Concentration',

      'equivalentwaterthicknessewt': 'Equivalent_Water_Thickness_(EWT)',
      'equivalentwaterthickness': 'Equivalent_Water_Thickness_(EWT)',
      'ewt': 'Equivalent_Water_Thickness_(EWT)',

      'specificleafareacm2g': 'Specific_Leaf_Area_(cm2/g)',
      'specificleafarea': 'Specific_Leaf_Area_(cm2/g)',
      'sla': 'Specific_Leaf_Area_(cm2/g)',

      'capcover': 'Cap_Cover',

      'lai': 'LAI',
      'difn': 'DIFN',
      'mta': 'MTA',
      'sem': 'SEM',
      'smp': 'SMP',
      'sel': 'SEL',

      'temperature': 'Temperature',
      'temp': 'Temperature',

      'plantheight': 'Plant_Height',
      'height': 'Plant_Height',

      'moisture': 'Moisture',
      'length': 'Length',
      'width': 'Width',
      'type': 'Type',

      'year': 'year',
      'season': 'season',
      'sourcecollection': 'source_collection',
    };

    return canonicalNames[normalized] ?? key;
  }

  dynamic _valueForColumn(
    Map<String, dynamic> record,
    String column,
    Map<String, List<String>> aliases,
  ) {
    if (record.containsKey(column) && record[column] != null) {
      return record[column];
    }

    final possibleKeys = aliases[column] ?? [];

    for (final key in possibleKeys) {
      if (record.containsKey(key) && record[key] != null) {
        return record[key];
      }
    }

    if (record.containsKey(column)) {
      return record[column];
    }

    return null;
  }

  bool _matchesSelectedSeason(Map<String, dynamic> record) {
    if (selectedSeason == 'All') return true;

    final season = _extractSeason(record);

    if (season != null) {
      final normalizedSeason = season.toLowerCase();

      if (selectedSeason == 'Wet Season') {
        return normalizedSeason.contains('wet');
      }

      if (selectedSeason == 'Dry Season') {
        return normalizedSeason.contains('dry');
      }
    }

    final month = _extractMonth(record);

    if (month == null) return true;

    if (selectedSeason == 'Wet Season') {
      return month >= 6 && month <= 11;
    }

    if (selectedSeason == 'Dry Season') {
      return month == 12 || month <= 5;
    }

    return true;
  }

  String? _extractSeason(Map<String, dynamic> record) {
    final seasonKeys = [
      'SEASON',
      'Season',
      'season',
      'CROP_SEASON',
      'crop_season',
      'PLANTING_SEASON',
      'planting_season',
    ];

    for (final key in seasonKeys) {
      final value = record[key];

      if (value == null) continue;

      final text = value.toString().trim();

      if (text.isNotEmpty) {
        return text;
      }
    }

    return null;
  }

  int? _extractMonth(Map<String, dynamic> record) {
    final monthKeys = [
      'MONTH',
      'Month',
      'month',
      'SURVEY_MONTH',
      'survey_month',
      'PLANTING_MONTH',
      'planting_month',
    ];

    for (final key in monthKeys) {
      final value = record[key];

      if (value == null) continue;

      if (value is int) return value;

      if (value is num) return value.toInt();

      final parsedMonth = int.tryParse(value.toString());

      if (parsedMonth != null && parsedMonth >= 1 && parsedMonth <= 12) {
        return parsedMonth;
      }
    }

    final dateKeys = [
      'DATE',
      'Date',
      'date',
      'CREATED_AT',
      'createdAt',
      'created_at',
      'UPDATED_AT',
      'updatedAt',
      'updated_at',
      'SURVEY_DATE',
      'survey_date',
      'PLANTING_DATE',
      'planting_date',
    ];

    for (final key in dateKeys) {
      final value = record[key];

      if (value == null) continue;

      if (value is DateTime) return value.month;

      final parsedDate = DateTime.tryParse(value.toString());

      if (parsedDate != null) {
        return parsedDate.month;
      }
    }

    return null;
  }

  int? _extractYear(Map<String, dynamic> record) {
    final yearKeys = [
      'YEAR',
      'Year',
      'year',
      'SURVEY_YEAR',
      'survey_year',
    ];

    for (final key in yearKeys) {
      final value = record[key];

      if (value is int) return value;

      if (value is num) return value.toInt();

      if (value is String) {
        final parsed = int.tryParse(value);

        if (parsed != null) return parsed;
      }
    }

    final dateKeys = [
      'DATE',
      'Date',
      'date',
      'CREATED_AT',
      'createdAt',
      'created_at',
      'UPDATED_AT',
      'updatedAt',
      'updated_at',
      'SURVEY_DATE',
      'survey_date',
      'PLANTING_DATE',
      'planting_date',
    ];

    for (final key in dateKeys) {
      final value = record[key];

      if (value == null) continue;

      if (value is DateTime) return value.year;

      final parsedDate = DateTime.tryParse(value.toString());

      if (parsedDate != null) {
        return parsedDate.year;
      }

      final yearMatch = RegExp(r'(20\d{2})').firstMatch(value.toString());

      if (yearMatch != null) {
        return int.tryParse(yearMatch.group(1)!);
      }
    }

    return null;
  }

  String _cellValueToString(dynamic value) {
    if (value == null) return '';

    if (value is Map || value is List) {
      return jsonEncode(value);
    }

    return value.toString();
  }

  void _search(String value) {
    final query = value.toLowerCase().trim();
    final isMobile = MediaQuery.of(context).size.width < 720;

    if (query.isEmpty) {
      setState(() {
        _tableRecords = _visibleRecords;

        _dataSource = DynamicCropDataSource(
          _tableRecords,
          _columns,
          _columnAliases,
          isMobile: isMobile,
        );
      });

      return;
    }

    final filtered = _visibleRecords.where((record) {
      return _columns.any((column) {
        if (column == '#') return false;

        final value = _valueForColumn(record, column, _columnAliases);

        return _cellValueToString(value).toLowerCase().contains(query);
      });
    }).toList();

    setState(() {
      _tableRecords = filtered;

      _dataSource = DynamicCropDataSource(
        _tableRecords,
        _columns,
        _columnAliases,
        isMobile: isMobile,
      );
    });
  }

  Future<void> _confirmAndDownloadCsv() async {
    if (_tableRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: darkSurface2,
          content: Text(
            'No data available to download.',
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        final isMobile = width < 560;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 24,
          ),
          child: SizedBox(
            width: isMobile ? width - 32 : 430,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 18 : 24),
              decoration: BoxDecoration(
                color: darkSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: darkBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: primaryGreen.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.download_rounded,
                          color: accentGreen,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Download CSV file?',
                              style: GoogleFonts.nunito(
                                fontSize: isMobile ? 20 : 22,
                                fontWeight: FontWeight.w900,
                                color: lightText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'The current filtered table data will be exported as a CSV file.',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                                color: mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: darkSurface2,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: darkBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.table_chart_rounded,
                          color: accentGreen,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Records to download',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: lightText,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: goldAccent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${_tableRecords.length}',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  if (isMobile)
                    Column(
                      children: [
                        _dialogDownloadButton(
                          onPressed: () => Navigator.pop(context, true),
                        ),
                        const SizedBox(height: 10),
                        _dialogCancelButton(
                          onPressed: () => Navigator.pop(context, false),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: _dialogCancelButton(
                            onPressed: () => Navigator.pop(context, false),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _dialogDownloadButton(
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      _downloadCurrentTableAsCsv();
    }
  }

  Widget _dialogCancelButton({
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: lightText,
          side: const BorderSide(
            color: darkBorder,
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Cancel',
          style: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _dialogDownloadButton({
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(
          Icons.file_download_done_rounded,
          size: 20,
          color: Colors.black,
        ),
        label: Text(
          'Download',
          style: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: goldAccent,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void _downloadCurrentTableAsCsv() {
    final csvContent = _buildCsvContent();

    final safeSeason = _safeFilePart(selectedSeason);
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');

    final fileName = 'cropbio_${selectedYear}_${safeSeason}_$timestamp.csv';

    final bytes = Uint8List.fromList(
      utf8.encode(csvContent),
    );

    final blob = web.Blob(
      <JSAny>[bytes.toJS].toJS,
      web.BlobPropertyBag(
        type: 'text/csv;charset=utf-8',
      ),
    );

    final url = web.URL.createObjectURL(blob);

    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName
      ..style.display = 'none';

    web.document.body?.appendChild(anchor);
    anchor.click();
    anchor.remove();

    web.URL.revokeObjectURL(url);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: darkSurface2,
        content: Text(
          'CSV downloaded: $fileName',
          style: GoogleFonts.nunito(
            color: lightText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String _buildCsvContent() {
    final exportColumns = _columns;
    final buffer = StringBuffer();

    buffer.writeln(
      exportColumns.map(_escapeCsvValue).join(','),
    );

    final totalRows = _tableRecords.length;

    for (var i = 0; i < _tableRecords.length; i++) {
      final record = _tableRecords[i];
      final rowNumber = totalRows - i;

      final row = exportColumns.map((column) {
        if (column == '#') {
          return _escapeCsvValue(rowNumber);
        }

        final value = _valueForColumn(record, column, _columnAliases);

        return _escapeCsvValue(_cellValueToString(value));
      }).join(',');

      buffer.writeln(row);
    }

    return buffer.toString();
  }

  String _escapeCsvValue(dynamic value) {
    final text = value?.toString() ?? '';
    final escaped = text.replaceAll('"', '""');

    if (escaped.contains(',') ||
        escaped.contains('"') ||
        escaped.contains('\n') ||
        escaped.contains('\r')) {
      return '"$escaped"';
    }

    return escaped;
  }

  String _safeFilePart(String value) {
    return value.replaceAll(RegExp(r'[^A-Za-z0-9_-]+'), '_');
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

  String get _selectedFilterLabel {
    if (selectedSeason == 'All') {
      return '$selectedYear';
    }

    return '$selectedYear • $selectedSeason';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWrapper(
      child: Builder(
        builder: (context) {
          final layout = context.watch<LayoutProvider>();

          return Theme(
            data: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: darkBg,
              colorScheme: const ColorScheme.dark(
                primary: primaryGreen,
                secondary: accentGreen,
                surface: darkSurface,
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
                        child: _sidePanel(
                          layout: layout,
                          isDrawer: true,
                        ),
                      ),
                    )
                  : null,
              body: SafeArea(
                child: layout.isMobile
                    ? _mobileLayout(layout)
                    : _desktopLayout(layout),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _desktopLayout(LayoutProvider layout) {
    return Row(
      children: [
        _sidePanel(layout: layout),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final targetWidth = layout.contentWidth > availableWidth
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
                        _titleBar(layout),
                        const SizedBox(height: 24),
                        Expanded(
                          child: _tableContainer(layout),
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

  Widget _mobileLayout(LayoutProvider layout) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: layout.verticalPadding,
      ),
      child: Column(
        children: [
          _titleBar(layout),
          const SizedBox(height: 12),
          Expanded(
            child: _tableContainer(layout),
          ),
        ],
      ),
    );
  }

  Widget _sidePanel({
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
          _cropBioLogo(layout),
          SizedBox(height: layout.isMobile ? 24 : 36),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FILTER BY YEAR',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: mutedText,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: layout.isMobile ? 190 : 210,
                    child: ListView.separated(
                      itemCount: years.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final year = years[index];
                        final isSelected = selectedYear == year;

                        return _filterTile(
                          selected: isSelected,
                          icon: Icons.calendar_month_rounded,
                          label: year.toString(),
                          onTap: () {
                            selectedYear = year;
                            _searchController.clear();
                            _loadData();

                            if (isDrawer) {
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'FILTER BY SEASON',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: mutedText,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _seasonSelector(isDrawer),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterTile({
    required bool selected,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: selected ? primaryGreen : darkSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? primaryGreen : darkBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : accentGreen,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : lightText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seasonSelector(bool isDrawer) {
    return Column(
      children: seasonOptions.map((season) {
        final isSelected = selectedSeason == season;

        final IconData icon;

        if (season == 'Wet Season') {
          icon = Icons.water_drop_rounded;
        } else if (season == 'Dry Season') {
          icon = Icons.wb_sunny_rounded;
        } else {
          icon = Icons.filter_alt_rounded;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _filterTile(
            selected: isSelected,
            icon: icon,
            label: season,
            onTap: () {
              selectedSeason = season;
              _searchController.clear();
              _loadData();

              if (isDrawer) {
                Navigator.pop(context);
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _titleBar(LayoutProvider layout) {
    if (layout.isMobile) {
      return _mobileTitleBar();
    }

    return _desktopTitleBar();
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
                color: Colors.black.withOpacity(0.24),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Open filters',
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
              IconButton(
                tooltip: 'Back',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minHeight: 38,
                  minWidth: 38,
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: lightText,
                  size: 22,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                height: 36,
                width: 36,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  "lib/Assets/Cropbio_clean.svg",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TABULATED RECORDS',
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
                      'Crop records for $_selectedFilterLabel',
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
                child: IconButton(
                  tooltip: 'Download CSV',
                  padding: EdgeInsets.zero,
                  onPressed: _confirmAndDownloadCsv,
                  icon: const Icon(
                    Icons.download_rounded,
                    color: goldAccent,
                    size: 22,
                  ),
                ),
              ),
              SizedBox(
                width: 36,
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
                  onSelected: (value) {
                    if (value == 'Refresh') {
                      loadCropSamples();
                    } else if (value == 'Download') {
                      _confirmAndDownloadCsv();
                    } else {
                      _showActionMessage(value);
                    }
                  },
                  itemBuilder: (context) => [
                    _darkPopupItem(
                      value: 'Refresh',
                      icon: Icons.refresh_rounded,
                      label: 'Refresh',
                    ),
                    _darkPopupItem(
                      value: 'Download',
                      icon: Icons.download_rounded,
                      label: 'Download',
                    ),
                    _darkPopupItem(
                      value: 'Print',
                      icon: Icons.print_rounded,
                      label: 'Print',
                    ),
                    _darkPopupItem(
                      value: 'Settings',
                      icon: Icons.settings_rounded,
                      label: 'Settings',
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
            color: Colors.black.withOpacity(0.28),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            color: lightText,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 10),
          Container(
            height: 46,
            width: 46,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SvgPicture.asset(
              "lib/Assets/Cropbio_clean.svg",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TABULATED RECORDS',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Crop records overview for $_selectedFilterLabel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
            onPressed: _confirmAndDownloadCsv,
            icon: const Icon(
              Icons.download_rounded,
              color: Colors.black,
            ),
            label: Text(
              'Download',
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: goldAccent,
              foregroundColor: Colors.black,
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
            onSelected: (value) {
              if (value == 'Refresh') {
                loadCropSamples();
              } else {
                _showActionMessage(value);
              }
            },
            itemBuilder: (context) => [
              _darkPopupItem(
                value: 'Refresh',
                icon: Icons.refresh_rounded,
                label: 'Refresh',
              ),
              _darkPopupItem(
                value: 'Print',
                icon: Icons.print_rounded,
                label: 'Print',
              ),
              _darkPopupItem(
                value: 'Settings',
                icon: Icons.settings_rounded,
                label: 'Settings',
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

  Widget _disclaimerBanner(LayoutProvider layout) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: layout.isMobile ? 12 : 16,
        vertical: layout.isMobile ? 12 : 14,
      ),
      decoration: BoxDecoration(
        color: goldAccent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: goldAccent.withOpacity(0.30),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: goldAccent,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Disclaimer: The crop data presented in this dashboard were gathered through laboratory testing and field sample analysis. Values should be interpreted as laboratory-derived measurements and may require further validation before use in official reporting, decision-making, or publication.',
              maxLines: layout.isMobile ? 4 : null,
              overflow:
                  layout.isMobile ? TextOverflow.ellipsis : TextOverflow.visible,
              style: GoogleFonts.nunito(
                color: lightText,
                fontSize: layout.isMobile ? 12 : 13.5,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cropBioLogo(LayoutProvider layout) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 14 : 16),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryGreen.withOpacity(0.35),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
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
                  color: Colors.black.withOpacity(0.18),
                ),
              ],
            ),
            child: SvgPicture.asset(
              "lib/Assets/Cropbio_clean.svg",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CropBio',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: layout.isMobile ? 19 : 21,
                    fontWeight: FontWeight.w900,
                    color: lightText,
                  ),
                ),
                Text(
                  'Data Dashboard',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

  Widget _tableContainer(LayoutProvider layout) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(layout.isMobile ? 12 : 24),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(layout.isMobile ? 18 : 24),
        border: Border.all(
          color: darkBorder,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.28),
          ),
        ],
      ),
      child: Column(
        children: [
          _tableHeader(layout),
          SizedBox(height: layout.isMobile ? 12 : 14),
          _disclaimerBanner(layout),
          SizedBox(height: layout.isMobile ? 14 : 22),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryGreen,
                    ),
                  )
                : _tableRecords.isEmpty
                    ? _emptyState(layout)
                    : _dataGrid(layout),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(LayoutProvider layout) {
    if (layout.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Crop Records",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _countBadge('${_tableRecords.length} records'),
              _countBadge('${_columns.length} columns'),
            ],
          ),
          const SizedBox(height: 10),
          _searchField(layout),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            "Crop Records",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _countBadge('${_tableRecords.length} records'),
        const SizedBox(width: 8),
        _countBadge('${_columns.length} columns'),
        const SizedBox(width: 12),
        SizedBox(
          width: 340,
          child: _searchField(layout),
        ),
      ],
    );
  }

  Widget _countBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withOpacity(0.30),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          color: lightText,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _searchField(LayoutProvider layout) {
    return TextField(
      controller: _searchController,
      onChanged: _search,
      style: GoogleFonts.nunito(
        color: lightText,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: lightText,
      decoration: InputDecoration(
        hintText: "Search any field...",
        hintStyle: GoogleFonts.nunito(
          color: mutedText,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: accentGreen,
        ),
        filled: true,
        fillColor: darkSurface2,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: layout.isMobile ? 12 : 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(layout.isMobile ? 14 : 16),
          borderSide: const BorderSide(
            color: darkBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(layout.isMobile ? 14 : 16),
          borderSide: const BorderSide(
            color: primaryGreen,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  String _formatColumnName(String column) {
    if (column == '#') return '#';

    const displayNames = {
      '_id': 'ID',
      'CODE': 'Code',
      'CROP_TYPE': 'Crop Type',
      'FIELD': 'Field',
      'PLOT': 'Plot',
      'PLANT_SAMPLE': 'Plant Sample',
      'FRESH_WEIGHT': 'Fresh Weight',
      'DRY_WEIGHT': 'Dry Weight',
      'Average_Leaf_Area': 'Average Leaf Area',
      'Corrected_Leaf_Area_(CF=0.75)': 'Corrected Leaf Area (CF=0.75)',
      'SPAD__values': 'SPAD Values',
      'Chloropyll__Value_(mg/m2)': 'Chlorophyll Value (mg/m²)',
      'chl-a': 'Chl-a',
      'chl-b': 'Chl-b',
      'carotenoid': 'Carotenoid',
      'Leaf_Dry_Matter_Content_(LDMC)': 'Leaf Dry Matter Content (LDMC)',
      'Leaf_Water_Concentration': 'Leaf Water Concentration',
      'Equivalent_Water_Thickness_(EWT)': 'Equivalent Water Thickness (EWT)',
      'Specific_Leaf_Area_(cm2/g)': 'Specific Leaf Area (cm²/g)',
      'Cap_Cover': 'Canopy Cover',
      'LAI': 'LAI',
      'DIFN': 'DIFN',
      'MTA': 'MTA',
      'SEM': 'SEM',
      'SMP': 'SMP',
      'SEL': 'SEL',
      'Plant_Height': 'Plant Height',
      'Length': 'Length',
      'Width': 'Width',
      'Plant': 'Plant Spacing',
      'Row': 'Row Spacing',
      'Type': 'Soil Type',
      'Moisture': 'Soil Moisture',
      'Temperature': 'Soil Temperature',
      'year': 'Year',
      'season': 'Season',
      'source_collection': 'Source Collection',
    };

    if (displayNames.containsKey(column)) {
      return displayNames[column]!;
    }

    return column
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  double _columnWidth(String column, bool isMobile) {
    if (column == '#') return 70;

    final title = _formatColumnName(column);
    final lowerTitle = title.toLowerCase();
    final int length = title.length;

    final double baseWidth = isMobile ? 145 : 165;
    final double widthFromText = length * (isMobile ? 7.4 : 7.9);
    final double computedWidth = widthFromText + 48;

    if (lowerTitle.contains('source collection')) {
      return isMobile ? 220 : 250;
    }

    if (lowerTitle.contains('corrected leaf area')) {
      return isMobile ? 240 : 270;
    }

    if (lowerTitle.contains('specific leaf area')) {
      return isMobile ? 230 : 260;
    }

    if (lowerTitle.contains('equivalent water thickness')) {
      return isMobile ? 255 : 285;
    }

    if (lowerTitle.contains('leaf dry matter')) {
      return isMobile ? 250 : 280;
    }

    if (lowerTitle.contains('leaf water concentration')) {
      return isMobile ? 245 : 275;
    }

    if (lowerTitle.contains('chlorophyll value')) {
      return isMobile ? 225 : 255;
    }

    if (lowerTitle.contains('average leaf area')) {
      return isMobile ? 205 : 230;
    }

    if (lowerTitle.contains('soil temperature')) {
      return isMobile ? 195 : 220;
    }

    if (lowerTitle.contains('soil moisture')) {
      return isMobile ? 190 : 215;
    }

    if (lowerTitle.contains('plant height')) {
      return isMobile ? 180 : 205;
    }

    if (lowerTitle.contains('plant spacing') ||
        lowerTitle.contains('row spacing')) {
      return isMobile ? 185 : 210;
    }

    return computedWidth.clamp(baseWidth, isMobile ? 250 : 290);
  }

  Widget _dataGrid(LayoutProvider layout) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(accentGreen),
        trackColor: WidgetStateProperty.all(darkSurface2),
        trackBorderColor: WidgetStateProperty.all(darkBorder),
        thickness: WidgetStateProperty.all(8),
        radius: const Radius.circular(999),
      ),
      child: Scrollbar(
        controller: _verticalGridScrollController,
        thumbVisibility: true,
        trackVisibility: true,
        notificationPredicate: (notification) {
          return notification.metrics.axis == Axis.vertical;
        },
        child: Scrollbar(
          controller: _horizontalGridScrollController,
          thumbVisibility: true,
          trackVisibility: true,
          notificationPredicate: (notification) {
            return notification.metrics.axis == Axis.horizontal;
          },
          child: Padding(
            padding: const EdgeInsets.only(
              right: 14,
              bottom: 14,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: darkSurface2,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: darkBorder,
                  ),
                ),
                child: SfDataGrid(
                  source: _dataSource,
                  controller: _controller,
                  verticalScrollController: _verticalGridScrollController,
                  horizontalScrollController: _horizontalGridScrollController,
                  editingGestureType: EditingGestureType.tap,
                  allowSorting: true,
                  allowFiltering: true,
                  allowMultiColumnSorting: true,
                  allowColumnsResizing: true,
                  allowEditing: false,
                  selectionMode: SelectionMode.single,
                  navigationMode: GridNavigationMode.cell,
                  showVerticalScrollbar: false,
                  showHorizontalScrollbar: false,
                  columnWidthMode: ColumnWidthMode.none,
                  headerRowHeight: layout.isMobile ? 72 : 78,
                  rowHeight: layout.isMobile ? 54 : 52,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columns: _columns.map((column) {
                    return GridColumn(
                      columnName: column,
                      width: _columnWidth(column, layout.isMobile),
                      label: _header(
                        _formatColumnName(column),
                        isMobile: layout.isMobile,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(
    String title, {
    required bool isMobile,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 12,
        vertical: isMobile ? 8 : 10,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            darkSurface3,
            primaryGreen,
          ],
        ),
      ),
      child: Text(
        title,
        softWrap: true,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: isMobile ? 11.5 : 13,
          height: 1.12,
        ),
      ),
    );
  }

  Widget _emptyState(LayoutProvider layout) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(layout.isMobile ? 20 : 28),
        decoration: BoxDecoration(
          color: darkSurface2,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: darkBorder,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: layout.isMobile ? 54 : 64,
              color: accentGreen.withOpacity(0.55),
            ),
            const SizedBox(height: 14),
            Text(
              'No records found',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: layout.isMobile ? 16 : 18,
                fontWeight: FontWeight.w800,
                color: lightText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'There are no crop records available for $_selectedFilterLabel.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: mutedText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicCropDataSource extends DataGridSource {
  final List<String> columns;
  final Map<String, List<String>> columnAliases;
  final bool isMobile;

  late final List<DataGridRow> _rows;

  DynamicCropDataSource(
    List<Map<String, dynamic>> records,
    this.columns,
    this.columnAliases, {
    required this.isMobile,
  }) {
    final totalRows = records.length;

    _rows = records.asMap().entries.map((entry) {
      final index = entry.key;
      final record = entry.value;

      final descendingRowNumber = totalRows - index;

      return DataGridRow(
        cells: columns.map((column) {
          final value = column == '#'
              ? descendingRowNumber
              : _valueForColumn(record, column);

          return DataGridCell<String>(
            columnName: column,
            value: _formatCellValue(value),
          );
        }).toList(),
      );
    }).toList();
  }

  dynamic _valueForColumn(
    Map<String, dynamic> record,
    String column,
  ) {
    if (record.containsKey(column) && record[column] != null) {
      return record[column];
    }

    final possibleKeys = columnAliases[column] ?? [];

    for (final key in possibleKeys) {
      if (record.containsKey(key) && record[key] != null) {
        return record[key];
      }
    }

    if (record.containsKey(column)) {
      return record[column];
    }

    return null;
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: const Color(0xFF162216),
      cells: row.getCells().map((cell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 12,
            vertical: isMobile ? 8 : 10,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF2E3E31),
                width: 0.6,
              ),
            ),
          ),
          child: Text(
            cell.value?.toString() ?? '',
            maxLines: isMobile ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: isMobile ? 11.5 : 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF3F7F1),
              height: 1.18,
            ),
          ),
        );
      }).toList(),
    );
  }

  static String _formatCellValue(dynamic value) {
    if (value == null) return '';

    if (value is Map || value is List) {
      return jsonEncode(value);
    }

    return value.toString();
  }
}

class ColumnBuildResult {
  final List<String> columns;
  final Map<String, List<String>> aliases;

  ColumnBuildResult({
    required this.columns,
    required this.aliases,
  });
}