import 'dart:async';

import 'package:castyourcare/view/custom/my_textfeild.dart';
import 'package:castyourcare/view/screen/auth/release_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../data/services/ai_service.dart';
import '../../../custom/my_text_widget.dart';

class AuthBottomSheetScreen {
  static void selectCastCareSheet() {
    // Flutter's showModalBottomSheet correctly anchors the sheet above the
    // soft keyboard (Get.bottomSheet does not, which made it fly to the top).
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CastCareSheet(),
    );
  }
}

class _CastCareSheet extends StatefulWidget {
  const _CastCareSheet();

  @override
  State<_CastCareSheet> createState() => _CastCareSheetState();
}

class _CastCareSheetState extends State<_CastCareSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  List<String> _suggestions = [];
  bool _loadingSuggestions = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 8) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 700), () => _fetchSuggestions(value));
  }

  Future<void> _fetchSuggestions(String value) async {
    setState(() => _loadingSuggestions = true);
    try {
      final result = await AiService.to.reflectionSuggestions(value);
      if (!mounted) return;
      setState(() {
        _suggestions = result;
        _loadingSuggestions = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingSuggestions = false);
    }
  }

  void _applySuggestion(String text) {
    // Suggestion is a rephrasing the user can adopt as their own words.
    final clean = text.replaceFirst(RegExp(r'^\+\s*'), '');
    _controller.text = clean;
    _controller.selection =
        TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    setState(() => _suggestions = []);
  }

  void _cast() {
    final burden = _controller.text.trim();
    // Dismiss the keyboard BEFORE navigating so the next full-height screen
    // isn't briefly laid out against a shrunken (keyboard-reduced) height,
    // which caused a ~1s RenderFlex overflow during the transition.
    FocusScope.of(context).unfocus();
    Get.back();
    // Pass the burden text ONLY in-memory to the release screen (never stored).
    Get.to(() => ReleaseScreen(burden: burden));
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom;
    // With showModalBottomSheet + the viewInsets padding below, the sheet sits
    // directly above the keyboard; cap its height so it scrolls if needed.
    final maxSheetHeight = media.size.height * 0.85 - bottomInset;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      // Tapping anywhere outside the text field dismisses the keyboard
      // (fixes the "keyboard won't go back down" issue).
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          constraints: BoxConstraints(maxHeight: maxSheetHeight),
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: kSplashColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back, size: 15),
                          const SizedBox(width: 3),
                          MyText(
                            text: "Back",
                            size: 14,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    // Explicit keyboard-dismiss affordance for the multiline field.
                    GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: MyText(
                        text: "Done",
                        size: 14,
                        weight: FontWeight.w600,
                        color: const Color(0xFF1F3A5F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MyText(
                  text: "What’s in Your heart?",
                  size: 20,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 5),
                MyText(
                  text: "Tell God what’s on your heart cast your cares on Him.",
                  size: 14,
                  weight: FontWeight.w600,
                  color: kTextColor,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _onChanged,
                  label: "What is weighing on your heart today?",
                  maxLines: 4,
                  marginBottom: 12,
                ),
                _buildSuggestions(),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _cast,
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1F3A5F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: MyText(
                        text: "Cast Your Cares",
                        size: 16,
                        weight: FontWeight.w600,
                        color: kQuaternaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    if (_loadingSuggestions) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            MyText(
              text: "Finding gentle words…",
              size: 12,
              weight: FontWeight.w600,
              color: kTextColor,
            ),
          ],
        ),
      );
    }
    if (_suggestions.isEmpty) return const SizedBox.shrink();
    return Column(
      children: _suggestions
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => _applySuggestion(s),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: ShapeDecoration(
                    color: kQuaternaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: MyText(
                    text: "+ $s",
                    size: 12,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
