class AppFonts {
  /// Bundled DMSans font (declared in pubspec under fonts:).
  /// Using the bundled family avoids google_fonts fetching over the network
  /// at runtime, which was causing a long white-screen delay on launch.
  static const String dmSans = 'DMSans';
}
