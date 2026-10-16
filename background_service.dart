import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const notificationChannelId = 'siesta_health_channel';
const notificationId = 888;

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'Siesta Sức Khỏe - Giám sát linh hồn',
    description: 'Kênh thông báo bảo vệ cột sống và phục hồi năng lượng định kỳ',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'Siesta Sức Khỏe đang túc trực',
      initialNotificationContent: 'Chế độ ngắt quãng: Bảo vệ Oppo A5 Pro 5G (Quét 2p/30p)',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Chu kỳ quét ngắt quãng:
  // Chờ 30 phút -> Kích hoạt quét nhanh 2 phút -> Đưa về trạng thái ngủ sâu (Deep Sleep)
  Timer.periodic(const Duration(minutes: 30), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          notificationId,
          'Siesta // Đang quét thần thức 2 phút',
          'Đang kiểm tra độ nghiêng đầu và nhịp chớp mắt...',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'Siesta Sức Khỏe',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        // Sau 2 phút, đưa về trạng thái chờ
        Future.delayed(const Duration(minutes: 2), () {
          flutterLocalNotificationsPlugin.show(
            notificationId,
            'Siesta Sức Khỏe đang ngủ đông',
            'Sẽ quét lại sau 28 phút để giữ máy Oppo A5 Pro 5G luôn mát.',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                notificationChannelId,
                'Siesta Sức Khỏe',
                icon: 'ic_bg_service_small',
                ongoing: true,
              ),
            ),
          );
        });
      }
    }
  });
}
