import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class SoulBatteryProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _ambientPlayer = AudioPlayer();

  bool _isLoggedIn = true;
  String _soulId = 'SIE-OPPO-5G';

  int _batteryLevel = 88;
  String _soulStage = 'Thanh Tịnh';
  int _screenTimeMinutes = 74; // Đã sử dụng 1h 14p

  int _neckAngle = 12; // Góc cúi đầu (12° là tốt)
  int _blinkRate = 18; // 18 nhịp chớp/phút (chuẩn)

  String _siestaWhisper = 'Linh hồn ngươi còn sáng trong... Đừng để ánh sáng xanh nuốt chửng nó.';

  // Custom Voice State
  String? _customVoicePath;
  String? _customVoiceName;

  // Avatar & Theme
  String _selectedAvatarId = 'gothic_wraith';

  // Oppo A5 Pro 5G Hardware settings
  bool _isIntermittentScanEnabled = true;
  bool _isVibrationEnabled = true;

  // Ambient Lo-Fi Player
  bool _isPlayingAmbient = false;
  double _ambientVolume = 0.5;
  String _currentTrackTitle = 'Cõi Mộng Siesta (432Hz Ambient Drone)';

  Timer? _screenTimeTimer;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get soulId => _soulId;
  int get batteryLevel => _batteryLevel;
  String get soulStage => _soulStage;
  int get screenTimeMinutes => _screenTimeMinutes;
  int get neckAngle => _neckAngle;
  int get blinkRate => _blinkRate;
  String get siestaWhisper => _siestaWhisper;
  String? get customVoicePath => _customVoicePath;
  String? get customVoiceName => _customVoiceName;
  String get selectedAvatarId => _selectedAvatarId;
  bool get isIntermittentScanEnabled => _isIntermittentScanEnabled;
  bool get isVibrationEnabled => _isVibrationEnabled;
  bool get isPlayingAmbient => _isPlayingAmbient;
  double get ambientVolume => _ambientVolume;
  String get currentTrackTitle => _currentTrackTitle;

  String get formattedScreenTime {
    final hours = _screenTimeMinutes ~/ 60;
    final mins = _screenTimeMinutes % 60;
    if (hours == 0) return '$mins phút';
    return '${hours}h ${mins < 10 ? '0' : ''}$mins p';
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _customVoicePath = prefs.getString('custom_voice_path');
    _customVoiceName = prefs.getString('custom_voice_name');
    _selectedAvatarId = prefs.getString('avatar_id') ?? 'gothic_wraith';
    _isIntermittentScanEnabled = prefs.getBool('intermittent_scan') ?? true;
    _isVibrationEnabled = prefs.getBool('vibration_enabled') ?? true;

    // Bắt đầu đếm thời gian màn hình
    _screenTimeTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _screenTimeMinutes += 1;
      _recalculateSoulBattery();
      notifyListeners();
    });

    notifyListeners();
  }

  void setLoggedIn(bool value, String soulId) {
    _isLoggedIn = value;
    _soulId = soulId;
    notifyListeners();
  }

  void updatePostureMetrics({required int angle, required int blinkRate}) {
    _neckAngle = angle;
    _blinkRate = blinkRate;
    _recalculateSoulBattery();
    notifyListeners();
  }

  void _recalculateSoulBattery() {
    // Hao hụt theo Screen Time
    final timeDrain = (_screenTimeMinutes / 360) * 40; // Giảm tối đa 40% trong 6 tiếng

    // Hao hụt theo tư thế cúi đầu (>15°)
    final angleDeficit = (_neckAngle > 15) ? ((_neckAngle - 15) / 30) * 35 : 0.0;

    // Hao hụt theo nhịp chớp mắt (<15 bpm)
    final blinkDeficit = (_blinkRate < 15) ? ((15 - _blinkRate) / 10) * 25 : 0.0;

    final raw = 100 - (timeDrain + angleDeficit + blinkDeficit);
    _batteryLevel = raw.clamp(0, 100).toInt();

    if (_batteryLevel >= 75) {
      _soulStage = 'Thanh Tịnh';
      _siestaWhisper = 'Linh hồn ngươi còn sáng trong... Hãy giữ nhịp thở tĩnh tại.';
    } else if (_batteryLevel >= 45) {
      _soulStage = 'Tiêu Hao';
      _siestaWhisper = 'Trục xương sống bắt đầu lệch... Bóng tối đang ngấm dần vào khớp cổ.';
    } else if (_batteryLevel >= 20) {
      _soulStage = 'Hư Vô';
      _siestaWhisper = 'Mắt ngươi khô rát như tro tàn. Hãy ngẩng đầu lên trước khi gãy khúc!';
    } else {
      _soulStage = 'Tuyệt Diệt';
      _siestaWhisper = 'CẢNH BÁO: Cột sống thoái hóa cấp tính! Ngừng nhìn màn hình ngay lập tức!';
    }
  }

  Future<void> triggerEerieWarning({required String dialogue, required bool isSevere}) async {
    _siestaWhisper = dialogue;

    if (_isVibrationEnabled) {
      if (await Vibration.hasVibrator() ?? false) {
        if (isSevere) {
          Vibration.vibrate(pattern: [0, 200, 100, 400]);
        } else {
          Vibration.vibrate(duration: 150);
        }
      }
    }

    // Phát âm thanh custom nếu có, hoặc dùng âm thanh cảnh báo mẫu
    if (_customVoicePath != null) {
      try {
        await _audioPlayer.play(DeviceFileSource(_customVoicePath!));
      } catch (_) {
        // Fallback
      }
    }

    notifyListeners();
  }

  Future<void> setCustomVoiceFile(String path, String name) async {
    _customVoicePath = path;
    _customVoiceName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_voice_path', path);
    await prefs.setString('custom_voice_name', name);
    notifyListeners();
  }

  Future<void> clearCustomVoice() async {
    _customVoicePath = null;
    _customVoiceName = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('custom_voice_path');
    await prefs.remove('custom_voice_name');
    notifyListeners();
  }

  Future<void> testPlayVoiceWarning() async {
    if (_customVoicePath != null) {
      try {
        await _audioPlayer.play(DeviceFileSource(_customVoicePath!));
      } catch (e) {
        debugPrint('Lỗi phát âm thanh: $e');
      }
    } else {
      // Giọng thử nghiệm
      _siestaWhisper = 'Ta là Siesta... Ngươi đã nghe thấy lời thì thầm của ta chưa?';
      notifyListeners();
    }
  }

  void setAvatar(String avatarId) async {
    _selectedAvatarId = avatarId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_id', avatarId);
    notifyListeners();
  }

  void setIntermittentScan(bool val) async {
    _isIntermittentScanEnabled = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intermittent_scan', val);
    notifyListeners();
  }

  void setVibration(bool val) async {
    _isVibrationEnabled = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', val);
    notifyListeners();
  }

  void toggleAmbientMusic() {
    _isPlayingAmbient = !_isPlayingAmbient;
    notifyListeners();
  }

  void setAmbientVolume(double volume) {
    _ambientVolume = volume;
    _ambientPlayer.setVolume(volume);
    notifyListeners();
  }

  @override
  void dispose() {
    _screenTimeTimer?.cancel();
    _audioPlayer.dispose();
    _ambientPlayer.dispose();
    super.dispose();
  }
}
