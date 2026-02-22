class CropData {
  final String field;
  final String plot;
  final int plantSample;
  final String code;
  final String cropType;
  final double freshWeight;
  final double dryWeight;
  final double avgLeafArea;
  final double correctedLeafArea;
  final double spad;
  final double temperature;
  final double plantHeight;

  CropData({
    required this.field,
    required this.plot,
    required this.plantSample,
    required this.code,
    required this.cropType,
    required this.freshWeight,
    required this.dryWeight,
    required this.avgLeafArea,
    required this.correctedLeafArea,
    required this.spad,
    required this.temperature,
    required this.plantHeight,
  });
}