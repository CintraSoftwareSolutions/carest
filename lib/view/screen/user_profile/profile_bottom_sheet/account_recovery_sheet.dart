import 'package:castyourcare/view/custom/my_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../data/services/user_repository.dart';
import '../../../custom/my_text_widget.dart';

/// Lets a user attach a username + PIN to their (otherwise anonymous) account
/// so they can re-open the same profile on another device.
class AccountRecoverySheet {
  static void open() {
    Get.bottomSheet(
      const _AccountRecoverySheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _AccountRecoverySheet extends StatefulWidget {
  const _AccountRecoverySheet();

  @override
  State<_AccountRecoverySheet> createState() => _AccountRecoverySheetState();
}

class _AccountRecoverySheetState extends State<_AccountRecoverySheet> {
  final _setupUser = TextEditingController();
  final _setupPin = TextEditingController();
  final _restoreUser = TextEditingController();
  final _restorePin = TextEditingController();

  String? _currentUsername;
  bool _loading = true;
  bool _savingSetup = false;
  bool _savingRestore = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await UserRepository.to.recoveryUsername();
    if (!mounted) return;
    setState(() {
      _currentUsername = u;
      if (u != null) _setupUser.text = u;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _setupUser.dispose();
    _setupPin.dispose();
    _restoreUser.dispose();
    _restorePin.dispose();
    super.dispose();
  }

  void _toast(String title, String msg) => Get.snackbar(
        title,
        msg,
        snackPosition: SnackPosition.BOTTOM,
      );

  Future<void> _setup() async {
    FocusScope.of(context).unfocus();
    setState(() => _savingSetup = true);
    final res = await UserRepository.to.setupRecovery(
      _setupUser.text,
      _setupPin.text,
    );
    if (!mounted) return;
    setState(() => _savingSetup = false);
    switch (res) {
      case AccountResult.ok:
        Get.back();
        _toast("Username saved",
            "Use this username and PIN to open your account on another device.");
        break;
      case AccountResult.usernameTaken:
        _toast("Username taken", "Please choose a different username.");
        break;
      case AccountResult.invalid:
        _toast("Check your details",
            "Username needs 3+ characters and PIN needs 4+.");
        break;
      default:
        _toast("Couldn't save", "Please check your connection and try again.");
    }
  }

  Future<void> _restore() async {
    FocusScope.of(context).unfocus();
    setState(() => _savingRestore = true);
    final res = await UserRepository.to.restoreAccount(
      _restoreUser.text,
      _restorePin.text,
    );
    if (!mounted) return;
    setState(() => _savingRestore = false);
    switch (res) {
      case AccountResult.ok:
        Get.back();
        _toast("Account restored", "Your profile has been loaded on this device.");
        break;
      case AccountResult.notFound:
        _toast("Not found", "No account exists for that username.");
        break;
      case AccountResult.wrongPin:
        _toast("Incorrect PIN", "Please check your PIN and try again.");
        break;
      case AccountResult.invalid:
        _toast("Check your details", "Enter your username and PIN.");
        break;
      default:
        _toast("Couldn't restore", "Please check your connection and try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: kSplashColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _loading
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back, size: 15),
                          const SizedBox(width: 3),
                          MyText(text: "Back", size: 14, weight: FontWeight.w600),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyText(
                        text: "Sync Across Devices",
                        size: 20,
                        weight: FontWeight.w600),
                    const SizedBox(height: 5),
                    MyText(
                      text:
                          "Pick a username and PIN. Enter the same username and PIN on another device to open this account there.",
                      size: 13,
                      weight: FontWeight.w500,
                      color: kTextColor,
                    ),
                    if (_currentUsername != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          color: const Color(0x199CAF88),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: MyText(
                          text: "Your username: $_currentUsername",
                          size: 14,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    MyText(
                      text: _currentUsername == null
                          ? "SET UP YOUR USERNAME"
                          : "UPDATE USERNAME / PIN",
                      size: 12,
                      weight: FontWeight.w600,
                      color: kTextColor,
                    ),
                    const SizedBox(height: 8),
                    MyTextField(controller: _setupUser, label: "Username"),
                    MyTextField(
                      controller: _setupPin,
                      label: "PIN (4+ digits)",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 6),
                    _button(
                      label: "Save Username",
                      loading: _savingSetup,
                      onTap: _setup,
                    ),
                    const SizedBox(height: 22),
                    const Divider(thickness: 0.5),
                    const SizedBox(height: 12),
                    MyText(
                      text: "RESTORE ON THIS DEVICE",
                      size: 12,
                      weight: FontWeight.w600,
                      color: kTextColor,
                    ),
                    const SizedBox(height: 4),
                    MyText(
                      text:
                          "Have an account already? Enter its username and PIN to load it here.",
                      size: 12,
                      weight: FontWeight.w500,
                      color: kTextColor,
                    ),
                    const SizedBox(height: 8),
                    MyTextField(controller: _restoreUser, label: "Username"),
                    MyTextField(
                      controller: _restorePin,
                      label: "PIN",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 6),
                    _button(
                      label: "Restore Account",
                      loading: _savingRestore,
                      filled: false,
                      onTap: _restore,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _button({
    required String label,
    required bool loading,
    required VoidCallback onTap,
    bool filled = true,
  }) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: ShapeDecoration(
          color: filled ? const Color(0xFF1F3A5F) : kQuaternaryColor,
          shape: RoundedRectangleBorder(
            side: filled
                ? BorderSide.none
                : const BorderSide(color: Color(0xFF1F3A5F)),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : MyText(
                  text: label,
                  size: 15,
                  weight: FontWeight.w600,
                  color: filled ? kQuaternaryColor : const Color(0xFF1F3A5F),
                ),
        ),
      ),
    );
  }
}
