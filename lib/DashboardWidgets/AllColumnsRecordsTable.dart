import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AllColumnsRecordsTable extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> records;
  final bool loading;

  const AllColumnsRecordsTable({
    super.key,
    required this.title,
    required this.records,
    required this.loading,
  });

  @override
  State<AllColumnsRecordsTable> createState() => _AllColumnsRecordsTableState();
}

class _AllColumnsRecordsTableState extends State<AllColumnsRecordsTable> {
  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color darkGreen = Color(0xFF1E2E1E);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _cleanRows = [];
  List<Map<String, dynamic>> _filteredRows = [];
  List<String> _columns = [];

  late _AllColumnsDataSource _dataSource;

  @override
  void initState() {
    super.initState();

    _dataSource = _AllColumnsDataSource(
      rows: const [],
      columns: const [],
    );

    _prepareRows();
  }

  @override
  void didUpdateWidget(covariant AllColumnsRecordsTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.records != widget.records ||
        oldWidget.loading != widget.loading) {
      _prepareRows();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _prepareRows() {
    _cleanRows = widget.records.map((record) {
      return _cleanAndDeduplicateRecord(record);
    }).toList();

    _columns = _buildColumns(_cleanRows);

    _applySearch(
      _searchController.text,
      refreshState: false,
    );

    if (mounted) {
      setState(() {});
    }
  }

  Map<String, dynamic> _cleanAndDeduplicateRecord(
    Map<String, dynamic> record,
  ) {
    final Map<String, dynamic> output = {};

    record.forEach((key, value) {
      if (key == 'plot_info') {
        if (value is Map<String, dynamic>) {
          _mergeNestedPlotInfo(output, value);
        } else if (value is Map) {
          _mergeNestedPlotInfo(
            output,
            Map<String, dynamic>.from(value),
          );
        }
      } else {
        final cleanKey = _canonicalColumnName(key);
        _putValue(output, cleanKey, value);
      }
    });

    return output;
  }

  void _mergeNestedPlotInfo(
    Map<String, dynamic> output,
    Map<String, dynamic> plotInfo,
  ) {
    plotInfo.forEach((key, value) {
      final cleanKey = _canonicalColumnName(key);
      _putValue(output, cleanKey, value);
    });
  }

  String _canonicalColumnName(String key) {
    final trimmed = key.trim();

    final normalized = trimmed
        .replaceAll('-', '_')
        .replaceAll(' ', '_')
        .replaceAll('.', '_')
        .toLowerCase();

    switch (normalized) {
      case 'code':
        return 'CODE';

      case 'crop':
      case 'crop_type':
        return 'CROP_TYPE';

      case 'field':
        return 'FIELD';

      case 'plot':
        return 'PLOT';

      case 'plant_sample':
      case 'plantsample':
        return 'PLANT_SAMPLE';

      case 'season':
        return 'SEASON';

      case 'year':
        return 'YEAR';

      case 'source_collection':
        return 'SOURCE_COLLECTION';

      case 'fresh_weight':
      case 'freshweight':
        return 'FRESH_WEIGHT';

      case 'dry_weight':
      case 'dryweight':
        return 'DRY_WEIGHT';

      case 'average_leaf_area':
        return 'AVERAGE_LEAF_AREA';

      case 'corrected_leaf_area_(cf=0_75)':
      case 'corrected_leaf_area_(cf=0.75)':
      case 'corrected_leaf_area':
        return 'CORRECTED_LEAF_AREA';

      case 'spad__values':
      case 'spad_values':
      case 'spad':
        return 'SPAD';

      case 'chl_a':
      case 'chla':
        return 'CHL_A';

      case 'chl_b':
      case 'chlb':
        return 'CHL_B';

      case 'caretenoid':
      case 'carotenoid':
        return 'CAROTENOID';

      case 'chloropyll_val':
      case 'chloropyll__value_(mg/m2)':
      case 'chlorophyll_value':
      case 'chlorophyll__value_(mg/m2)':
        return 'CHLOROPHYLL_VALUE';

      case 'ldmc':
      case 'leaf_dry_matter_content_(ldmc)':
      case 'leaf_dry_matter_content':
        return 'LDMC';

      case 'leaf_water_concentration':
        return 'LEAF_WATER_CONCENTRATION';

      case 'equivalent_water_thickness_(ewt)':
      case 'equivalent_water_thickness':
      case 'ewt':
        return 'EWT';

      case 'specific_leaf_area_(cm2/g)':
      case 'specific_leaf_area':
        return 'SPECIFIC_LEAF_AREA';

      case 'lai':
        return 'LAI';

      case 'difn':
        return 'DIFN';

      case 'mta':
        return 'MTA';

      case 'sem':
        return 'SEM';

      case 'smp':
        return 'SMP';

      case 'sel':
        return 'SEL';

      case 'lat':
      case 'latitude':
        return 'LAT';

      case 'lon':
      case 'longitude':
        return 'LON';

      case 'plant_height':
        return 'PLANT_HEIGHT';

      case 'plant':
      case 'plant_spacing':
        return 'PLANT_SPACING';

      case 'row':
      case 'row_spacing':
        return 'ROW_SPACING';

      case 'temperature':
      case 'soil_temperature':
        return 'SOIL_TEMPERATURE';

      case 'moisture':
      case 'soil_moisture':
        return 'SOIL_MOISTURE';

      case 'type':
      case 'soil_type':
        return 'SOIL_TYPE';

      case 'length':
        return 'LENGTH';

      case 'width':
        return 'WIDTH';

      case '_id':
        return '_ID';

      default:
        return trimmed.toUpperCase();
    }
  }

  void _putValue(
    Map<String, dynamic> output,
    String key,
    dynamic value,
  ) {
    final existingValue = output[key];

    final existingMissing = _isMissing(existingValue);
    final newMissing = _isMissing(value);

    if (existingMissing && !newMissing) {
      output[key] = value;
      return;
    }

    if (!output.containsKey(key)) {
      output[key] = value;
    }
  }

  bool _isMissing(dynamic value) {
    if (value == null) return true;

    final text = value.toString().trim();

    return text.isEmpty || text.toLowerCase() == 'null';
  }

  List<String> _buildColumns(List<Map<String, dynamic>> rows) {
    final Set<String> columnSet = {};

    for (final row in rows) {
      columnSet.addAll(row.keys);
    }

    final priorityColumns = [
      'CODE',
      'CROP_TYPE',
      'FIELD',
      'PLOT',
      'PLANT_SAMPLE',
      'SEASON',
      'YEAR',
      'SOURCE_COLLECTION',
      'FRESH_WEIGHT',
      'DRY_WEIGHT',
      'AVERAGE_LEAF_AREA',
      'CORRECTED_LEAF_AREA',
      'SPAD',
      'CHL_A',
      'CHL_B',
      'CAROTENOID',
      'CHLOROPHYLL_VALUE',
      'LDMC',
      'LEAF_WATER_CONCENTRATION',
      'EWT',
      'SPECIFIC_LEAF_AREA',
      'LAI',
      'DIFN',
      'MTA',
      'SEM',
      'SMP',
      'SEL',
      'LAT',
      'LON',
      'PLANT_HEIGHT',
      'PLANT_SPACING',
      'ROW_SPACING',
      'SOIL_MOISTURE',
      'SOIL_TEMPERATURE',
      'SOIL_TYPE',
      'LENGTH',
      'WIDTH',
      '_ID',
    ];

    final orderedColumns = <String>[];

    for (final column in priorityColumns) {
      if (columnSet.contains(column)) {
        orderedColumns.add(column);
        columnSet.remove(column);
      }
    }

    final remainingColumns = columnSet.toList()..sort();

    orderedColumns.addAll(remainingColumns);

    return orderedColumns;
  }

  void _applySearch(
    String value, {
    bool refreshState = true,
  }) {
    final query = value.toLowerCase().trim();

    if (query.isEmpty) {
      _filteredRows = List<Map<String, dynamic>>.from(_cleanRows);
    } else {
      _filteredRows = _cleanRows.where((row) {
        return row.values.any((value) {
          if (value == null) return false;

          return value.toString().toLowerCase().contains(query);
        });
      }).toList();
    }

    _dataSource = _AllColumnsDataSource(
      rows: _filteredRows,
      columns: _columns,
    );

    if (refreshState && mounted) {
      setState(() {});
    }
  }

  double _columnWidth(String columnName) {
    final label = _displayColumnName(columnName);

    final estimatedWidth = (label.length * 9.5) + 56;

    if (estimatedWidth < 150) return 150;
    if (estimatedWidth > 360) return 360;

    return estimatedWidth;
  }

  String _displayColumnName(String columnName) {
    switch (columnName) {
      case '_ID':
        return 'ID';
      case 'CODE':
        return 'Code';
      case 'CROP_TYPE':
        return 'Crop Type';
      case 'FIELD':
        return 'Field';
      case 'PLOT':
        return 'Plot';
      case 'PLANT_SAMPLE':
        return 'Plant Sample';
      case 'SEASON':
        return 'Season';
      case 'YEAR':
        return 'Year';
      case 'SOURCE_COLLECTION':
        return 'Source Collection';
      case 'FRESH_WEIGHT':
        return 'Fresh Weight';
      case 'DRY_WEIGHT':
        return 'Dry Weight';
      case 'AVERAGE_LEAF_AREA':
        return 'Average Leaf Area';
      case 'CORRECTED_LEAF_AREA':
        return 'Corrected Leaf Area';
      case 'SPAD':
        return 'SPAD';
      case 'CHL_A':
        return 'Chl A';
      case 'CHL_B':
        return 'Chl B';
      case 'CAROTENOID':
        return 'Carotenoid';
      case 'CHLOROPHYLL_VALUE':
        return 'Chlorophyll Value';
      case 'LDMC':
        return 'LDMC';
      case 'LEAF_WATER_CONCENTRATION':
        return 'Leaf Water Concentration';
      case 'EWT':
        return 'Equivalent Water Thickness';
      case 'SPECIFIC_LEAF_AREA':
        return 'Specific Leaf Area';
      case 'LAI':
        return 'LAI';
      case 'DIFN':
        return 'DIFN';
      case 'MTA':
        return 'MTA';
      case 'SEM':
        return 'SEM';
      case 'SMP':
        return 'SMP';
      case 'SEL':
        return 'SEL';
      case 'LAT':
        return 'Lat';
      case 'LON':
        return 'Lon';
      case 'PLANT_HEIGHT':
        return 'Plant Height';
      case 'PLANT_SPACING':
        return 'Plant Spacing';
      case 'ROW_SPACING':
        return 'Row Spacing';
      case 'SOIL_MOISTURE':
        return 'Soil Moisture';
      case 'SOIL_TEMPERATURE':
        return 'Soil Temperature';
      case 'SOIL_TYPE':
        return 'Soil Type';
      case 'LENGTH':
        return 'Length';
      case 'WIDTH':
        return 'Width';
      default:
        return columnName
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) {
              if (word.isEmpty) return word;
              return word[0].toUpperCase() + word.substring(1).toLowerCase();
            })
            .join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkSurface,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _tableHeader(),
          const SizedBox(height: 18),
          Expanded(
            child: widget.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryGreen,
                    ),
                  )
                : _filteredRows.isEmpty
                    ? _emptyState()
                    : _dataGrid(),
          ),
        ],
      ),
    );
  }

