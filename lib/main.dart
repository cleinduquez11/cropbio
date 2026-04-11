import 'package:cropbio/CropBioDashboard.dart';
import 'package:cropbio/CropBioLandingPage.dart';
import 'package:cropbio/CropBioMap.dart';
import 'package:cropbio/CropBioSignin.dart';
import 'package:cropbio/CropBioSignup.dart';
import 'package:cropbio/Pherips/RouteDirection.dart';
import 'package:cropbio/Pherips/themes.dart';
import 'package:cropbio/Providers/LayoutProvider.dart';
import 'package:cropbio/Providers/UserSession.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLoggedIn = await UserSession.isLoggedIn();

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
  const CropBiodiversityApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crop Biodiversity',
      theme: buildAppTheme(context),
      initialRoute: "/landingpage",
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case "/landingpage":
            page = const LandingPage();
            break;

          case "/dashboard":
            page = const Cropbiodashboard();
            break;

          case "/map":
            page = const CropBioMap();
            break;

          case "/signup":
            page = const SignUpPage();
            break;

          case "/signin":
            page = const SignInPage();
            break;

          default:
            page = const LandingPage();
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            SlideDirection direction = settings.arguments is SlideDirection
                ? settings.arguments as SlideDirection
                : SlideDirection.fromRight;

            Offset begin;

            switch (direction) {
              case SlideDirection.fromLeft:
                begin = const Offset(-1.0, 0);
                break;

              case SlideDirection.fromRight:
                begin = const Offset(1.0, 0);
                break;

              case SlideDirection.fromTop:
                begin = const Offset(0, -1.0);
                break;

              case SlideDirection.fromBottom:
                begin = const Offset(0, 1.0);
                break;
            }

            final tween = Tween(
              begin: begin,
              end: Offset.zero,
            ).chain(
              CurveTween(
                curve: Curves.easeOutCubic,
              ),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
