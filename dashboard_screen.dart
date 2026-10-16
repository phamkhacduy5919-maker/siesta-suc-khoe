import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/y2k_theme.dart';
import '../providers/soul_battery_provider.dart';
import '../services/ai_siesta_service.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final soul = context.watch<SoulBatteryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIESTA // TRẠM LINH HỒN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Y2kTheme.neonPurple),
            tooltip: 'Cài đặt Siesta',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thẻ hiển thị thiết bị tối ưu Oppo A5 Pro 5G
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Y2kTheme.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Y2kTheme.borderDark),
              ),
              child: Row(
                children: [
                  const Icon(Icons.developer_board, size: 16, color: Y2kTheme.neonCyan),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'THIẾT BỊ: OPPO A5 PRO 5G // QUÉT NỀN: 2P / 30P',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.2,
                        color: Y2kTheme.textBright,
                      ),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Y2kTheme.soulGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // THANG ĐO NĂNG LƯỢNG LINH HỒN (BATTERY OF SOUL)
            _buildSoulBatteryCard(context, soul),
            const SizedBox(height: 20),

            // THỐNG KÊ SCREEN TIME & TƯ THẾ
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    title: 'SCREEN TIME',
                    value: soul.formattedScreenTime,
                    subtitle: 'Hao mòn thực tại',
                    icon: Icons.timer_outlined,
                    accentColor: Y2kTheme.neonPurple,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildMetricTile(
                    title: 'GÓC CÚI ĐẦU',
                    value: '${soul.neckAngle}°',
                    subtitle: soul.neckAngle > 25 ? 'Nguy cơ vỡ vụn' : 'Thanh thoát',
                    icon: Icons.accessibility_new,
                    accentColor: soul.neckAngle > 25 ? Y2kTheme.warningCrimson : Y2kTheme.neonCyan,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // TRÌNH PHÁT NHẠC AMBIENT / LO-FI MA MỊ
            _buildAmbientPlayerCard(context, soul),
            const SizedBox(height: 20),

            // NÚT KÍCH HOẠT QUÉT THẦN THỨC BẰNG CAMERA TRƯỚC
            ElevatedButton.icon(
              onPressed: () async {
                final aiService = AiSiestaService();
                await aiService.triggerLivePostureCheck(context);
              },
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.black),
              label: const Text('BẮT ĐẦU QUÉT CAMERA TRƯỚC (2 PHÚT)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Y2kTheme.neonCyan,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Lưu ý: Tự động giải phóng Camera sau 2 phút để máy Oppo luôn mát.',
                style: TextStyle(fontSize: 10, color: Y2kTheme.textMuted.withOpacity(0.7)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoulBatteryCard(BuildContext context, SoulBatteryProvider soul) {
    Color gaugeColor = Y2kTheme.neonCyan;
    if (soul.batteryLevel < 30) {
      gaugeColor = Y2kTheme.warningCrimson;
    } else if (soul.batteryLevel < 60) {
      gaugeColor = Y2kTheme.neonPurple;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Y2kTheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: gaugeColor.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: gaugeColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '// NĂNG LƯỢNG LINH HỒN //',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Y2kTheme.textBright,
                ),
              ),
              Text(
                '[ TRẠNG THÁI: ${soul.soulStage.toUpperCase()} ]',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: gaugeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Vòng tròn Gauge % Năng lượng
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: soul.batteryLevel / 100,
                  strokeWidth: 10,
                  backgroundColor: Y2kTheme.borderDark,
                  color: gaugeColor,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${soul.batteryLevel}%',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: gaugeColor,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(color: gaugeColor, blurRadius: 12),
                      ],
                    ),
                  ),
                  const Text(
                    'SOUL BATTERY',
                    style: TextStyle(fontSize: 9, color: Y2kTheme.textMuted, letterSpacing: 1.5),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Lời thì thầm của Siesta
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Y2kTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Y2kTheme.borderDark),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline, size: 16, color: Y2kTheme.neonPurple),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '"${soul.siestaWhisper}"',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 11.5,
                      color: Y2kTheme.textBright,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Y2kTheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Y2kTheme.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 10, letterSpacing: 1.2, color: Y2kTheme.textMuted),
              ),
              Icon(icon, size: 18, color: accentColor),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accentColor,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: Y2kTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientPlayerCard(BuildContext context, SoulBatteryProvider soul) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Y2kTheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Y2kTheme.neonPurple.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.music_note, color: Y2kTheme.neonPurple, size: 18),
              const SizedBox(width: 8),
              const Text(
                'ÂM THANH CHỮA LÀNH // 432HZ BINAURAL BEATS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Y2kTheme.neonPurple,
                ),
              ),
              const Spacer(),
              if (soul.isPlayingAmbient)
                const Text(
                  '• ĐANG PHÁT',
                  style: TextStyle(color: Y2kTheme.soulGreen, fontSize: 10, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            soul.currentTrackTitle,
            style: const TextStyle(fontSize: 13, color: Y2kTheme.textBright, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  soul.isPlayingAmbient ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  size: 38,
                  color: Y2kTheme.neonCyan,
                ),
                onPressed: () => soul.toggleAmbientMusic(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Slider(
                      value: soul.ambientVolume,
                      min: 0.0,
                      max: 1.0,
                      activeColor: Y2kTheme.neonCyan,
                      inactiveColor: Y2kTheme.borderDark,
                      onChanged: (val) => soul.setAmbientVolume(val),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
