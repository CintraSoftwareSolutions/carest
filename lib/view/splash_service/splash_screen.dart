import 'package:castyourcare/view/screen/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/services/session_service.dart';
import '../../generated/assets.dart';
import '../custom/common_image_view_widget.dart';
import '../custom/my_text_widget.dart';

class SplashThemeModel {
  final Color backgroundColor;
  final String logoPath;
  final Color poweredTextColor;
  final Brightness statusBarIconBrightness;

  const SplashThemeModel({
    required this.backgroundColor,
    required this.logoPath,
    required this.poweredTextColor,
    required this.statusBarIconBrightness,
  });
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  SplashThemeModel? selectedTheme;

  final List<SplashThemeModel> splashThemes = [
    SplashThemeModel(
      backgroundColor: const Color(0xFFF0F4F0), // off white
      logoPath: Assets.imagesCarest, // replace with your asset
      poweredTextColor: const Color(0xFF6FA3D2),
      statusBarIconBrightness: Brightness.dark,
    ),
    SplashThemeModel(
      backgroundColor: const Color(0xFF1F3A5F), // dark blue
      logoPath: Assets.imagesCarestBluelight, // replace with your asset
      poweredTextColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
    ),
    SplashThemeModel(
      backgroundColor: const Color(0xFF6FA3D2), // sky blue
      logoPath: Assets.imagesCarest, // replace with your asset
      poweredTextColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
    ),
    SplashThemeModel(
      backgroundColor: const Color(0xFF9CAF88), // olive green
      logoPath: Assets.imagesCarestWhite, // replace with your asset
      poweredTextColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _selectThemeAndGo();
  }

  Future<void> _selectThemeAndGo() async {
    // Sequential rotation: a different splash theme is shown on each launch,
    // with the index persisted under this anonymous user/device.
    int index = 0;
    try {
      index = await SessionService.to.nextSplashIndex(splashThemes.length);
    } catch (_) {
      index = 0;
    }
    if (!mounted) return;

    setState(() {
      selectedTheme = splashThemes[index % splashThemes.length];
    });

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: selectedTheme!.statusBarIconBrightness,
        statusBarBrightness: selectedTheme!.statusBarIconBrightness,
      ),
    );

    _logoController.forward(from: 0);
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Get.offAll(() => WelcomeScreen());
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = selectedTheme;
    if (theme == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF0F4F0),
        body: SizedBox.shrink(),
      );
    }
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: ScaleTransition(
                scale: _logoAnimation,
                child: CommonImageView(imagePath: theme.logoPath, height: 120),
              ),
            ),
            const Spacer(),
            MyText(
              text: "Powered by Carest",
              size: 16,
              weight: FontWeight.w600,
              color: theme.poweredTextColor,
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
