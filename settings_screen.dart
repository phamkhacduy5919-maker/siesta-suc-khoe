import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/y2k_theme.dart';
import '../providers/soul_battery_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _pickCustomVoice(BuildContext context) async {
    final soul = context.read<SoulBatteryProvider>();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'ogg', 'm4a'],
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final name = result.files.single.name;
        await soul.setCustomVoiceFile(path, name);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Y2kTheme.surfaceElevated,
              content: Text(
                'Đã cài đặt giọng Siesta từ file: $name',
                style: const TextStyle(color: Y2kTheme.neonCyan, fontFamily: 'monospace'),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Y2kTheme.warningCrimson,
            content: Text('Lỗi khi chọn file: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final soul = context.watch<SoulBatteryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CÀI ĐẶT // SIESTA CONFIG'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // MỤC 1: GIỌNG NÓI SIESTA CUSTOM
          _buildSectionHeader('TÀI NGUYÊN GIỌNG NÓI MA MỊ (CUSTOM VOICE)'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Y2kTheme.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Y2kTheme.borderDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Chọn file âm thanh (.wav / .mp3) từ bộ nhớ máy Oppo A5 Pro 5G để làm giọng nói cảnh báo của Siesta:',
                  style: TextStyle(fontSize: 12, color: Y2kTheme.textMuted),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Y2kTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Y2kTheme.neonPurple.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.audio_file, color: Y2kTheme.neonCyan),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          soul.customVoiceName ?? 'Mặc định: Giọng Tổng Hợp U Buồn (Synth TTS)',
                          style: const TextStyle(fontSize: 12, color: Y2kTheme.textBright),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (soul.customVoiceName != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18, color: Y2kTheme.warningCrimson),
                          onPressed: () => soul.clearCustomVoice(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickCustomVoice(context),
                        icon: const Icon(Icons.file_upload_outlined, size: 18),
                        label: const Text('QUÉT & CHỌN FILE'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Y2kTheme.neonPurple),
                        foregroundColor: Y2kTheme.neonPurple,
                      ),
                      onPressed: () => soul.testPlayVoiceWarning(),
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('NGHE THỬ'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MỤC 2: ĐỔI AVATAR / ICON SIESTA
          _buildSectionHeader('HÌNH THÁI SIESTA (AVATAR & ICON)'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Y2kTheme.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Y2kTheme.borderDark),
            ),
            child: Column(
              children: [
                _buildAvatarOption(
                  context,
                  id: 'gothic_wraith',
                  title: 'Bóng Ma Tĩnh Lặng (Gothic Wraith)',
                  subtitle: 'Y2K Cyber Glitch - Tông Tím U Buồn',
                  isSelected: soul.selectedAvatarId == 'gothic_wraith',
                  onSelect: () => soul.setAvatar('gothic_wraith'),
                ),
                const Divider(color: Y2kTheme.borderDark),
                _buildAvatarOption(
                  context,
                  id: 'broken_doll',
                  title: 'Búp Bê Vỡ (Broken Doll)',
                  subtitle: 'Đôi mắt vô hồn - Tông Xanh Neon Lạnh Lẽo',
                  isSelected: soul.selectedAvatarId == 'broken_doll',
                  onSelect: () => soul.setAvatar('broken_doll'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // MỤC 3: CẤU HÌNH TỐI ƯU OPPO A5 PRO 5G
          _buildSectionHeader('TỐI ƯU PIN & NHIỆT ĐỘ (OPPO A5 PRO 5G)'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Y2kTheme.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Y2kTheme.borderDark),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: Y2kTheme.neonCyan,
                  title: const Text(
                    'CHẾ ĐỘ QUÉT NGẮT QUÃNG 2P / 30P',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Y2kTheme.textBright),
                  ),
                  subtitle: const Text(
                    'Bật Camera 2 phút sau mỗi 30 phút. Tránh quá nhiệt chip Dimensity 6300.',
                    style: TextStyle(fontSize: 11, color: Y2kTheme.textMuted),
                  ),
                  value: soul.isIntermittentScanEnabled,
                  onChanged: (val) => soul.setIntermittentScan(val),
                ),
                const Divider(color: Y2kTheme.borderDark),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: Y2kTheme.neonPurple,
                  title: const Text(
                    'RUNG PHẢN HỒI Y2K KHI TƯ THẾ XẤU',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Y2kTheme.textBright),
                  ),
                  subtitle: const Text(
                    'Rung nhịp đôi cảnh báo khi phát hiện cúi đầu quá 25 độ.',
                    style: TextStyle(fontSize: 11, color: Y2kTheme.textMuted),
                  ),
                  value: soul.isVibrationEnabled,
                  onChanged: (val) => soul.setVibration(val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        '// $title //',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Y2kTheme.neonCyan,
        ),
      ),
    );
  }

  Widget _buildAvatarOption(
    BuildContext context, {
    required String id,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return InkWell(
      onTap: onSelect,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Y2kTheme.neonCyan : Y2kTheme.borderDark,
                  width: 2,
                ),
                color: Y2kTheme.surfaceElevated,
              ),
              child: Icon(
                id == 'gothic_wraith' ? Icons.nightlife : Icons.face_retouching_natural,
                color: isSelected ? Y2kTheme.neonCyan : Y2kTheme.textMuted,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Y2kTheme.neonCyan : Y2kTheme.textBright,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10.5, color: Y2kTheme.textMuted),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Y2kTheme.neonCyan, size: 20),
          ],
        ),
      ),
    );
  }
}
