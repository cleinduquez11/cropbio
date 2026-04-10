import 'package:cropbio/CropBioDashboard.dart';
import 'package:cropbio/CropBioLandingPage.dart';
import 'package:cropbio/CropBioMap.dart';
import 'package:cropbio/CropBioSignin.dart';
import 'package:cropbio/CropBioSignup.dart';
import 'package:cropbio/Pherips/themes.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:cropbio/Providers/UserSession.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLoggedIn =
      await UserSession.isLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LayoutProvider(),
        ),
      ],
      child: CropBiodiversityApp(
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}
class CropBiodiversityApp extends StatelessWidget {
    final bool isLoggedIn;
  const CropBiodiversityApp({super.key,required this.isLoggedIn,});

  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crop Biodiversity',
      theme: buildAppTheme(context),
      initialRoute: isLoggedIn ? "/landingpage" : "/landingpage",
      routes: {
        "/landingpage":(context) => const LandingPage(),
        "/dashboard": (context) => const Cropbiodashboard(),
        "/map": (context) => const CropBioMap(),
        "/signup": (context) => const SignUpPage(),
        "/signin":(context) => const SignInPage()
      },
    );
  }
}
