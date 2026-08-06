import 'dart:math';

import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/custom/my_button.dart';
import 'package:castyourcare/view/custom/my_text_widget.dart';
import 'package:castyourcare/view/screen/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../data/services/ai_service.dart';
import '../../../data/services/content_repository.dart';
import '../../../data/services/user_repository.dart';
import '../../../generated/assets.dart';

class CastReleaseScreen extends StatefulWidget {
  /// The burden text (in memory only, never persisted).
  final String burden;

  const CastReleaseScreen({super.key, this.burden = ''});

  @override
  State<CastReleaseScreen> createState() => _CastReleaseScreenState();
}

class _CastReleaseScreenState extends State<CastReleaseScreen> {
  static const List<String> _fallbackQuotes = [
    "It’s in God’s hands now. Rest.",
    "Let it go. Breathe. God is with you.",
    "You’ve given it to God. Rest in His care.",
    "It’s been released. You don’t have to carry it anymore.",
    "Your cares are in His hands now. He cares for you.",
    "Your cares have been lifted. Trust that God is holding them now.",
    "It rests in His hands now. So can you.",
    "Your burdens are in His hands. Be still and rest.",
    "What you carried is now in His care. Rest.",
    "You gave it to God. You don’t have to carry it anymore.",
  ];

  // A single message per release, chosen once (changes every time you release).
  late String _quote;

  @override
  void initState() {
    super.initState();
    _quote = _fallbackQuotes[Random().nextInt(_fallbackQuotes.length)];
    _recordRelease();
    _loadQuote();
  }

  /// The ONLY thing persisted on a cast: increment the released counter.
  /// The burden text itself is never stored.
  Future<void> _recordRelease() async {
    try {
      await UserRepository.to.incrementBurdensReleased();
    } catch (_) {}
  }

  Future<void> _loadQuote() async {
    try {
      // Prefer a personalized AI comfort line when available.
      if (widget.burden.trim().isNotEmpty) {
        final line = await AiService.to.comfortLine(widget.burden);
        if (line != null && line.isNotEmpty && mounted) {
          setState(() => _quote = line);
          return;
        }
      }
      // Otherwise pick one random quote from Firestore (fallback to bundled).
      final quotes = await ContentRepository.to.getReleaseQuotes();
      final list =
          quotes.map((q) => q.text).where((t) => t.isNotEmpty).toList();
      if (list.isNotEmpty && mounted) {
        setState(() => _quote = list[Random().nextInt(list.length)]);
      }
    } catch (_) {}
  }

  String get formattedDate {
    final now = DateTime.now();
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December",
    ];
    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesReleaseScreenbg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              children: [
                const SizedBox(height: 20),
                CommonImageView(imagePath: Assets.imagesCarest, height: 90),
                const Spacer(),
                _QuoteCard(date: formattedDate, quote: _quote),
                const Spacer(),
                MyText(
                  text: "Your care has been\nreleased.",
                  textAlign: TextAlign.center,
                  size: 24,
                  weight: FontWeight.w600,
                  lineHeight: 1.5,
                ),
                const SizedBox(height: 15),
                MyText(
                  text: "Head back to the Home screen\nwhenever you’re ready.",
                  textAlign: TextAlign.center,
                  size: 16,
                  weight: FontWeight.w600,
                  color: kTextColor,
                ),
                const SizedBox(height: 22),
                MyButton2(
                  onTap: () {
                    Get.offAll(() => BottomNavBarScreen());
                  },
                  buttonText: "Return Home",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final String date;
  final String quote;

  const _QuoteCard({required this.date, required this.quote});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(quote),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F4),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFF0F1EC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              text: date,
              size: 16,
              weight: FontWeight.w500,
              color: const Color(0xFF9CAF88),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            MyText(
              text: quote,
              size: 26,
              weight: FontWeight.w700,
              textAlign: TextAlign.center,
              color: const Color(0xFF9CAF88),
              lineHeight: 1.35,
            ),
          ],
        ),
      ),
    );
  }
}
