import 'package:cropbio/Models/plot_model.dart';

class CropData {
  final String code;
  final String field;
  final String plot;
  final int plantSample;
  final String cropType;
  final double freshWeight;
  final double dryWeight;
  final double avgLeafArea;
  final double correctedLeafArea;
  final double specificLeafArea;
  final double ldmc;
  final double leafWaterConcentration;
  final double equivalentWaterThickness;
  final double spad;
  final double chlA;
  final double chlB;
  final double caretenoid;
  final String capCover;
  final double lai;
  final double difn;
  final double mta;
  final double sem;
  final double smp;
  final double sel;
  final double chloropyllVal;
  final PlotData plotData;

  CropData(
      {required this.code,
      required this.field,
      required this.plot,
      required this.plantSample,
      required this.cropType,
      required this.freshWeight,
      required this.dryWeight,
      required this.avgLeafArea,
      required this.correctedLeafArea,
      required this.specificLeafArea,
      required this.ldmc,
      required this.leafWaterConcentration,
      required this.equivalentWaterThickness,
      required this.spad,
      required this.chlA,
      required this.chlB,
      required this.caretenoid,
      required this.capCover,
      required this.lai,
      required this.difn,
      required this.mta,
      required this.sem,
      required this.smp,
      required this.sel,
      required this.chloropyllVal,
      required this.plotData});
 
  factory CropData.fromMongo(Map<String, dynamic> json) {
    return CropData(
      code: json["CODE"] ?? "",
      field: json["FIELD"] ?? "",
      plot: json["PLOT"] ?? "",
      plantSample: (json["PLANT_SAMPLE"] as num?)?.toInt() ?? 0,
      cropType: json["CROP_TYPE"] ?? "",
      freshWeight: (json["FRESH_WEIGHT"] ?? 0).toDouble(),
      dryWeight: (json["DRY_WEIGHT"] ?? 0).toDouble(),
      avgLeafArea: (json["Average_Leaf_Area"] ?? 0).toDouble(),
      correctedLeafArea: (json["Corrected_Leaf_Area_(CF=0.75)"] ?? 0).toDouble(),
      specificLeafArea: (json["Specific_Leaf_Area_(cm2/g)"] ?? 0).toDouble(),
      ldmc: (json["Leaf_Dry_Matter_Content_(LDMC)"] ?? 0).toDouble(),
      leafWaterConcentration:
          (json["Leaf_Water_Concentration"] ?? 0).toDouble(),
      equivalentWaterThickness:
          (json["Equivalent_Water_Thickness_(EWT)"] ?? 0).toDouble(),
      spad: (json["SPAD__values"] ?? 0).toDouble(),
      chlA: (json["chl-a"] ?? 0).toDouble(),
      chlB: (json["chl-b"] ?? 0).toDouble(),
      caretenoid: (json["caretenoid"] ?? 0).toDouble(),
      capCover: json["Cap_Cover"] ?? "",
      lai: (json["LAI"] ?? 0).toDouble(),
      difn: (json["DIFN"] ?? 0).toDouble(),
      mta: (json["MTA"] ?? 0).toDouble(),
      sem: (json["SEM"] ?? 0).toDouble(),
      smp: (json["SMP"] ?? 0).toDouble(),
      sel: (json["SEL"] ?? 0).toDouble(),
      chloropyllVal: (json["Chloropyll__Value_(mg/m2)"] ?? 0).toDouble(),
      plotData: PlotData.fromMongo(json["plot_info"] ?? {}),
    );
  }
} 
