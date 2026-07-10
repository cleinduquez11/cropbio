import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class CropBioMap extends StatefulWidget {
  const CropBioMap({super.key});

  @override
  State<CropBioMap> createState() => _CropBioMapState();
}

class _CropBioMapState extends State<CropBioMap> {
  /// 📍 MMSU Batac / CropBio pilot center
  static const LatLng mmsuBatac = LatLng(18.0553, 120.5453);

  /// Example reference point mentioned in your code
  static const LatLng site1 = LatLng(18.0553, 120.5453);
  static const LatLng site2 = LatLng(18.05555556, 120.55405556);

  static const Color primaryGreen = Color(0xFF3F6B2A);
  static const Color accentGreen = Color(0xFF7A8F3D);
  static const Color goldAccent = Color(0xFFC6A432);

  static const Color darkBg = Color(0xFF0F1712);
  static const Color darkSurface = Color(0xFF162216);
  static const Color darkSurface2 = Color(0xFF1D2B20);
  static const Color darkSurface3 = Color(0xFF243625);
  static const Color darkBorder = Color(0xFF2E3E31);

  static const Color lightText = Color(0xFFF3F7F1);
  static const Color mutedText = Color(0xFFB7C4B2);

  final MapController mapController = MapController();

  bool showLayerPanel = true;

  bool showMmsuMarker = true;
  bool showSamplingPoints = true;
  bool showFieldBoundary = true;
  bool showShapefiles = true;
  bool showRasters = false;
  bool showOrthomosaic = false;

  double rasterOpacity = 0.55;
  double orthomosaicOpacity = 0.65;

  String selectedBasemap = 'Google Hybrid';

  final List<LatLng> cropBioBoundary = const [
    LatLng(18.05820, 120.54180),
    LatLng(18.05805, 120.54890),
    LatLng(18.05320, 120.54930),
    LatLng(18.05290, 120.54210),
  ];

