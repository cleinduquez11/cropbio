import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cropbio/API/UploadCsv.dart';
import 'package:cropbio/Widgets/CustomSnackbar.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadSection extends StatefulWidget {
  const UploadSection({super.key});

  @override
  State<UploadSection> createState() => _UploadSectionState();
}

class _UploadSectionState extends State<UploadSection> {
  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color gold = Color(0xFFC6A432);
  static const Color dangerRed = Color(0xFFC64632);

  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  List<List<String>> csvData = [];
  PlatformFile? pickedFile;
  String sendType = "";

  bool _isPickingFile = false;

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  Future<void> pickCsvFile() async {
    await pickDataFile();
  }

  Future<void> pickDataFile() async {
    if (_isPickingFile) return;

    setState(() {
      _isPickingFile = true;
    });

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
        withData: true,
      );

      if (result == null || result.files.single.bytes == null) {
        if (!mounted) return;

        CustomSnackBar.show(
          context,
          message: "No file selected",
          backgroundColor: Colors.orange,
          icon: Icons.warning_rounded,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );

        return;
      }

      final file = result.files.single;
      final bytes = file.bytes!;
      final extension = _fileExtension(file.name);

      final List<List<String>> parsedData;

      if (extension == "csv") {
        parsedData = _parseCsvBytes(bytes);
      } else if (extension == "xlsx" || extension == "xls") {
        parsedData = _parseExcelBytes(bytes);
      } else {
        if (!mounted) return;

        CustomSnackBar.show(
          context,
          message: "Please select a CSV or Excel file.",
          backgroundColor: Colors.orange,
          icon: Icons.warning_rounded,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );

        return;
      }

      if (parsedData.isEmpty) {
        if (!mounted) return;

        CustomSnackBar.show(
          context,
          message: "The selected file is empty",
          backgroundColor: Colors.orange,
          icon: Icons.warning_rounded,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );

        return;
      }

      setState(() {
        pickedFile = file;
        csvData = parsedData;
        sendType = "generic";
      });

