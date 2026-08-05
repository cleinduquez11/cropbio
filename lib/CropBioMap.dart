import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

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

  bool rasterAccordionExpanded = true;
  bool vectorAccordionExpanded = true;

  bool showMmsuMarker = true;
  bool showSamplingPoints = false;
  bool showFieldBoundary = true;
  bool showShapefiles = false;
  bool showRasters = false;
  bool showOrthomosaic2026Dry = true;
  bool showOrthomosaic2025Wet = false;
  bool showOrthomosaic2025Dry = false;

  double rasterOpacity = 0.55;
  double orthomosaic2026DryOpacity = 1;
  double orthomosaic2025WetOpacity = 1;
  double orthomosaic2025DryOpacity = 1;

  String selectedBasemap = 'OpenStreetMap';

  /// CropBio orthomosaic WMS layers from GeoServer.
  /// The original OpenLayers preview URLs were converted to WMS tile layers
  /// using image/png so they can render inside flutter_map.
  static const String cropBioWmsBaseUrl =
      'https://coaster.mmsu.edu.ph/geoserver/cropbio/wms?';

  static const String orthomosaic2026DryLayer =
      'cropbio:202603-RGB-reflectance_utm51_cog';

  static const String orthomosaic2025WetLayer =
      'cropbio:RGB-mosaic_reflectance';

  static const String orthomosaic2025DryLayer =
      'cropbio:202503_MMSU_reflectance';

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

        /// Orthomosaic layers from GeoServer WMS.
        /// GeoServer handles reprojection from the source CRS to the map CRS.
        if (showOrthomosaic2026Dry)
          _orthomosaicWmsLayer(
            layerName: orthomosaic2026DryLayer,
            opacity: orthomosaic2026DryOpacity,
          ),

        if (showOrthomosaic2025Wet)
          _orthomosaicWmsLayer(
            layerName: orthomosaic2025WetLayer,
            opacity: orthomosaic2025WetOpacity,
          ),

        if (showOrthomosaic2025Dry)
          _orthomosaicWmsLayer(
            layerName: orthomosaic2025DryLayer,
            opacity: orthomosaic2025DryOpacity,
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

  Widget _orthomosaicWmsLayer({
    required String layerName,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: TileLayer(
        wmsOptions: WMSTileLayerOptions(
          baseUrl: cropBioWmsBaseUrl,
          layers: [layerName],
          styles: const [''],
          format: 'image/png',
          version: '1.1.0',
          transparent: true,
          otherParameters: const {
            'tiled': 'true',
          },
        ),
        userAgentPackageName: 'com.example.cropbio',
        tileSize: 256,
        maxZoom: 24,
        keepBuffer: 2,
        retinaMode: false,
        tileProvider: CancellableNetworkTileProvider(),
      ),
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
                _panelSectionTitle('GIS Data'),
                const SizedBox(height: 10),

                _gisAccordion(
                  title: 'Raster Data',
                  subtitle: 'Orthomosaic and image-based GIS layers',
                  icon: Icons.grid_on_rounded,
                  initiallyExpanded: rasterAccordionExpanded,
                  onExpansionChanged: (value) {
                    setState(() => rasterAccordionExpanded = value);
                  },
                  children: [
                    _orthomosaicLayerTile(
                      title: '2026 Dry Orthomosaic',
                      subtitle: 'Drone RGB reflectance orthomosaic',
                      icon: Icons.image_rounded,
                      enabled: showOrthomosaic2026Dry,
                      opacityLabel: '2026 dry opacity',
                      opacityValue: orthomosaic2026DryOpacity,
                      wmsLayerName: orthomosaic2026DryLayer,
                      onChanged: (value) {
                        setState(() => showOrthomosaic2026Dry = value);
                      },
                      onOpacityChanged: showOrthomosaic2026Dry
                          ? (value) {
                              setState(() => orthomosaic2026DryOpacity = value);
                            }
                          : null,
                    ),
                    _orthomosaicLayerTile(
                      title: '2025 Wet Orthomosaic',
                      subtitle: 'Wet-season RGB reflectance orthomosaic',
                      icon: Icons.filter_hdr_rounded,
                      enabled: showOrthomosaic2025Wet,
                      opacityLabel: '2025 wet opacity',
                      opacityValue: orthomosaic2025WetOpacity,
                      wmsLayerName: orthomosaic2025WetLayer,
                      onChanged: (value) {
                        setState(() => showOrthomosaic2025Wet = value);
                      },
                      onOpacityChanged: showOrthomosaic2025Wet
                          ? (value) {
                              setState(() => orthomosaic2025WetOpacity = value);
                            }
                          : null,
                    ),
                    _orthomosaicLayerTile(
                      title: '2025 Dry Orthomosaic',
                      subtitle: 'Dry-season RGB reflectance orthomosaic',
                      icon: Icons.wb_sunny_rounded,
                      enabled: showOrthomosaic2025Dry,
                      opacityLabel: '2025 dry opacity',
                      opacityValue: orthomosaic2025DryOpacity,
                      wmsLayerName: orthomosaic2025DryLayer,
                      onChanged: (value) {
                        setState(() => showOrthomosaic2025Dry = value);
                      },
                      onOpacityChanged: showOrthomosaic2025Dry
                          ? (value) {
                              setState(() => orthomosaic2025DryOpacity = value);
                            }
                          : null,
                    ),

                    const SizedBox(height: 4),
                    _selectedDroneDataDownloadButton(),
                    const SizedBox(height: 8),
                    _activeWmsQgisButton(),
                    const SizedBox(height: 8),
                    _activeWmsArcGisProButton(),

                  ],
                ),

                _gisAccordion(
                  title: 'Vector Data',
                  subtitle: 'Points, boundaries, and shapefile-based GIS layers',
                  icon: Icons.polyline_rounded,
                  initiallyExpanded: vectorAccordionExpanded,
                  onExpansionChanged: (value) {
                    setState(() => vectorAccordionExpanded = value);
                  },
                  children: [
                    _layerTile(
                      title: 'MMSU Batac Center',
                      subtitle: 'Primary CropBio dashboard map center',
                      icon: Icons.location_on_rounded,
                      enabled: showMmsuMarker,
                      layerType: 'Reference Point',
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
                      layerType: 'Point Vector',
                      onChanged: (value) {
                        setState(() => showSamplingPoints = value);
                      },
                      onDownload: () => _downloadLayer('Sampling points vector'),
                    ),
                    _layerTile(
                      title: 'Field Boundary',
                      subtitle: 'CropBio pilot field boundary layer',
                      icon: Icons.crop_square_rounded,
                      enabled: showFieldBoundary,
                      layerType: 'Polygon Vector',
                      onChanged: (value) {
                        setState(() => showFieldBoundary = value);
                      },
                      onDownload: () => _downloadLayer('Field boundary vector'),
                    ),
                    _layerTile(
                      title: 'Shapefiles',
                      subtitle: 'Vector layers for plots, parcels, and boundaries',
                      icon: Icons.account_tree_rounded,
                      enabled: showShapefiles,
                      layerType: 'Vector Collection',
                      onChanged: (value) {
                        setState(() => showShapefiles = value);
                      },
                      onDownload: () => _downloadLayer('All shapefiles'),
                    ),
                  ],
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

  Widget _gisAccordion({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool initiallyExpanded,
    required ValueChanged<bool> onExpansionChanged,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: darkSurface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkBorder),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: primaryGreen.withOpacity(0.10),
          highlightColor: primaryGreen.withOpacity(0.08),
        ),
        child: ExpansionTile(
          key: PageStorageKey<String>('accordion_$title'),
          initiallyExpanded: initiallyExpanded,
          onExpansionChanged: onExpansionChanged,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          collapsedIconColor: goldAccent,
          iconColor: goldAccent,
          leading: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.18),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: primaryGreen.withOpacity(0.30),
              ),
            ),
            child: Icon(
              icon,
              color: goldAccent,
              size: 21,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.nunito(
              color: lightText,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.nunito(
              color: mutedText,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _orthomosaicLayerTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool enabled,
    required String opacityLabel,
    required double opacityValue,
    required String wmsLayerName,
    required ValueChanged<bool> onChanged,
    required ValueChanged<double>? onOpacityChanged,
  }) {
    return _layerTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      enabled: enabled,
      layerType: 'Raster WMS',
      onChanged: onChanged,
      onDownload: enabled
          ? () => _downloadSelectedDroneData(
                displayName: title,
                layerNames: [wmsLayerName],
              )
          : () => _showLayerMessage('Turn on $title before downloading it.'),
      extra: Column(
        children: [
          _opacitySlider(
            label: opacityLabel,
            value: opacityValue,
            onChanged: onOpacityChanged,
          ),
          const SizedBox(height: 8),
          _qgisButton(
            label: enabled ? 'Copy selected layer for QGIS' : 'Turn layer on for QGIS',
            layerDisplayName: title,
            layerName: wmsLayerName,
            enabled: enabled,
          ),
          const SizedBox(height: 8),
          _arcgisProButton(
            label: enabled ? 'Copy selected layer for ArcGIS Pro' : 'Turn layer on for ArcGIS Pro',
            layerDisplayName: title,
            layerName: wmsLayerName,
            enabled: enabled,
          ),
        ],
      ),
    );
  }

  Widget _qgisButton({
    required String label,
    required String layerDisplayName,
    required String layerName,
    required bool enabled,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: OutlinedButton.icon(
        onPressed: enabled
            ? () {
                _copyWmsForQgis(
                  displayName: layerDisplayName,
                  layerNames: [layerName],
                );
              }
            : null,
        icon: Icon(
          Icons.copy_rounded,
          size: 16,
          color: enabled ? goldAccent : mutedText,
        ),
        label: Text(
          label,
          style: GoogleFonts.nunito(
            color: enabled ? lightText : mutedText,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: darkSurface2,
          disabledBackgroundColor: darkSurface2.withOpacity(0.70),
          side: BorderSide(
            color: enabled
                ? goldAccent.withOpacity(0.55)
                : darkBorder.withOpacity(0.65),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _arcgisProButton({
    required String label,
    required String layerDisplayName,
    required String layerName,
    required bool enabled,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: OutlinedButton.icon(
        onPressed: enabled
            ? () {
                _copyWmsForArcgisPro(
                  displayName: layerDisplayName,
                  layerNames: [layerName],
                );
              }
            : null,
        icon: Icon(
          Icons.desktop_windows_rounded,
          size: 16,
          color: enabled ? goldAccent : mutedText,
        ),
        label: Text(
          label,
          style: GoogleFonts.nunito(
            color: enabled ? lightText : mutedText,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: darkSurface2,
          disabledBackgroundColor: darkSurface2.withOpacity(0.70),
          side: BorderSide(
            color: enabled
                ? goldAccent.withOpacity(0.55)
                : darkBorder.withOpacity(0.65),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _selectedDroneDataDownloadButton() {
    final activeLayerNames = _activeWmsLayerNames();
    final activeCount = activeLayerNames.length;

    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton.icon(
        onPressed: activeCount > 0
            ? () {
                _downloadSelectedDroneData(
                  displayName: 'Selected drone data',
                  layerNames: activeLayerNames,
                );
              }
            : null,
        icon: Icon(
          Icons.download_rounded,
          size: 18,
          color: activeCount > 0 ? Colors.black : mutedText,
        ),
        label: Text(
          activeCount > 0
              ? 'Download $activeCount selected drone layer(s)'
              : 'Select/show drone data first',
          style: GoogleFonts.nunito(
            color: activeCount > 0 ? Colors.black : mutedText,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: activeCount > 0 ? goldAccent : darkSurface3,
          disabledBackgroundColor: darkSurface3,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  Widget _activeWmsQgisButton() {
    final activeLayerNames = _activeWmsLayerNames();
    final activeCount = activeLayerNames.length;

    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton.icon(
        onPressed: activeCount > 0
            ? () {
                _copyWmsForQgis(
                  displayName: 'Selected CropBio WMS layers',
                  layerNames: activeLayerNames,
                );
              }
            : null,
        icon: Icon(
          Icons.copy_rounded,
          size: 18,
          color: activeCount > 0 ? Colors.black : mutedText,
        ),
        label: Text(
          activeCount > 0
              ? 'Copy $activeCount selected WMS layer(s) for QGIS'
              : 'Select/show a raster layer first',
          style: GoogleFonts.nunito(
            color: activeCount > 0 ? Colors.black : mutedText,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: activeCount > 0 ? goldAccent : darkSurface3,
          disabledBackgroundColor: darkSurface3,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  Widget _activeWmsArcGisProButton() {
    final activeLayerNames = _activeWmsLayerNames();
    final activeCount = activeLayerNames.length;

    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton.icon(
        onPressed: activeCount > 0
            ? () {
                _copyWmsForArcgisPro(
                  displayName: 'Selected CropBio WMS layers',
                  layerNames: activeLayerNames,
                );
              }
            : null,
        icon: Icon(
          Icons.desktop_windows_rounded,
          size: 18,
          color: activeCount > 0 ? Colors.black : mutedText,
        ),
        label: Text(
          activeCount > 0
              ? 'Copy $activeCount selected WMS layer(s) for ArcGIS Pro'
              : 'Select/show a raster layer first',
          style: GoogleFonts.nunito(
            color: activeCount > 0 ? Colors.black : mutedText,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: activeCount > 0 ? goldAccent : darkSurface3,
          disabledBackgroundColor: darkSurface3,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
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
        _downloadButton(
          label: 'Download Selected Drone Data',
          icon: Icons.download_rounded,
          fullWidth: true,
          onPressed: () => _downloadSelectedDroneData(
            displayName: 'Selected drone data',
            layerNames: _activeWmsLayerNames(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _downloadButton(
                label: 'QGIS',
                icon: Icons.copy_rounded,
                onPressed: () => _copyWmsForQgis(
                  displayName: 'Selected CropBio WMS layers',
                  layerNames: _activeWmsLayerNames(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _downloadButton(
                label: 'ArcGIS Pro',
                icon: Icons.desktop_windows_rounded,
                onPressed: () => _copyWmsForArcgisPro(
                  displayName: 'Selected CropBio WMS layers',
                  layerNames: _activeWmsLayerNames(),
                ),
              ),
            ),
          ],
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
      showOrthomosaic2026Dry,
      showOrthomosaic2025Wet,
      showOrthomosaic2025Dry,
    ].where((value) => value).length;
  }

  void _centerToMmsu() {
    mapController.move(mmsuBatac, 17);
  }

  String _wmsCapabilitiesUrl() {
    final separator = cropBioWmsBaseUrl.endsWith('?') ? '' : '?';

    return '${cropBioWmsBaseUrl}${separator}service=WMS&version=1.1.0&request=GetCapabilities';
  }

  String _wmsGetMapUrlForLayers(List<String> layerNames) {
    final separator = cropBioWmsBaseUrl.endsWith('?') ? '' : '?';
    final layers = Uri.encodeQueryComponent(layerNames.join(','));

    return '${cropBioWmsBaseUrl}${separator}'
        'service=WMS&version=1.1.0&request=GetMap'
        '&layers=$layers'
        '&styles='
        '&bbox=120.53201128805078,18.03867056304924,120.56059676171877,18.068850862876243'
        '&width=1600&height=1600'
        '&srs=EPSG:4326'
        '&format=image/png'
        '&transparent=true';
  }

  List<String> _activeWmsLayerNames() {
    final layers = <String>[];

    if (showOrthomosaic2026Dry) {
      layers.add(orthomosaic2026DryLayer);
    }

    if (showOrthomosaic2025Wet) {
      layers.add(orthomosaic2025WetLayer);
    }

    if (showOrthomosaic2025Dry) {
      layers.add(orthomosaic2025DryLayer);
    }

    return layers;
  }

  Future<void> _downloadSelectedDroneData({
    required String displayName,
    required List<String> layerNames,
  }) async {
    if (layerNames.isEmpty) {
      _showLayerMessage('Please turn on at least one drone orthomosaic first.');
      return;
    }

    final downloadUrl = _wmsGetMapUrlForLayers(layerNames);
    final uri = Uri.parse(downloadUrl);

    await Clipboard.setData(
      ClipboardData(text: downloadUrl),
    );

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!mounted) return;

    _showLayerMessage(
      opened
          ? '${layerNames.length} selected drone layer(s) opened for download. The GetMap URL was also copied.'
          : '${layerNames.length} selected drone layer(s) copied as a GetMap download URL.',
    );
  }

  Future<void> _copyWmsForQgis({
    required String displayName,
    required List<String> layerNames,
  }) async {
    if (layerNames.isEmpty) {
      _showLayerMessage('Please turn on at least one raster WMS layer first.');
      return;
    }

    final qgisConnectionText = [
      'CropBio selected WMS layer(s) for QGIS',
      '',
      'Name: $displayName',
      'WMS Server URL: ${_wmsCapabilitiesUrl()}',
      'Selected layer(s):',
      ...layerNames.map((layerName) => '- $layerName'),
      'Format: image/png',
      '',
      'In QGIS:',
      '1. Open Layer > Data Source Manager > WMS/WMTS.',
      '2. Click New.',
      '3. Paste the WMS Server URL above.',
      '4. Click Connect.',
      '5. Select only the layer(s) listed above.',
      '',
      'Selected GetMap URL:',
      _wmsGetMapUrlForLayers(layerNames),
    ].join('\n');

    await Clipboard.setData(
      ClipboardData(text: qgisConnectionText),
    );

    if (!mounted) return;

    _showLayerMessage('${layerNames.length} selected WMS layer(s) copied for QGIS.');
  }

  Future<void> _copyWmsForArcgisPro({
    required String displayName,
    required List<String> layerNames,
  }) async {
    if (layerNames.isEmpty) {
      _showLayerMessage('Please turn on at least one raster WMS layer first.');
      return;
    }

    final arcgisProConnectionText = [
      'CropBio selected WMS layer(s) for ArcGIS Pro',
      '',
      'Name: $displayName',
      'WMS Server URL: ${_wmsCapabilitiesUrl()}',
      'Selected layer(s):',
      ...layerNames.map((layerName) => '- $layerName'),
      'Format: image/png',
      '',
      'In ArcGIS Pro:',
      '1. Open Insert > Connections > Server > New WMS Server.',
      '2. Paste the WMS Server URL above.',
      '3. Click OK/Connect.',
      '4. Add only the selected layer(s) listed above to your map.',
      '',
      'Selected GetMap URL:',
      _wmsGetMapUrlForLayers(layerNames),
    ].join('\n');

    await Clipboard.setData(
      ClipboardData(text: arcgisProConnectionText),
    );

    if (!mounted) return;

    _showLayerMessage('${layerNames.length} selected WMS layer(s) copied for ArcGIS Pro.');
  }

  void _showLayerMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: darkSurface2,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: GoogleFonts.nunito(
            color: lightText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _downloadLayer(String layerName) {
    _showLayerMessage(
      '$layerName download requested. Use the selected drone data download button for WMS orthomosaics.',
    );
  }
}