  final List<LatLng> samplePoints = const [
    LatLng(18.0553, 120.5453),
    LatLng(18.05555556, 120.55405556),
    LatLng(18.0564, 120.5466),
    LatLng(18.0542, 120.5477),
    LatLng(18.0538, 120.5443),
  ];

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  String get _basemapUrl {
    switch (selectedBasemap) {
      case 'OpenStreetMap':
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case 'Google Satellite':
        return 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}';
      case 'Google Roadmap':
        return 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
      case 'Google Hybrid':
      default:
        return 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 820;

    return Scaffold(
      backgroundColor: darkBg,
      drawer: isMobile
          ? Drawer(
              backgroundColor: darkSurface,
              child: SafeArea(
                child: _layerPanel(
                  isMobile: true,
                  closeDrawer: () => Navigator.pop(context),
                ),
              ),
            )
          : null,
      appBar: _appBar(isMobile),
      body: Stack(
        children: [
          _mapView(),

          /// Dark map edge overlay for better contrast
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.transparent,
                    Colors.black.withOpacity(0.28),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          if (!isMobile && showLayerPanel)
            Positioned(
              top: 18,
              left: 18,
              bottom: 18,
              child: SizedBox(
                width: 360,
                child: _layerPanel(isMobile: false),
              ),
            ),

          Positioned(
            top: 18,
            right: 18,
            child: _mapControls(isMobile),
          ),

          if (!isMobile)
            Positioned(
              left: showLayerPanel ? 396 : 18,
              right: 18,
              bottom: 18,
              child: _bottomStatusBar(isMobile),
            ),

          if (isMobile)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: _mobileBottomBar(),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(bool isMobile) {
    return AppBar(
      backgroundColor: darkSurface,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: lightText),
      leading: isMobile
          ? Builder(
              builder: (context) {
                return IconButton(
                  tooltip: 'Open layer panel',
                  icon: const Icon(Icons.layers_rounded),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            )
          : IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/landingpage',
                  (route) => false,
                );
              },
            ),
      title: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryGreen.withOpacity(0.34),
              ),
            ),
            child: const Icon(
              Icons.map_rounded,
              color: goldAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CropBio Map Dashboard',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: lightText,
                    fontSize: isMobile ? 17 : 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'MMSU Batac • Raster, orthomosaic, and vector layers',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: mutedText,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (!isMobile)
          IconButton(
            tooltip: showLayerPanel ? 'Hide layer panel' : 'Show layer panel',
            onPressed: () {
              setState(() {
                showLayerPanel = !showLayerPanel;
              });
            },
            icon: Icon(
              showLayerPanel
                  ? Icons.layers_rounded
                  : Icons.layers_clear_outlined,
              color: lightText,
            ),
          ),
        IconButton(
          tooltip: 'Center to MMSU Batac',
          onPressed: _centerToMmsu,
          icon: const Icon(
            Icons.my_location_rounded,
            color: goldAccent,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _mapView() {
    return FlutterMap(
      mapController: mapController,
      options: const MapOptions(
        initialCenter: mmsuBatac,
        initialZoom: 17,
        minZoom: 5,
        maxZoom: 24,
        backgroundColor: darkBg,
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: _basemapUrl,
          userAgentPackageName: 'com.example.cropbio',
          tileSize: 256,
          maxZoom: 24,
          keepBuffer: 2,
          retinaMode: false,
          tileProvider: CancellableNetworkTileProvider(),
        ),

        /// Replace these placeholder URL templates with your actual backend
        /// or tile server endpoints when available.
        if (showOrthomosaic)
          Opacity(
            opacity: orthomosaicOpacity,
            child: TileLayer(
              urlTemplate:
                  'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
              userAgentPackageName: 'com.example.cropbio',
              tileSize: 256,
              maxZoom: 24,
              keepBuffer: 2,
              retinaMode: false,
              tileProvider: CancellableNetworkTileProvider(),
            ),
          ),

        if (showRasters)
          PolygonLayer(
            polygons: [
              Polygon(
                points: cropBioBoundary,
                color: Colors.orange.withOpacity(rasterOpacity * 0.36),
                borderColor: Colors.orangeAccent.withOpacity(0.90),
                borderStrokeWidth: 1.8,
              ),
            ],
          ),

        if (showFieldBoundary || showShapefiles)
          PolygonLayer(
            polygons: [
              Polygon(
                points: cropBioBoundary,
                color: primaryGreen.withOpacity(0.16),
                borderColor: goldAccent,
                borderStrokeWidth: 2.4,
              ),
            ],
          ),

        if (showSamplingPoints)
          MarkerLayer(
            markers: samplePoints.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final point = entry.value;

              return Marker(
                point: point,
                width: 42,
                height: 42,
                child: _sampleMarker(index),
              );
            }).toList(),
          ),

        if (showMmsuMarker)
          MarkerLayer(
            markers: [
              Marker(
                point: site1,
                width: 54,
                height: 54,
                child: _mmsuMarker(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _layerPanel({
    required bool isMobile,
    VoidCallback? closeDrawer,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 18),
      decoration: BoxDecoration(
        color: darkSurface.withOpacity(isMobile ? 1.0 : 0.96),
        borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(26),
        border: Border.all(
          color: darkBorder,
        ),
        boxShadow: [
          if (!isMobile)
            BoxShadow(
              blurRadius: 30,
              offset: const Offset(0, 16),
              color: Colors.black.withOpacity(0.34),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _panelHeader(isMobile, closeDrawer),
          const SizedBox(height: 18),
          _basemapSelector(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _panelSectionTitle('Map Layers'),
                const SizedBox(height: 10),
                _layerTile(
                  title: 'MMSU Batac Center',
                  subtitle: 'Primary CropBio dashboard map center',
                  icon: Icons.location_on_rounded,
                  enabled: showMmsuMarker,
                  layerType: 'Reference',
                  onChanged: (value) {
                    setState(() => showMmsuMarker = value);
                  },
                  onDownload: () => _downloadLayer('MMSU Batac center'),
                ),
                _layerTile(
                  title: 'Sampling Points',
                  subtitle: 'Field and laboratory sampling locations',
                  icon: Icons.grain_rounded,
                  enabled: showSamplingPoints,
                  layerType: 'Point shapefile',
                  onChanged: (value) {
                    setState(() => showSamplingPoints = value);
                  },
                  onDownload: () => _downloadLayer('Sampling points shapefile'),
                ),
                _layerTile(
                  title: 'Field Boundary',
                  subtitle: 'CropBio pilot field boundary layer',
                  icon: Icons.crop_square_rounded,
                  enabled: showFieldBoundary,
                  layerType: 'Polygon shapefile',
                  onChanged: (value) {
                    setState(() => showFieldBoundary = value);
                  },
                  onDownload: () => _downloadLayer('Field boundary shapefile'),
                ),
                _layerTile(
                  title: 'Shapefiles',
                  subtitle: 'Vector layers for plots, parcels, and boundaries',
                  icon: Icons.polyline_rounded,
                  enabled: showShapefiles,
                  layerType: 'Vector',
                  onChanged: (value) {
                    setState(() => showShapefiles = value);
                  },
                  onDownload: () => _downloadLayer('All shapefiles'),
                ),
                _layerTile(
                  title: 'Raster Layers',
                  subtitle: 'Vegetation indices, LAI, NDVI, EVI, and analysis rasters',
                  icon: Icons.grid_on_rounded,
                  enabled: showRasters,
                  layerType: 'Raster',
                  onChanged: (value) {
                    setState(() => showRasters = value);
                  },
                  onDownload: () => _downloadLayer('Raster layers'),
                  extra: _opacitySlider(
                    label: 'Raster opacity',
                    value: rasterOpacity,
                    onChanged: showRasters
                        ? (value) {
                            setState(() => rasterOpacity = value);
                          }
                        : null,
                  ),
                ),
                _layerTile(
                  title: 'Orthomosaic',
                  subtitle: 'Drone orthomosaic and high-resolution imagery',
                  icon: Icons.image_rounded,
                  enabled: showOrthomosaic,
                  layerType: 'Orthomosaic',
                  onChanged: (value) {
                    setState(() => showOrthomosaic = value);
                  },
                  onDownload: () => _downloadLayer('Orthomosaic'),
                  extra: _opacitySlider(
                    label: 'Orthomosaic opacity',
                    value: orthomosaicOpacity,
                    onChanged: showOrthomosaic
                        ? (value) {
                            setState(() => orthomosaicOpacity = value);
                          }
                        : null,
                  ),
                ),
                const SizedBox(height: 18),
                _panelSectionTitle('Quick Downloads'),
                const SizedBox(height: 10),
                _downloadGroup(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panelHeader(bool isMobile, VoidCallback? closeDrawer) {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.18),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryGreen.withOpacity(0.34),
            ),
          ),
          child: const Icon(
            Icons.layers_rounded,
            color: goldAccent,
            size: 26,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Layer Manager',
                style: GoogleFonts.nunito(
                  color: lightText,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Toggle, inspect, and download map layers',
                style: GoogleFonts.nunito(
                  color: mutedText,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (isMobile)
          IconButton(
            onPressed: closeDrawer,
            icon: const Icon(
              Icons.close_rounded,
              color: lightText,
            ),
          ),
      ],
    );
  }

  Widget _basemapSelector() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basemap',
            style: GoogleFonts.nunito(
              color: lightText,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedBasemap,
            dropdownColor: darkSurface2,
            iconEnabledColor: goldAccent,
            decoration: InputDecoration(
              filled: true,
              fillColor: darkSurface3,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: darkBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: primaryGreen, width: 1.4),
              ),
            ),
            style: GoogleFonts.nunito(
              color: lightText,
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
            ),
            items: const [
              DropdownMenuItem(
                value: 'Google Hybrid',
                child: Text('Google Hybrid'),
              ),
              DropdownMenuItem(
                value: 'Google Satellite',
                child: Text('Google Satellite'),
              ),
              DropdownMenuItem(
                value: 'Google Roadmap',
                child: Text('Google Roadmap'),
              ),
              DropdownMenuItem(
                value: 'OpenStreetMap',
                child: Text('OpenStreetMap'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                selectedBasemap = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _panelSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        color: mutedText,
        fontSize: 12.5,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget _layerTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool enabled,
    required String layerType,
    required ValueChanged<bool> onChanged,
    required VoidCallback onDownload,
    Widget? extra,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: enabled ? darkSurface3 : darkSurface2,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: enabled ? primaryGreen.withOpacity(0.45) : darkBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(enabled ? 0.24 : 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: primaryGreen.withOpacity(0.30),
                  ),
                ),
                child: Icon(
                  icon,
                  color: enabled ? goldAccent : mutedText,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _layerText(
                  title: title,
                  subtitle: subtitle,
                  layerType: layerType,
                ),
              ),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: enabled,
                activeColor: goldAccent,
                activeTrackColor: primaryGreen.withOpacity(0.55),
                inactiveThumbColor: mutedText,
                inactiveTrackColor: darkBorder,
                onChanged: onChanged,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _smallActionButton(
                label: 'Zoom',
                icon: Icons.zoom_in_map_rounded,
                onPressed: () {
                  mapController.move(mmsuBatac, 17.5);
                },
              ),
              const SizedBox(width: 8),
              _smallActionButton(
                label: 'Download',
                icon: Icons.download_rounded,
                isGold: true,
                onPressed: onDownload,
              ),
            ],
          ),
          if (extra != null) ...[
            const SizedBox(height: 12),
            extra,
          ],
        ],
      ),
    );
  }

  Widget _layerText({
    required String title,
    required String subtitle,
    required String layerType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            color: lightText,
            fontSize: 14.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: primaryGreen.withOpacity(0.28),
            ),
          ),
          child: Text(
            layerType,
            style: GoogleFonts.nunito(
              color: lightText,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _opacitySlider({
    required String label,
    required double value,
    required ValueChanged<double>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${(value * 100).round()}%',
          style: GoogleFonts.nunito(
            color: mutedText,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: goldAccent,
            inactiveTrackColor: darkBorder,
            thumbColor: goldAccent,
            overlayColor: goldAccent.withOpacity(0.14),
          ),
          child: Slider(
            value: value,
            min: 0.15,
            max: 1.0,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _downloadGroup() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _downloadButton(
                label: 'All Layers',
                icon: Icons.archive_rounded,
                onPressed: () => _downloadLayer('All map layers'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _downloadButton(
                label: 'Metadata',
                icon: Icons.description_rounded,
                onPressed: () => _downloadLayer('Layer metadata'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _downloadButton(
          label: 'Current Map View',
          icon: Icons.map_rounded,
          fullWidth: true,
          onPressed: () => _downloadLayer('Current map view'),
        ),
      ],
    );
  }

  Widget _smallActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isGold = false,
  }) {
    return Expanded(
      child: SizedBox(
        height: 36,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 16,
            color: isGold ? Colors.black : lightText,
          ),
          label: Text(
            label,
            style: GoogleFonts.nunito(
              color: isGold ? Colors.black : lightText,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: isGold ? goldAccent : darkSurface2,
            side: BorderSide(
              color: isGold ? goldAccent : darkBorder,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _downloadButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 40,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 17,
          color: Colors.black,
        ),
        label: Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: goldAccent,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  Widget _mapControls(bool isMobile) {
    return Column(
      children: [
        _floatingButton(
          tooltip: 'Zoom in',
          icon: Icons.add_rounded,
          onPressed: () {
            final camera = mapController.camera;
            mapController.move(camera.center, camera.zoom + 1);
          },
        ),
        const SizedBox(height: 8),
        _floatingButton(
          tooltip: 'Zoom out',
          icon: Icons.remove_rounded,
          onPressed: () {
            final camera = mapController.camera;
            mapController.move(camera.center, camera.zoom - 1);
          },
        ),
        const SizedBox(height: 8),
        _floatingButton(
          tooltip: 'Center to MMSU Batac',
          icon: Icons.my_location_rounded,
          isGold: true,
          onPressed: _centerToMmsu,
        ),
        if (!isMobile) ...[
          const SizedBox(height: 8),
          _floatingButton(
            tooltip: showLayerPanel ? 'Hide layer panel' : 'Show layer panel',
            icon: showLayerPanel
                ? Icons.layers
                : Icons.layers_clear_rounded,
            onPressed: () {
              setState(() {
                showLayerPanel = !showLayerPanel;
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _floatingButton({
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
    bool isGold = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: isGold ? goldAccent : darkSurface.withOpacity(0.96),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isGold ? goldAccent : darkBorder,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(0.30),
            ),
          ],
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: isGold ? Colors.black : lightText,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _bottomStatusBar(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: darkSurface.withOpacity(0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: darkBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.32),
          ),
        ],
      ),
      child: Row(
        children: [
          _statusItem(
            icon: Icons.place_rounded,
            label: 'Center',
            value: 'MMSU Batac',
          ),
          _divider(),
          _statusItem(
            icon: Icons.layers_rounded,
            label: 'Active Layers',
            value: '${_activeLayerCount()} visible',
          ),
          _divider(),
          _statusItem(
            icon: Icons.public_rounded,
            label: 'Basemap',
            value: selectedBasemap,
          ),
          const Spacer(),
          _downloadButton(
            label: 'Download View',
            icon: Icons.download_rounded,
            onPressed: () => _downloadLayer('Current map view'),
          ),
        ],
      ),
    );
  }

  Widget _mobileBottomBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: darkSurface.withOpacity(0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.34),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _statusItem(
              icon: Icons.layers_rounded,
              label: 'Layers',
              value: '${_activeLayerCount()} visible',
              compact: true,
            ),
          ),
          const SizedBox(width: 8),
          _downloadButton(
            label: 'View',
            icon: Icons.download_rounded,
            onPressed: () => _downloadLayer('Current map view'),
          ),
        ],
      ),
    );
  }

  Widget _statusItem({
    required IconData icon,
    required String label,
    required String value,
    bool compact = false,
  }) {
    return Row(
      mainAxisSize: compact ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.16),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: accentGreen,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  color: mutedText,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  color: lightText,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 34,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: darkBorder,
    );
  }

  Widget _mmsuMarker() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: goldAccent.withOpacity(0.26),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: darkSurface,
            shape: BoxShape.circle,
            border: Border.all(
              color: goldAccent,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: goldAccent,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _sampleMarker(int index) {
    return Container(
      decoration: BoxDecoration(
        color: primaryGreen,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.35),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$index',
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  int _activeLayerCount() {
    return [
      showMmsuMarker,
      showSamplingPoints,
      showFieldBoundary,
      showShapefiles,
      showRasters,
      showOrthomosaic,
    ].where((value) => value).length;
  }

  void _centerToMmsu() {
    mapController.move(mmsuBatac, 17);
  }

  void _downloadLayer(String layerName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: darkSurface2,
        behavior: SnackBarBehavior.floating,
        content: Text(
          '$layerName download requested. Connect this button to your backend download endpoint.',
          style: GoogleFonts.nunito(
            color: lightText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}