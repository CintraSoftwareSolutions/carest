import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

/// Plays optional calm background music. The client's specific track can be
/// supplied via app_config.musicTrackUrl (or bundled at assets/audio/background.mp3).
/// Respects the user's "Enable Music" setting. Fades and loops gently.
class AudioService extends GetxService {
  static AudioService get to => Get.find();

  final AudioPlayer _player = AudioPlayer();
  final RxBool enabled = true.obs;
  bool _hasSource = false;
  String? _trackUrl;

  Future<AudioService> init({required bool musicEnabled, String? trackUrl}) async {
    enabled.value = musicEnabled;
    _trackUrl = (trackUrl != null && trackUrl.isNotEmpty) ? trackUrl : null;
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.35);
    } catch (_) {}
    if (enabled.value) {
      // Fire and forget — don't block startup.
      play();
    }
    return this;
  }

  Future<void> play() async {
    if (!enabled.value) return;
    try {
      if (_trackUrl != null) {
        await _player.play(UrlSource(_trackUrl!));
        _hasSource = true;
      } else {
        // Try a bundled asset if the client later drops one in.
        await _player.play(AssetSource('audio/background.mp3'));
        _hasSource = true;
      }
    } catch (_) {
      // No track available — silently do nothing.
      _hasSource = false;
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }

  Future<void> setEnabled(bool value) async {
    enabled.value = value;
    if (value) {
      await play();
    } else {
      await stop();
    }
  }

  bool get isPlaying => _hasSource && enabled.value;

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
