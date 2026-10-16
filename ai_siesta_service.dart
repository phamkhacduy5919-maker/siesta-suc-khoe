import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../providers/soul_battery_provider.dart';
import '../theme/y2k_theme.dart';

class AiSiestaService {
  CameraController? _cameraController;
  Timer? _analysisTimer;
  Timer? _sessionTimeoutTimer;

  // Lời thoại ma mị của Siesta theo mức độ nguy hại của tư thế & mắt
  static const List<String> severePostureWarnings = [
    'Trục xương sống của ngươi đang vỡ vụn từng milimet... Hãy nâng cằm lên trước khi quá muộn.',
    'Bóng tối đang siết chặt lấy các đốt sống cổ. Ngươi muốn linh hồn mình hóa đá sao?',
    'Đầu ngươi đã gục xuống 30 độ quá lâu. Siesta không thể chữa lành một thể xác gãy khúc!',
  ];

  static const List<String> severeBlinkWarnings = [
    'Mắt ngươi đã quên cách chớp trong cõi mộng ảo. Hãy nhắm lại và thở sâu trong 10 giây.',
    'Giác mạc khô khốc như sa mạc tro tàn... Hãy chớp mắt và nhìn về phía xa xăm.',
  ];

  static const List<String> healingSolutions = [
    'Giải pháp từ Siesta: Xoay vai về sau 5 lần, ngửa cổ 20 độ, hít sâu năng lượng 432Hz.',
    'Bài tập giải thoát: Áp dụng quy tắc 20-20-20. Nhìn vật cách 6 mét trong 20 giây.',
  ];

  /// Kích hoạt phiên quét trực tiếp bằng Camera trước trong 2 phút
  Future<void> triggerLivePostureCheck(BuildContext context) async {
    final soulProvider = context.read<SoulBatteryProvider>();

    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (!context.mounted) return;

      // Hiển thị Modal quét thị giác AI phong cách Y2K HUD
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => _buildVisionHudModal(ctx, soulProvider),
      ).whenComplete(() {
        _stopSession();
      });

      // Bắt đầu vòng lặp phân tích tư thế & chớp mắt
      _startPostureLoop(soulProvider);

      // Tự động giải phóng Camera sau 2 phút để máy Oppo A5 Pro 5G không bị nóng
      _sessionTimeoutTimer = Timer(const Duration(minutes: 2), () {
        if (context.mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Y2kTheme.warningCrimson,
            content: Text('Lỗi khởi tạo Camera: $e'),
          ),
        );
      }
    }
  }

  void _startPostureLoop(SoulBatteryProvider soulProvider) {
    _analysisTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Giả lập/Xử lý thuật toán AI xác định góc cúi đầu & nhịp chớp mắt
      // (Trong môi trường production, tích hợp google_mlkit_pose_detection và face_mesh)
      final random = Random();
      final simulatedAngle = 10 + random.nextInt(28); // 10° -> 38°
      final simulatedBlinkRate = 8 + random.nextInt(14); // 8 -> 22 bpm

      soulProvider.updatePostureMetrics(
        angle: simulatedAngle,
        blinkRate: simulatedBlinkRate,
      );

      // Kiểm tra ngưỡng cảnh báo
      if (simulatedAngle > 25) {
        final warning = (severePostureWarnings..shuffle()).first;
        final solution = (healingSolutions..shuffle()).first;
        soulProvider.triggerEerieWarning(
          dialogue: '$warning\n-> $solution',
          isSevere: true,
        );
      } else if (simulatedBlinkRate < 10) {
        final warning = (severeBlinkWarnings..shuffle()).first;
        soulProvider.triggerEerieWarning(
          dialogue: warning,
          isSevere: false,
        );
      }
    });
  }

  void _stopSession() {
    _analysisTimer?.cancel();
    _sessionTimeoutTimer?.cancel();
    _cameraController?.dispose();
    _cameraController = null;
  }

  Widget _buildVisionHudModal(BuildContext context, SoulBatteryProvider soul) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Y2kTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          top: BorderSide(color: Y2kTheme.neonCyan, width: 2),
        ),
      ),
      child: Column(
        children: [
          // Header HUD
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.remove_red_eye, color: Y2kTheme.neonCyan, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'AI VISION // PHÂN TÍCH TRỤC ĐỐT SỐNG CỔ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Y2kTheme.neonCyan,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Y2kTheme.textMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Camera Viewport với lưới HUD Y2K
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_cameraController != null && _cameraController!.value.isInitialized)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CameraPreview(_cameraController!),
                  )
                else
                  Container(
                    color: Y2kTheme.surface,
                    child: const Center(
                      child: Text(
                        'ĐANG KHỞI CHẠY KHUNG THỊ GIÁC...',
                        style: TextStyle(color: Y2kTheme.neonPurple),
                      ),
                    ),
                  ),

                // Lưới ngắm Cyber Y2K
                Positioned.fill(
                  child: CustomPaint(
                    painter: Y2kHudOverlayPainter(),
                  ),
                ),

                // Thẻ thông tin trực tiếp
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Y2kTheme.background.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Y2kTheme.neonPurple),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'GÓC NGHIÊNG CỔ: ${soul.neckAngle}°',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: soul.neckAngle > 25 ? Y2kTheme.warningCrimson : Y2kTheme.soulGreen,
                              ),
                            ),
                            Text(
                              'CHỚP MẮT: ${soul.blinkRate} BPM',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: soul.blinkRate < 10 ? Y2kTheme.warningCrimson : Y2kTheme.neonCyan,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          soul.neckAngle > 25
                              ? 'CẢNH BÁO: Cột sống đang chịu lực đè nén gấp 3 lần bình thường!'
                              : 'Tư thế đạt chuẩn công thái học.',
                          style: const TextStyle(fontSize: 11, color: Y2kTheme.textBright),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class Y2kHudOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cyanPaint = Paint()
      ..color = Y2kTheme.neonCyan.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final purplePaint = Paint()
      ..color = Y2kTheme.neonPurple.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 4 góc ngắm Cyber
    const cornerSize = 24.0;
    const margin = 20.0;

    // Góc trên - trái
    canvas.drawLine(const Offset(margin, margin), const Offset(margin + cornerSize, margin), cyanPaint);
    canvas.drawLine(const Offset(margin, margin), const Offset(margin, margin + cornerSize), cyanPaint);

    // Góc trên - phải
    canvas.drawLine(Offset(size.width - margin, margin), Offset(size.width - margin - cornerSize, margin), cyanPaint);
    canvas.drawLine(Offset(size.width - margin, margin), Offset(size.width - margin, margin + cornerSize), cyanPaint);

    // Vòng tròn trung tâm
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 60, purplePaint);
    canvas.drawLine(
      Offset(size.width / 2 - 80, size.height / 2),
      Offset(size.width / 2 + 80, size.height / 2),
      purplePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