      debugPrint("Flexible upload file selected: ${file.name}");
      debugPrint("Columns detected: ${csvData.first.length}");
      debugPrint("Rows detected: ${csvData.length > 1 ? csvData.length - 1 : 0}");
    } catch (e) {
      if (!mounted) return;

      CustomSnackBar.show(
        context,
        message: "Failed to read file: $e",
        backgroundColor: Colors.red,
        icon: Icons.error_outline_rounded,
        bottomMargin: 40,
        leftMarginFactor: 0.8,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingFile = false;
        });
      }
    }
  }

  String _fileExtension(String fileName) {
    final parts = fileName.split(".");
    if (parts.length < 2) return "";

    return parts.last.trim().toLowerCase();
  }

  List<List<String>> _parseCsvBytes(List<int> bytes) {
    final csvString = utf8.decode(bytes, allowMalformed: true);
    final fields = const CsvToListConverter(
      shouldParseNumbers: false,
    ).convert(csvString);

    final rows = fields
        .map((row) => row.map((value) => value.toString()).toList())
        .toList();

    return _normalizeTableRows(rows);
  }

  List<List<String>> _parseExcelBytes(List<int> bytes) {
    final workbook = excel.Excel.decodeBytes(bytes);

    if (workbook.tables.isEmpty) {
      return [];
    }

    final sheet = workbook.tables.values.firstWhere(
      (table) => table.rows.isNotEmpty,
      orElse: () => workbook.tables.values.first,
    );

    final rows = sheet.rows.map((row) {
      return row.map((cell) {
        final value = cell?.value;
        if (value == null) return "";

        return value.toString();
      }).toList();
    }).toList();

    return _normalizeTableRows(rows);
  }

  List<List<String>> _normalizeTableRows(List<List<String>> rows) {
    final cleanedRows = rows
        .map((row) => row.map((cell) => cell.trim()).toList())
        .where((row) => row.any((cell) => cell.isNotEmpty))
        .toList();

    if (cleanedRows.isEmpty) {
      return [];
    }

    final maxColumns = cleanedRows
        .map((row) => row.length)
        .fold<int>(0, (previous, current) => current > previous ? current : previous);

    if (maxColumns == 0) {
      return [];
    }

    final normalizedRows = cleanedRows.map((row) {
      final normalized = List<String>.from(row);

      while (normalized.length < maxColumns) {
        normalized.add("");
      }

      return normalized;
    }).toList();

    final header = normalizedRows.first;
    final headerCounts = <String, int>{};

    for (int i = 0; i < header.length; i++) {
      var columnName = header[i].trim();

      if (columnName.isEmpty) {
        columnName = "Column ${i + 1}";
      }

      final normalizedKey = columnName.toLowerCase();
      final count = headerCounts[normalizedKey] ?? 0;
      headerCounts[normalizedKey] = count + 1;

      if (count > 0) {
        columnName = "$columnName ${count + 1}";
      }

      header[i] = columnName;
    }

    return normalizedRows;
  }

  Uint8List _bytesForUpload() {
    final csvString = const ListToCsvConverter().convert(csvData);
    return Uint8List.fromList(utf8.encode(csvString));
  }

  String _fileNameForUpload() {
    final originalName = pickedFile?.name ?? "uploaded_data";
    final dotIndex = originalName.lastIndexOf(".");
    final baseName = dotIndex > 0 ? originalName.substring(0, dotIndex) : originalName;

    return "${baseName}_flexible_upload.csv";
  }

  String _detectCsvType(List<List<String>> data) {
    if (data.isEmpty) return "none";

    return "generic";
  }

  String _normalizeHeader(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  void _clearSelection() {
    setState(() {
      csvData = [];
      pickedFile = null;
      sendType = "";
    });
  }

  String get _uploadDestinationLabel {
    return "Flexible Data Collection";
  }

  Color get _uploadDestinationColor {
    return primaryGreen;
  }

  IconData get _uploadDestinationIcon {
    return Icons.dataset_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 720;

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: darkSurface,
          padding: EdgeInsets.all(isMobile ? 12 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploaderHeader(isMobile),
              SizedBox(height: isMobile ? 12 : 18),
              Expanded(
                child: _buildCsvPreview(isMobile),
              ),
              if (csvData.isNotEmpty) ...[
                SizedBox(height: isMobile ? 12 : 16),
                _buildFileStatusCard(isMobile),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploaderHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.22),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerTextBlock(isMobile),
                const SizedBox(height: 14),
                _uploadActions(isMobile),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _headerTextBlock(isMobile),
                ),
                const SizedBox(width: 18),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _uploadActions(isMobile),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _headerTextBlock(bool isMobile) {
    return Row(
      children: [
        Container(
          height: isMobile ? 42 : 48,
          width: isMobile ? 42 : 48,
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.18),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: primaryGreen.withOpacity(0.32),
            ),
          ),
          child: Icon(
            Icons.upload_file_rounded,
            color: accentGreen,
            size: isMobile ? 24 : 28,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Data Uploader",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: isMobile ? 20 : 26,
                  fontWeight: FontWeight.w900,
                  color: lightText,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "Upload, preview, and store CSV or Excel files with any columns.",
                maxLines: isMobile ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: isMobile ? 12.5 : 14,
                  fontWeight: FontWeight.w600,
                  color: mutedText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _uploadActions(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _professionalButton(
            label: _isPickingFile ? "Selecting..." : "Upload File",
            icon: Icons.upload_file_rounded,
            backgroundColor: gold,
            foregroundColor: Colors.black,
            onPressed: _isPickingFile ? null : pickCsvFile,
            fillWidth: true,
          ),
          if (csvData.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _professionalButton(
                    label: "Cancel",
                    icon: Icons.close_rounded,
                    backgroundColor: dangerRed,
                    foregroundColor: Colors.white,
                    onPressed: _clearSelection,
                    fillWidth: true,
                    compact: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _professionalButton(
                    label: "Store",
                    icon: Icons.storage_rounded,
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      showGlassDialog(context);
                    },
                    fillWidth: true,
                    compact: true,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.end,
      children: [
        _professionalButton(
          label: _isPickingFile ? "Selecting..." : "Upload File",
          icon: Icons.upload_file_rounded,
          backgroundColor: gold,
          foregroundColor: Colors.black,
          onPressed: _isPickingFile ? null : pickCsvFile,
        ),
        if (csvData.isNotEmpty)
          _professionalButton(
            label: "Cancel",
            icon: Icons.close_rounded,
            backgroundColor: dangerRed,
            foregroundColor: Colors.white,
            onPressed: _clearSelection,
          ),
        if (csvData.isNotEmpty)
          _professionalButton(
            label: "Store in Database",
            icon: Icons.storage_rounded,
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            onPressed: () {
              showGlassDialog(context);
            },
          ),
      ],
    );
  }

  Widget _professionalButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback? onPressed,
    bool fillWidth = false,
    bool compact = false,
  }) {
    final button = SizedBox(
      width: fillWidth ? double.infinity : null,
      height: compact ? 42 : 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withOpacity(0.35),
          foregroundColor: foregroundColor,
          disabledForegroundColor: foregroundColor.withOpacity(0.55),
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 16,
            vertical: compact ? 8 : 12,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: fillWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: compact ? 17 : 19,
              color: foregroundColor,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  color: foregroundColor,
                  fontWeight: FontWeight.w900,
                  fontSize: compact ? 12 : 13.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return fillWidth ? button : IntrinsicWidth(child: button);
  }

  Widget _buildCsvPreview(bool isMobile) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(isMobile ? 10 : 14),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBorder),
      ),
      child: csvData.isEmpty ? _emptyCsvState(isMobile) : _csvTable(isMobile),
    );
  }

  Widget _emptyCsvState(bool isMobile) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: isMobile ? 64 : 78,
              width: isMobile ? 64 : 78,
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.14),
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryGreen.withOpacity(0.30),
                ),
              ),
              child: Icon(
                Icons.insert_drive_file_rounded,
                color: accentGreen,
                size: isMobile ? 34 : 42,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No data file uploaded yet",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: lightText,
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Select a CSV or Excel file to preview all columns before saving them to the database.",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: mutedText,
                fontSize: isMobile ? 13 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _csvTable(bool isMobile) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(accentGreen),
        thickness: WidgetStateProperty.all(8),
        radius: const Radius.circular(999),
      ),
      child: Scrollbar(
        controller: _verticalController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _verticalController,
          scrollDirection: Axis.vertical,
          child: Scrollbar(
            controller: _horizontalController,
            thumbVisibility: true,
            notificationPredicate: (notification) => notification.depth == 1,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: isMobile ? 850 : 1100,
                ),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(darkSurface3),
                  dataRowColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return primaryGreen.withOpacity(0.10);
                    }

                    return darkSurface2;
                  }),
                  border: TableBorder.all(
                    color: darkBorder,
                    width: 0.8,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  columnSpacing: isMobile ? 18 : 28,
                  horizontalMargin: isMobile ? 10 : 14,
                  headingRowHeight: isMobile ? 46 : 52,
                  dataRowMinHeight: isMobile ? 42 : 46,
                  dataRowMaxHeight: isMobile ? 52 : 60,
                  columns: csvData.first
                      .map(
                        (header) => DataColumn(
                          label: SizedBox(
                            width: isMobile ? 120 : 150,
                            child: Text(
                              header,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(
                                color: lightText,
                                fontWeight: FontWeight.w900,
                                fontSize: isMobile ? 12 : 13,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  rows: csvData
                      .skip(1)
                      .map(
                        (row) => DataRow(
                          cells: row
                              .map(
                                (cell) => DataCell(
                                  SizedBox(
                                    width: isMobile ? 120 : 150,
                                    child: Text(
                                      cell,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.nunito(
                                        color: mutedText,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isMobile ? 11.5 : 12.5,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileStatusCard(bool isMobile) {
    final fileName = pickedFile?.name ?? "Selected data file";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 12 : 14),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _uploadDestinationColor.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: isMobile ? 40 : 44,
            width: isMobile ? 40 : 44,
            decoration: BoxDecoration(
              color: _uploadDestinationColor.withOpacity(0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _uploadDestinationIcon,
              color: _uploadDestinationColor,
              size: isMobile ? 22 : 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: lightText,
                    fontWeight: FontWeight.w900,
                    fontSize: isMobile ? 13.5 : 14.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "This file will be stored in the $_uploadDestinationLabel. All columns will be uploaded.",
                  maxLines: isMobile ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: mutedText,
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 11.5 : 13,
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 12),
            _typeBadge(),
          ],
        ],
      ),
    );
  }

  Widget _typeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: _uploadDestinationColor.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _uploadDestinationColor.withOpacity(0.34),
        ),
      ),
      child: Text(
        _uploadDestinationLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.nunito(
          color: lightText,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  void showGlassDialog(BuildContext parentContext) {
    String? selectedYear;
    String? selectedSeason;
    bool dialogUploading = false;

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: parentContext,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        final bool isMobile = width < 520;

        return StatefulBuilder(
          builder: (dialogContext, dialogSetState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: SizedBox(
                width: isMobile ? width - 32 : 440,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 18 : 24),
                      decoration: BoxDecoration(
                        color: darkSurface.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 28,
                            offset: const Offset(0, 16),
                            color: Colors.black.withOpacity(0.35),
                          ),
                        ],
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 54,
                              width: 54,
                              decoration: BoxDecoration(
                                color: primaryGreen.withOpacity(0.18),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: primaryGreen.withOpacity(0.30),
                                ),
                              ),
                              child: const Icon(
                                Icons.storage_rounded,
                                color: accentGreen,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Store Data File",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                fontSize: isMobile ? 20 : 22,
                                fontWeight: FontWeight.w900,
                                color: lightText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Select the year and season before saving this file. All columns will be uploaded.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: mutedText,
                              ),
                            ),
                            const SizedBox(height: 22),

                            DropdownButtonFormField<String>(
                              value: selectedYear,
                              dropdownColor: darkSurface2,
                              style: GoogleFonts.nunito(
                                color: lightText,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: _dialogInputDecoration(
                                hint: "Select Year",
                              ),
                              items: List.generate(
                                50,
                                (index) {
                                  final year =
                                      (DateTime.now().year - index).toString();

                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text(
                                      year,
                                      style: GoogleFonts.nunito(
                                        color: lightText,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return "Please select a year";
                                }

                                return null;
                              },
                              onChanged: (value) {
                                dialogSetState(() {
                                  selectedYear = value;
                                });
                              },
                            ),

                            const SizedBox(height: 16),

                            DropdownButtonFormField<String>(
                              value: selectedSeason,
                              dropdownColor: darkSurface2,
                              style: GoogleFonts.nunito(
                                color: lightText,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: _dialogInputDecoration(
                                hint: "Select Season",
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: "Dry",
                                  child: Text(
                                    "Dry Season",
                                    style: GoogleFonts.nunito(
                                      color: lightText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "Wet",
                                  child: Text(
                                    "Wet Season",
                                    style: GoogleFonts.nunito(
                                      color: lightText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return "Please select a season";
                                }

                                return null;
                              },
                              onChanged: (value) {
                                dialogSetState(() {
                                  selectedSeason = value;
                                });
                              },
                            ),

                            const SizedBox(height: 24),

                            if (isMobile)
                              Column(
                                children: [
                                  _dialogConfirmButton(
                                    uploading: dialogUploading,
                                    onPressed: dialogUploading
                                        ? null
                                        : () async {
                                            await _confirmStore(
                                              dialogContext: dialogContext,
                                              parentContext: parentContext,
                                              formKey: formKey,
                                              selectedYear: selectedYear,
                                              selectedSeason: selectedSeason,
                                              setUploading: (value) {
                                                dialogSetState(() {
                                                  dialogUploading = value;
                                                });
                                              },
                                            );
                                          },
                                  ),
                                  const SizedBox(height: 10),
                                  _dialogCancelButton(
                                    onPressed: dialogUploading
                                        ? null
                                        : () {
                                            Navigator.pop(dialogContext);
                                          },
                                  ),
                                ],
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: _dialogCancelButton(
                                      onPressed: dialogUploading
                                          ? null
                                          : () {
                                              Navigator.pop(dialogContext);
                                            },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _dialogConfirmButton(
                                      uploading: dialogUploading,
                                      onPressed: dialogUploading
                                          ? null
                                          : () async {
                                              await _confirmStore(
                                                dialogContext: dialogContext,
                                                parentContext: parentContext,
                                                formKey: formKey,
                                                selectedYear: selectedYear,
                                                selectedSeason: selectedSeason,
                                                setUploading: (value) {
                                                  dialogSetState(() {
                                                    dialogUploading = value;
                                                  });
                                                },
                                              );
                                            },
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _dialogInputDecoration({
    required String hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.nunito(
        color: mutedText,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: darkSurface2,
      errorStyle: GoogleFonts.nunito(
        color: Colors.redAccent,
        fontWeight: FontWeight.w700,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _dialogConfirmButton({
    required bool uploading,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          disabledBackgroundColor: primaryGreen.withOpacity(0.40),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        icon: uploading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.check_rounded,
                color: Colors.white,
              ),
        label: Text(
          uploading ? "Saving..." : "Confirm",
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _dialogCancelButton({
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightText,
          side: const BorderSide(color: darkBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        icon: const Icon(
          Icons.close_rounded,
          color: lightText,
        ),
        label: Text(
          "Cancel",
          style: GoogleFonts.nunito(
            color: lightText,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmStore({
    required BuildContext dialogContext,
    required BuildContext parentContext,
    required GlobalKey<FormState> formKey,
    required String? selectedYear,
    required String? selectedSeason,
    required ValueChanged<bool> setUploading,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (pickedFile == null || pickedFile!.bytes == null) {
      CustomSnackBar.show(
        parentContext,
        message: "No data file selected!",
        backgroundColor: Colors.orange,
        icon: Icons.warning_rounded,
        bottomMargin: 40,
        leftMarginFactor: 0.8,
      );

      return;
    }

    setUploading(true);

    try {
      // Upload all columns exactly as previewed. Excel files are converted
      // to CSV before upload so the database receives one flexible table.
      // The backend endpoint must also support flexible columns/schemas.
      final response = await uploadCropData(
        _bytesForUpload(),
        _fileNameForUpload(),
        selectedYear!,
        selectedSeason!,
      );

      if (!mounted) return;

      Navigator.pop(dialogContext);

      _handleUploadResponse(parentContext, response);
    } catch (e) {
      if (!mounted) return;

      setUploading(false);

      CustomSnackBar.show(
        parentContext,
        message: "Upload failed: $e",
        backgroundColor: Colors.red,
        icon: Icons.error_outline_rounded,
        bottomMargin: 40,
        leftMarginFactor: 0.8,
      );
    }
  }

  void _handleUploadResponse(
    BuildContext parentContext,
    dynamic response,
  ) {
    final bool success = response is Map && response["success"] == true;
    final int insertedCount = response is Map && response["inserted_count"] is int
        ? response["inserted_count"] as int
        : 0;

    if (success) {
      if (insertedCount > 0) {
        CustomSnackBar.show(
          parentContext,
          message: "$insertedCount items uploaded successfully",
          backgroundColor: Colors.green,
          icon: Icons.check_circle_rounded,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );
      } else {
        CustomSnackBar.show(
          parentContext,
          message: "All records are already in the database",
          backgroundColor: Colors.orange,
          icon: Icons.warning_rounded,
          bottomMargin: 40,
          leftMarginFactor: 0.8,
        );
      }

      return;
    }

    final message = response is Map && response["message"] != null
        ? response["message"].toString()
        : "Upload failed. Please try again.";

    CustomSnackBar.show(
      parentContext,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_rounded,
      bottomMargin: 40,
      leftMarginFactor: 0.8,
    );
  }
}