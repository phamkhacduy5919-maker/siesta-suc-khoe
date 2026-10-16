import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/y2k_theme.dart';
import '../providers/soul_battery_provider.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _soulIdController = TextEditingController(text: 'SIE-OPPO-5G');
  final _secretKeyController = TextEditingController(text: '••••••••');
  bool _isRegistering = false;
  late AnimationController _glitchController;

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glitchController.dispose();
    _soulIdController.dispose();
    _secretKeyController.dispose();
    super.dispose();
  }

  void _submit() {
    final soulProvider = context.read<SoulBatteryProvider>();
    soulProvider.setLoggedIn(true, _soulIdController.text.trim());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nền xám đen huyền bí có hạt chấm Cyber
          Positioned.fill(
            child: Container(
              color: Y2kTheme.background,
              child: CustomPaint(
                painter: Y2kGridPainter(),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar Siesta Ma Mị
                    AnimatedBuilder(
                      animation: _glitchController,
                      builder: (context, child) {
                        return Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _glitchController.value > 0.5 
                                ? Y2kTheme.neonPurple 
                                : Y2kTheme.neonCyan,
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Y2kTheme.neonPurple.withOpacity(0.4),
                                blurRadius: 25,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.remove_red_eye_outlined,
                              size: 48,
                              color: Y2kTheme.neonCyan,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Tiêu đề App Y2K
                    const Text(
                      'SIESTA SỨC KHỎE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4.0,
                        color: Y2kTheme.neonCyan,
                        shadows: [
                          Shadow(color: Y2kTheme.neonCyan, blurRadius: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '// HỆ THỐNG GIÁM SÁT LINH HỒN & CỘT SỐNG //',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Y2kTheme.textMuted,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Form Đăng nhập / Đăng ký
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Y2kTheme.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Y2kTheme.borderDark),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isRegistering ? '[ ĐĂNG KÝ MÃ THỂ THỨC ]' : '[ KẾT NỐI LINH HỒN ]',
                            style: const TextStyle(
                              color: Y2kTheme.neonPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _soulIdController,
                            style: const TextStyle(color: Y2kTheme.textBright, fontSize: 14),
                            decoration: const InputDecoration(
                              labelText: 'MÃ THỂ THỨC (SOUL ID)',
                              prefixIcon: Icon(Icons.fingerprint, color: Y2kTheme.neonCyan, size: 20),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _secretKeyController,
                            obscureText: true,
                            style: const TextStyle(color: Y2kTheme.textBright, fontSize: 14),
                            decoration: const InputDecoration(
                              labelText: 'TẦN SỐ BÍ MẬT (PASSKEY)',
                              prefixIcon: Icon(Icons.lock_outline, color: Y2kTheme.neonPurple, size: 20),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              _isRegistering ? 'KHỞI TẠO LINH HỒN' : 'ĐỒNG BỘ THẦN THỨC',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Chuyển đổi Đăng nhập / Đăng ký
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRegistering = !_isRegistering;
                        });
                      },
                      child: Text(
                        _isRegistering
                            ? '< Trở lại giao thức Kết Nối >'
                            : '< Chưa có tần số? Đăng ký tại đây >',
                        style: const TextStyle(
                          color: Y2kTheme.textMuted,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Y2kGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF171B26)
      ..strokeWidth = 0.5;

    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
