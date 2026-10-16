# SIESTA SỨC KHỎE - HƯỚNG DẪN CÀI ĐẶT & BIÊN DỊCH APK (OPPO A5 PRO 5G)

Chào mừng bạn đến với mã nguồn hoàn chỉnh của ứng dụng **Siesta Sức Khỏe** phong cách Y2K ma mị.

---

## 1. YÊU CẦU MÔI TRƯỜNG MÁY TÍNH
- **Flutter SDK**: Phiên bản >= 3.19.0 (Khuyên dùng Flutter 3.22+).
- **Android Studio / Java**: JDK 17.
- **Android SDK Tools**: Build-Tools 34.0.0.

---

## 2. HƯỚNG DẪN THỰC THI DỰ ÁN TRÊN MÁY TÍNH

### Bước 1: Khởi tạo Project Flutter mới
Mở Terminal hoặc Command Prompt trên máy tính của bạn và gõ:
```bash
flutter create --org com.example siesta_suc_khoe
cd siesta_suc_khoe
```

### Bước 2: Thay thế các file mã nguồn
Sao chép hoặc tải các file từ bộ sinh mã này vào các thư mục tương ứng:
1. `pubspec.yaml` -> Gốc thư mục `siesta_suc_khoe/`
2. `android/app/src/main/AndroidManifest.xml`
3. `android/app/build.gradle`
4. Toàn bộ thư mục `lib/`:
   - `lib/main.dart`
   - `lib/theme/y2k_theme.dart`
   - `lib/screens/login_screen.dart`
   - `lib/screens/dashboard_screen.dart`
   - `lib/screens/settings_screen.dart`
   - `lib/services/ai_siesta_service.dart`
   - `lib/services/background_service.dart`
   - `lib/providers/soul_battery_provider.dart`

### Bước 3: Tải các thư viện phụ thuộc
```bash
flutter pub get
```

---

## 3. CÀI ĐẶT & TỐI ƯU HÓA TRÊN OPPO A5 PRO 5G (ColorOS 14)

Để dịch vụ chạy nền định kỳ (2 phút mỗi 30 phút) hoạt động mượt mà mà không bị ColorOS tự động ngắt:

1. **Bật Tùy chọn nhà phát triển (Developer Options)**:
   - Vào *Cài đặt* -> *Giới thiệu thiết bị* -> *Phiên bản* -> Nhấn liên tục 7 lần vào *Số bản dựng (Build Number)*.
   - Quay lại *Cài đặt bổ sung* -> *Tùy chọn nhà phát triển* -> Bật **Gỡ lỗi USB (USB Debugging)**.

2. **Cấu hình Quản lý Pin (Không hạn chế nền)**:
   - Vào *Cài đặt* -> *Pin* -> *Cài đặt khác* -> *Tối ưu hóa mức sử dụng pin*.
   - Tìm ứng dụng **Siesta Sức Khỏe** -> Chọn **Không tối ưu hóa (Don't optimize)**.
   - Bật thêm: *Cho phép hoạt động dưới nền (Allow background activity)* và *Tự khởi động (Auto-launch)*.

3. **Khóa ứng dụng trong Đa nhiệm**:
   - Mở màn hình đa nhiệm (Recent Apps) -> Nhấn vào dấu 3 chấm góc trên thẻ Siesta Sức Khỏe -> Chọn **Khóa (Lock)**.

---

## 4. BIÊN DỊCH FILE APK HOÀN CHỈNH

Cắm cáp USB nối Oppo A5 Pro 5G với máy tính, sau đó chạy lệnh:

```bash
# Biên dịch file APK Release tối ưu cho chip 64-bit
flutter build apk --release --target-platform android-arm64
```

Sau khi biên dịch xong, file APK hoàn chỉnh sẽ nằm tại:
`build/app/outputs/flutter-apk/app-release.apk`

Cài trực tiếp lên Oppo A5 Pro 5G bằng lệnh:
```bash
flutter install
```
