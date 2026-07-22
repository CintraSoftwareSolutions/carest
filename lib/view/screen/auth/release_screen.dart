import 'package:castyourcare/config/constants/app_sizes.dart';
import 'package:castyourcare/view/custom/common_image_view_widget.dart';
import 'package:castyourcare/view/custom/my_button.dart';
import 'package:castyourcare/view/custom/my_text_widget.dart';
import 'package:castyourcare/view/screen/auth/cast_release_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/constants/app_colors.dart';
import '../../../data/services/content_repository.dart';
import '../../../generated/assets.dart';

class ReleaseScreen extends StatefulWidget {
  /// The burden the user typed. Held only in memory, never persisted.
  final String burden;

  const ReleaseScreen({super.key, this.burden = ''});

  @override
  State<ReleaseScreen> createState() => _ReleaseScreenState();
}

class _ReleaseScreenState extends State<ReleaseScreen>
    with TickerProviderStateMixin {
  List<String> messages = [
    "Cast this into God's hands—He cares for you.",
    "You don't have to carry this alone.",
    "Place this into God's hands—He cares for you.",
    "Cast this upon Him, for He cares for you.",
    "You don't have to carry this—God is with you in it.",
    "Surrender this to God—He is faithful to carry what you cannot.",
    "Rest this in God's hands—He sees you and cares deeply.",
  ];

  late AnimationController _rotationController;
  late AnimationController _messageController;

  late Animation<double> _bottomFadeAnimation;
  late Animation<double> _topCardFlyAnimation;
  late Animation<double> _topCardOpacityAnimation;

  int _currentMessageIndex = 0;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _loadBreathQuotes();
    _initAnimations();
  }

  Future<void> _loadBreathQuotes() async {
    try {
      final quotes = await ContentRepository.to.getBreathQuotes();
      if (quotes.isNotEmpty && mounted) {
        setState(() {
          messages = quotes.map((q) => q.text).toList();
          _currentMessageIndex =
              DateTime.now().millisecondsSinceEpoch % messages.length;
        });
      }
    } catch (_) {}
  }

  void _initAnimations() {
    _hasNavigated = false;
    _currentMessageIndex = 0;

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _messageController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );

    // Bottom text: shuru se hi fade in hoga
    _bottomFadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 12,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 20, // fade out tezi se
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 50, // baqi time invisible rahega
      ),
    ]).animate(_messageController);

    // Top card fly up
    _topCardFlyAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -300.0).chain(
          CurveTween(curve: Curves.easeInQuart),
        ),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 50,
      ),
    ]).animate(_messageController);

    _topCardOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0).chain(
          CurveTween(curve: Curves.easeInQuart),
        ),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 50,
      ),
    ]).animate(_messageController);

    // Jab bottom text puri tarah fade ho jaye tab navigate karo
    // weight breakdown: 18 + 12 + 20 = 50%, matlab 0.50 pe text gayab
    _messageController.addListener(() {
      if (_messageController.value >= 0.51 && !_hasNavigated) {
        _hasNavigated = true;
        Get.to(() => CastReleaseScreen(burden: widget.burden))?.then((_) {
          if (mounted) {
            _messageController.dispose();
            _rotationController.dispose();
            setState(() {
              _initAnimations();
            });
          }
        });
      }
    });

    _messageController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildTopFlyingCard() {
    return AnimatedBuilder(
      animation: _messageController,
      builder: (context, child) {
        return Opacity(
          opacity: _topCardOpacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _topCardFlyAnimation.value),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: ShapeDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: MyText(
                text: widget.burden.trim().isNotEmpty
                    ? widget.burden.trim()
                    : "I'm casting my cares on Him.",
                textAlign: TextAlign.center,
                size: 20,
                weight: FontWeight.w600,
                color: kBlackLightColor,
                lineHeight: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomStaticCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        children: [
          RotationTransition(
            turns: _rotationController,
            child: CommonImageView(
              svgPath: Assets.svgFlowerGreen,
            ),
          ),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _messageController,
            builder: (context, child) {
              return Opacity(
                opacity: _bottomFadeAnimation.value,
                child: Column(
                  children: [
                    MyText(
                      text: "Take a breath…",
                      textAlign: TextAlign.center,
                      size: 32,
                      weight: FontWeight.w600,
                      color: const Color(0xFF9CAF88),
                      lineHeight: 1.5,
                    ),
                    const SizedBox(height: 10),
                    MyText(
                      text: messages[_currentMessageIndex],
                      textAlign: TextAlign.center,
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
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
                  imagePath: Assets.imagesCarestWhite,
                  height: 90,
                ),
                const Spacer(),
                _buildTopFlyingCard(),
                const SizedBox(height: 10),
                _buildBottomStaticCard(),
                const Spacer(),
                MyButton2(
                  onTap: () {
                    if (!_hasNavigated) {
                      _hasNavigated = true;
                      Get.to(() => CastReleaseScreen(burden: widget.burden))?.then((_) {
                        if (mounted) {
                          _messageController.dispose();
                          _rotationController.dispose();
                          setState(() {
                            _initAnimations();
                          });
                        }
                      });
                    }
                  },
                  buttonText: "Release My Care",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}