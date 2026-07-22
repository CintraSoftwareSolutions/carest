import 'package:flutter/material.dart';

import 'privacy_policy_screen.dart';

class TermAndConditionScreen extends StatelessWidget {
  const TermAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocView(
      titleFallback: "Terms & Conditions",
      which: "terms",
    );
  }
}
