import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

class CropBioMap extends StatefulWidget {
  const CropBioMap({super.key});

  @override
  State<CropBioMap> createState() => _CropBioMapState();
}

class _CropBioMapState extends State<CropBioMap> {
  // 📍 MMSU Batac Coordinates
  static const LatLng mmsuBatac = LatLng(18.0553, 120.5453);
  static const LatLng site1 = LatLng(18.0553, 120.5453);

// (18.05555556, 120.55405556)
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Crop Bio Map",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
    color: Colors.white, // Change to any color you want
  ),

      ),
      body: FlutterMap(
        
        mapController: mapController,
        options: MapOptions(
          
          initialCenter: mmsuBatac,
          // crs: Epsg4326(),
          initialZoom: 17,

          // ⭐ Web performance optimization
          minZoom: 5,
          maxZoom: 24,
          backgroundColor: Colors.black,

          // Disable rotation (saves performance)
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          // 🌍 Esri World Imagery (Optimized)
          TileLayer(
            urlTemplate: "https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}",

            userAgentPackageName: 'com.example.cropbio',

            // ⭐ Web optimizations
            tileSize: 256,
            maxZoom: 24,

            // Prevent loading unnecessary tiles
            keepBuffer: 2,

            // Improves web tile loading
            retinaMode: false,
             tileProvider: CancellableNetworkTileProvider(),
          ),

          // 📍 Marker Layer
          MarkerLayer(
            markers: [
              Marker(
                point: site1,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
