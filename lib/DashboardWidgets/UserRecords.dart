import 'package:cropbio/Models/User_data_source.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserRecords extends StatefulWidget {
  final List<Map<String, dynamic>> records;
  final bool loading;

  const UserRecords({
    super.key,
    required this.records,
    this.loading = true,
  });

  @override
  State<UserRecords> createState() => _UserRecordsState();
}

class _UserRecordsState extends State<UserRecords> {
  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkGreen = Color(0xFF1E2E1E);
  static const Color darkBorder = Color(0xFF2E3E31);
  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  final DataGridController _controller = DataGridController();
  final TextEditingController _searchController = TextEditingController();

  late UserDataSource _dataSource;

  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _dataSource = UserDataSource(const []);
    _loadData(refresh: false);
  }

  @override
  void didUpdateWidget(covariant UserRecords oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.records != widget.records ||
        oldWidget.loading != widget.loading) {
      _loadData();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadData({bool refresh = true}) {
    _data = List<Map<String, dynamic>>.from(widget.records);
    _applySearchFilter(_searchController.text);

    if (refresh && mounted) {
      setState(() {});
    }
  }

  void _search(String value) {
    setState(() {
      _applySearchFilter(value);
    });
  }

  void _applySearchFilter(String value) {
    final searchText = value.toLowerCase().trim();

    if (searchText.isEmpty) {
      _filteredData = List<Map<String, dynamic>>.from(_data);
    } else {
      _filteredData = _data.where((user) {
        final fullName = (user["fullName"] ?? "").toString().toLowerCase();
        final email = (user["email"] ?? "").toString().toLowerCase();
        final role = (user["role"] ?? "").toString().toLowerCase();
        final id = (user["_id"] ?? "").toString().toLowerCase();

        return fullName.contains(searchText) ||
            email.contains(searchText) ||
            role.contains(searchText) ||
            id.contains(searchText);
      }).toList();
    }

    _dataSource = UserDataSource(_filteredData);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryGreen,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 720;

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: darkSurface,
          padding: EdgeInsets.all(isMobile ? 12 : 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tableHeader(isMobile),
              SizedBox(height: isMobile ? 12 : 22),
              _actionButtons(isMobile),
              SizedBox(height: isMobile ? 12 : 24),
              Expanded(
                child: _dataGrid(isMobile),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tableHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "User Records",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          _countBadge('${_filteredData.length} users'),
          const SizedBox(height: 10),
          _searchField(),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            "User Records",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w900,
              fontSize: 26,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _countBadge('${_filteredData.length} users'),
        const SizedBox(width: 12),
        SizedBox(
          width: 320,
          child: _searchField(),
        ),
      ],
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: _search,
      style: GoogleFonts.nunito(
        color: lightText,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: lightText,
      decoration: InputDecoration(
        hintText: "Search users...",
        hintStyle: GoogleFonts.nunito(
          color: mutedText,
          fontWeight: FontWeight.w600,
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

  Widget _actionButtons(bool isMobile) {
    if (isMobile) {
      return Row(
        children: [
          Expanded(
            child: _mobileActionButton(
              "Add",
              Icons.add,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _mobileActionButton(
              "Edit",
              Icons.edit,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _mobileActionButton(
              "Delete",
              Icons.delete,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _mobileActionButton(
              "Download",
              Icons.download,
            ),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _desktopActionButton("Add", Icons.add),
        _desktopActionButton("Edit", Icons.edit),
        _desktopActionButton("Delete", Icons.delete),
        _desktopActionButton("Download", Icons.download),
      ],
    );
  }

  Widget _mobileActionButton(
    String label,
    IconData icon,
  ) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 5,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: Colors.white,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 9,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _desktopActionButton(
    String label,
    IconData icon,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        minimumSize: const Size(110, 44),
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _dataGrid(bool isMobile) {
    if (_filteredData.isEmpty) {
      return _emptyState();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SfDataGrid(
        source: _dataSource,
        controller: _controller,
        allowSorting: true,
        allowFiltering: true,
        allowMultiColumnSorting: true,
        selectionMode: SelectionMode.single,
        showVerticalScrollbar: true,
        showHorizontalScrollbar: true,
        columnWidthMode:
            isMobile ? ColumnWidthMode.none : ColumnWidthMode.fill,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columns: [
          GridColumn(
            columnName: '#',
            width: isMobile ? 70 : double.nan,
            label: _header('#'),
          ),
          GridColumn(
            columnName: '_id',
            width: isMobile ? 220 : double.nan,
            label: _header('ID'),
          ),
          GridColumn(
            columnName: 'fullName',
            width: isMobile ? 190 : double.nan,
            label: _header('Name'),
          ),
          GridColumn(
            columnName: 'email',
            width: isMobile ? 260 : double.nan,
            label: _header('Email'),
          ),
          GridColumn(
            columnName: 'role',
            width: isMobile ? 150 : double.nan,
            label: _header('Role'),
          ),
          GridColumn(
            columnName: 'isVerified',
            width: isMobile ? 140 : double.nan,
            label: _header('Verified'),
          ),
        ],
      ),
    );
  }

  Widget _header(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(12),
      color: darkGreen,
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_alt_rounded,
            size: 64,
            color: mutedText.withValues(alpha: 0.50),
          ),
          const SizedBox(height: 14),
          Text(
            'No user records found',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: lightText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search or refresh the records.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: mutedText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}