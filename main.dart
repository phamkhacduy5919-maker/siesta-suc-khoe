import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/y2k_theme.dart';
import 'providers/soul_battery_provider.dart';
import 'services/background_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khóa hướng màn hình dọc chuẩn điện thoại Oppo A5 Pro 5G
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Cấu hình thanh trạng thái trong suốt hòa hợp với chủ đề Y2K Obsidian
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF090A0F),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Khởi tạo Background Service (quét ngắt quãng 2 phút mỗi 30 phút)
  await initializeBackgroundService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SoulBatteryProvider()..initialize()),
      ],
      child: const SiestaApp(),
    ),
  );
}

class SiestaApp extends StatelessWidget {
  const SiestaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final soulProvider = context.watch<SoulBatteryProvider>();

    return MaterialApp(
      title: 'Siesta Sức Khỏe',
      debugShowCheckedModeBanner: false,
      theme: Y2kTheme.darkTheme,
      home: soulProvider.isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}
