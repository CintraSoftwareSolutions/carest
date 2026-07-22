import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/custom/my_button.dart';
import 'package:castyourcare/view/custom/my_text_widget.dart';
import 'package:castyourcare/view/screen/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
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
  final CardSwiperController _swiperController = CardSwiperController();

  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  List<String> releasedQuotes = [
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

  @override
  void initState() {
    super.initState();
    _recordRelease();
    _loadQuotes();
  }

  /// The ONLY thing persisted on a cast: increment the released counter.
  /// The burden text itself is never stored.
  Future<void> _recordRelease() async {
    try {
      await UserRepository.to.incrementBurdensReleased();
    } catch (_) {}
  }

  Future<void> _loadQuotes() async {
    try {
      final quotes = await ContentRepository.to.getReleaseQuotes();
      final list = quotes.map((q) => q.text).toList();

      // Optionally lead with a personalized AI comfort line.
      if (widget.burden.trim().isNotEmpty) {
        final line = await AiService.to.comfortLine(widget.burden);
        if (line != null && line.isNotEmpty) list.insert(0, line);
      }

      if (list.isNotEmpty && mounted) {
        setState(() => releasedQuotes = list);
      }
    } catch (_) {}
  }

  String get formattedDate {
    final now = DateTime.now();
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  @override
  void dispose() {
    _swiperController.dispose();
    currentIndex.dispose();
    super.dispose();
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
                CommonImageView(
                  imagePath: Assets.imagesCarest,
                  height: 90,
                ),
                const Spacer(),

                SizedBox(
                  height: 340,
                  child: CardSwiper(
                    controller: _swiperController,
                    cardsCount: releasedQuotes.length,
                    numberOfCardsDisplayed: 3,
                    backCardOffset: const Offset(0, -14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    scale: 0.94,
                    duration: const Duration(milliseconds: 450),
                    maxAngle: 0,
                    isLoop: true,
                    allowedSwipeDirection: const AllowedSwipeDirection.only(
                      up: true,
                      down: true,
                    ),
                    onSwipe: (
                        int previousIndex,
                        int? newIndex,
                        CardSwiperDirection direction,
                        ) {
                      if (newIndex != null) {
                        currentIndex.value = newIndex;
                      }
                      return true;
                    },
                    cardBuilder: (
                        BuildContext context,
                        int index,
                        int horizontalOffsetPercentage,
                        int verticalOffsetPercentage,
                        ) {
                      return _QuoteCard(
                        date: formattedDate,
                        quote: releasedQuotes[index],
                      );
                    },
                  ),
                ),

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

  const _QuoteCard({
    required this.date,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFF0F1EC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            size: 28,
            weight: FontWeight.w700,
            textAlign: TextAlign.center,
            color: const Color(0xFF9CAF88),
            lineHeight: 1.35,
          ),
        ],
      ),
    );
  }
}