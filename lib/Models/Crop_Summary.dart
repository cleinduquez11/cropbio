class CropSummary {
  final int totalAccessions;
  final int totalCropTypes;
  final int totalPlots;
  final int totalFields;
  final List<String> cropTypes;
  final List<String> plots;
  final String year;
  final String season;

  CropSummary({
    required this.totalAccessions,
    required this.totalCropTypes,
    required this.totalPlots,
    required this.totalFields,
    required this.cropTypes,
    required this.plots,
    required this.year,
    required this.season,
  });

factory CropSummary.fromJson(Map<String, dynamic> json) {
  final data = json["data"] ?? {};
  final filters = json["filters"] ?? {};

  // Safely parse lists, convert nulls to empty string
  List<String> parseList(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((e) => e?.toString() ?? "").toList();
  }

  return CropSummary(
    totalAccessions: data["total_accessions"] ?? 0,
    totalCropTypes: data["total_crop_types"] ?? 0,
    totalPlots: data["total_plots"] ?? 0,
    totalFields: data["total_fields"] ?? 0,
    cropTypes: parseList(data["crop_types_list"]),
    plots: parseList(data["plots_list"]),
    year: filters["year"]?.toString() ?? "",
    season: filters["season"]?.toString() ?? "",
  );
}
}