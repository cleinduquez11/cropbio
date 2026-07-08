import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:cropbio/API/fetchAll.dart';
import 'package:cropbio/Configs/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
  static const Color darkGreen = Color(0xFF1E2E1E);
  static const Color mediumGreen = Color(0xFF2F4F2F);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color lightBg = Color(0xFFF4F6F1);
  static const Color softBg = Color(0xFFF8F9F6);
  static const Color cardBg = Colors.white;

  static const Color darkText = Color(0xFF1F2933);
  static const Color mutedText = Color(0xFF5F6B5A);
  static const Color borderGreen = Color(0xFFDDE7D5);

  late DynamicCropDataSource _dataSource;

  final DataGridController _controller = DataGridController();
  final TextEditingController _searchController = TextEditingController();

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
    _dataSource = DynamicCropDataSource([], _columns, _columnAliases);

    loadCropSamples();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
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
        _dataSource = DynamicCropDataSource([], _columns, _columnAliases);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: darkGreen,
          content: Text('Failed to load crop samples: $e'),
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

    setState(() {
      _visibleRecords = filteredRecords;
      _tableRecords = filteredRecords;
      _columns = columnBuildResult.columns;
      _columnAliases = columnBuildResult.aliases;

      _dataSource = DynamicCropDataSource(
        _tableRecords,
        _columns,
        _columnAliases,
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

    if (query.isEmpty) {
      setState(() {
        _tableRecords = _visibleRecords;

        _dataSource = DynamicCropDataSource(
          _tableRecords,
          _columns,
          _columnAliases,
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
      );
    });
  }

  Future<void> _confirmAndDownloadCsv() async {
    if (_tableRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: darkGreen,
          content: Text('No data available to download.'),
        ),
      );

      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: 430,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: borderGreen,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
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
                        color: primaryGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.download_rounded,
                        color: primaryGreen,
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
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: darkText,
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
                    color: lightBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: borderGreen,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.table_chart_rounded,
                        color: primaryGreen,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Records to download',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: darkText,
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
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: darkText,
                          side: const BorderSide(
                            color: borderGreen,
                            width: 1.2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
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
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context, true),
                        icon: const Icon(
                          Icons.file_download_done_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Download',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      _downloadCurrentTableAsCsv();
    }
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
        backgroundColor: darkGreen,
        content: Text('CSV downloaded: $fileName'),
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
        backgroundColor: darkGreen,
        content: Text('$action action triggered.'),
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
    return Scaffold(
      backgroundColor: lightBg,
      body: SafeArea(
        child: Row(
          children: [
            _sidePanel(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    _titleBar(context),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _tableContainer(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sidePanel() {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: const BoxDecoration(
        color: softBg,
        border: Border(
          right: BorderSide(
            color: borderGreen,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cropBioLogo(),
          const SizedBox(height: 32),
          const SizedBox(height: 36),
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
            height: 190,
            child: ListView.separated(
              itemCount: years.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final year = years[index];
                final isSelected = selectedYear == year;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    selectedYear = year;
                    _searchController.clear();
                    _loadData();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryGreen : cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? primaryGreen : borderGreen,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: isSelected ? Colors.white : primaryGreen,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          year.toString(),
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
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
          _seasonSelector(),
        ],
      ),
    );
  }

  Widget _seasonSelector() {
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
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              selectedSeason = season;
              _searchController.clear();
              _loadData();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: isSelected ? darkGreen : cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? darkGreen : borderGreen,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected ? Colors.white : primaryGreen,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    season,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : darkText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _titleBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderGreen,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            color: darkGreen,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TABULATED RECORDS',
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Crop records overview for $_selectedFilterLabel',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: mutedText,
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
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: goldAccent,
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(width: 10),
          PopupMenuButton<String>(
            tooltip: 'More options',
            icon: const Icon(
              Icons.more_vert_rounded,
              color: darkGreen,
            ),
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
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'Refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded),
                    SizedBox(width: 10),
                    Text('Refresh'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Print',
                child: Row(
                  children: [
                    Icon(Icons.print_rounded),
                    SizedBox(width: 10),
                    Text('Print'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_rounded),
                    SizedBox(width: 10),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _disclaimerBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: goldAccent.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF946200),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Disclaimer: The crop data presented in this dashboard were gathered through laboratory testing and field sample analysis. Values should be interpreted as laboratory-derived measurements and may require further validation before use in official reporting, decision-making, or publication.',
              style: GoogleFonts.nunito(
                color: const Color(0xFF5D4037),
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cropBioLogo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primaryGreen.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                  color: Colors.black.withValues(alpha: 0.08),
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
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: darkText,
                  ),
                ),
                Text(
                  'Data Dashboard',
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

  Widget _tableContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderGreen,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Crop Records",
                style: GoogleFonts.nunito(
                  color: darkText,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: primaryGreen.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: primaryGreen.withValues(alpha: 0.18),
                  ),
                ),
                child: Text(
                  '${_tableRecords.length} records',
                  style: GoogleFonts.nunito(
                    color: primaryGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _searchController,
                  onChanged: _search,
                  decoration: InputDecoration(
                    hintText: "Search any field...",
                    hintStyle: GoogleFonts.nunito(
                      color: mutedText,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: primaryGreen,
                    ),
                    filled: true,
                    fillColor: softBg,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: borderGreen,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: primaryGreen,
                        width: 1.4,
                      ),
                    ),
                  ),
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  cursorColor: primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _disclaimerBanner(),
          const SizedBox(height: 22),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryGreen,
                    ),
                  )
                : _tableRecords.isEmpty
                    ? _emptyState()
                    : _dataGrid(),
          ),
        ],
      ),
    );
  }

  String _formatColumnName(String column) {
    if (column == '#') return '#';

    return column.replaceAll('_', ' ');
  }

  Widget _dataGrid() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(scrollbars: false),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(darkGreen),
            thickness: WidgetStateProperty.all(8),
            radius: const Radius.circular(4),
          ),
          child: SfDataGrid(
            source: _dataSource,
            controller: _controller,
            editingGestureType: EditingGestureType.tap,
            allowSorting: true,
            allowFiltering: true,
            allowMultiColumnSorting: true,
            allowColumnsResizing: true,
            showVerticalScrollbar: true,
            showHorizontalScrollbar: true,
            allowEditing: false,
            selectionMode: SelectionMode.single,
            navigationMode: GridNavigationMode.cell,
            isScrollbarAlwaysShown: true,
            columnWidthMode: ColumnWidthMode.auto,
            columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            columns: _columns.map((column) {
              return GridColumn(
                columnName: column,
                width: column == '#' ? 70 : 180,
                label: _header(_formatColumnName(column)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _header(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            darkGreen,
            mediumGreen,
          ],
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: softBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: borderGreen,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64,
              color: primaryGreen.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 14),
            Text(
              'No records found',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: darkText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'There are no crop records available for $_selectedFilterLabel.',
              style: GoogleFonts.nunito(
                color: mutedText,
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
  late final List<DataGridRow> _rows;

  DynamicCropDataSource(
    List<Map<String, dynamic>> records,
    this.columns,
    this.columnAliases,
  ) {
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
      color: Colors.white,
      cells: row.getCells().map((cell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Text(
            cell.value?.toString() ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF243024),
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