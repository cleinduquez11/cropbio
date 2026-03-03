class PlotData {
  final String code;
  final String field;
  final String plot;
  final String plantSample;
  final double latitude;
  final double longitude;
  final double length;
  final double width;
  final double plantSpacing;
  final double rowSpacing;
  final double soilType;
  final double soilTemperature;
  final double plantHeight;

  PlotData({
    required this.code,
    required this.field,
    required this.plot,
    required this.plantSample,
    required this.latitude,
    required this.longitude,
    required this.length,
    required this.width,
    required this.plantSpacing,
    required this.rowSpacing,
    required this.soilType,
    required this.soilTemperature,
    required this.plantHeight,
  });
}
