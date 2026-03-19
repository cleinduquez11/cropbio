class PlotData {
  final String code;
  final String field;
  final String plot;
  final int plantSample;
  final double latitude;
  final double longitude;
  final double length;
  final double width;
  final double plantSpacing;
  final double rowSpacing;
  final String soilType;
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

  factory PlotData.fromMongo(Map<String, dynamic> json) {
    final plotInfo = json["plot_info"] ?? {};

    return PlotData(
      code: json["CODE"] ?? "",
      field: json["FIELD"] ?? "",
      plot: json["PLOT"] ?? "",
      plantSample: (json["PLANT_SAMPLE"] as num?)?.toInt() ?? 0,
      latitude: (plotInfo["LAT"] ?? 0).toDouble(),
      longitude: (plotInfo["LON"] ?? 0).toDouble(),
      length: (plotInfo["LENGTH"] ?? 0).toDouble(),
      width: (plotInfo["WIDTH"] ?? 0).toDouble(),
      plantSpacing: (plotInfo["PLANT_SPACING"] ?? 0).toDouble(),
      rowSpacing: (plotInfo["ROW_SPACING"] ?? 0).toDouble(),
      soilType: plotInfo["SOIL_TYPE"] ?? "",
      soilTemperature: (plotInfo["SOIL_TEMPERATURE"] ?? 0).toDouble(),
      plantHeight: (plotInfo["PLANT_HEIGHT"] ?? 0).toDouble(),
    );
  }
}