Widget _tableHeader() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final bool compact = constraints.maxWidth < 720;

      if (compact) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
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
                _countBadge('${_filteredRows.length} rows'),
                _countBadge('${_columns.length} columns'),
              ],
            ),
            const SizedBox(height: 10),
            _searchField(),
          ],
        );
      }

      return Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
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
          _countBadge('${_filteredRows.length} rows'),
          const SizedBox(width: 8),
          _countBadge('${_columns.length} columns'),
          const SizedBox(width: 12),
          SizedBox(
            width: constraints.maxWidth < 980 ? 260 : 340,
            child: _searchField(),
          ),
        ],
      );
    },
  );
}

Widget _searchField() {
  return TextField(
    controller: _searchController,
    onChanged: _applySearch,
    style: GoogleFonts.nunito(
      color: lightText,
      fontWeight: FontWeight.w600,
    ),
    cursorColor: lightText,
    decoration: InputDecoration(
      hintText: "Search all columns...",
      hintStyle: GoogleFonts.nunito(
        color: mutedText,
      ),
      prefixIcon: const Icon(
        Icons.search_rounded,
        color: primaryGreen,
      ),
      filled: true,
      fillColor: darkSurface2,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: darkBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: primaryGreen,
          width: 1.5,
        ),
      ),
    ),
  );
}
  Widget _countBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: primaryGreen.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: primaryGreen.withValues(alpha: 0.30),
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

  Widget _dataGrid() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SfDataGrid(
        source: _dataSource,
        allowSorting: true,
        allowFiltering: true,
        allowMultiColumnSorting: true,
        showVerticalScrollbar: true,
        showHorizontalScrollbar: true,
        isScrollbarAlwaysShown: true,
        columnWidthMode: ColumnWidthMode.none,
        headerRowHeight: 76,
        rowHeight: 48,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columns: _columns.map((column) {
          return GridColumn(
            columnName: column,
            width: _columnWidth(column),
            label: _header(column),
          );
        }).toList(),
      ),
    );
  }

  Widget _header(String columnName) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      color: darkGreen,
      child: Text(
        _displayColumnName(columnName),
        softWrap: true,
        maxLines: 3,
        overflow: TextOverflow.visible,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 13,
          height: 1.15,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.table_rows_rounded,
            size: 64,
            color: mutedText.withValues(alpha: 0.50),
          ),
          const SizedBox(height: 14),
          Text(
            'No records found',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: lightText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'There are no rows available for this table.',
            style: GoogleFonts.nunito(
              color: mutedText,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllColumnsDataSource extends DataGridSource {
  final List<Map<String, dynamic>> rowsData;
  final List<String> columnsData;

  late final List<DataGridRow> _rows;

  _AllColumnsDataSource({
    required List<Map<String, dynamic>> rows,
    required List<String> columns,
  })  : rowsData = rows,
        columnsData = columns {
    _rows = rowsData.map<DataGridRow>((record) {
      return DataGridRow(
        cells: columnsData.map<DataGridCell<String>>((column) {
          return DataGridCell<String>(
            columnName: column,
            value: _formatValue(record[column]),
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  static String _formatValue(dynamic value) {
    if (value == null) return '—';

    if (value is num) {
      return value.toString();
    }

    if (value is bool) {
      return value ? 'Yes' : 'No';
    }

    final text = value.toString().trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return '—';
    }

    return text;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: const Color(0xFF162216),
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF2E3E31),
                width: 0.5,
              ),
            ),
          ),
          child: Text(
            cell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: const Color(0xFFF3F7F1),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}