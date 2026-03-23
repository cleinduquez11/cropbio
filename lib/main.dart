import 'package:cropbio/CropBioDashboard.dart';
import 'package:cropbio/CropBioLandingPage.dart';
import 'package:cropbio/CropBioMap.dart';
import 'package:cropbio/Pherips/themes.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LayoutProvider()),
      ],
      child: const CropBiodiversityApp(),
    ),
  );
}

class CropBiodiversityApp extends StatelessWidget {
  const CropBiodiversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crop Biodiversity',
      theme: buildAppTheme(context),
      home: const LandingPage(),
      routes: {
        "/dashboard": (context) => const Cropbiodashboard(),
        "/map": (context) => const CropBioMap()
      },
    );
  }
}
