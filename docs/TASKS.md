# Lộ trình Phát triển và Danh sách Nhiệm vụ (TASKS.md)

Tài liệu này vạch ra lộ trình phát triển chi tiết cho ứng dụng nghe nhạc đa nền tảng. Các nhiệm vụ được sắp xếp theo thứ tự logic từ dễ đến khó, giúp xây dựng ứng dụng từng bước một cách vững chắc.

---

## 📅 Lộ trình Phát triển & Danh sách Nhiệm vụ

### Phase 1: Setup & Theme (Cấu hình Ban đầu & Giao diện)
*Thiết lập dự án, cài đặt các thư viện cần thiết và xây dựng hệ thống Design Tokens độc bản.*

- [x] **Task 1.1:** Khai báo đầy đủ các dependencies cần thiết trong file `pubspec.yaml` (`flutter_riverpod`, `just_audio`, `audio_service`, `dio`, `hive_flutter`, `path_provider`, `flutter_svg`, `google_fonts`, v.v.).
- [x] **Task 1.2:** Thiết lập hệ thống thư mục Feature-First chuẩn theo tài liệu `ARCHITECTURE.md` (`lib/core/`, `lib/features/auth/`, `lib/features/home/`, v.v.).
- [x] **Task 1.3:** Định nghĩa Stitch Color Palette và cấu hình Dark Theme mặc định trong `lib/core/theme/app_theme.dart`.
- [x] **Task 1.4:** Tích hợp thư viện `liquid_glass_widgets` và hoàn thiện widget dùng chung `LiquidGlassCard` chuẩn Liquid Glass Dark Mode (với shader khúc xạ, specular rim highlights và squircle superellipse).

---

### Phase 2: Data Models (Thiết kế Mô hình Dữ liệu)
*Xác định cấu trúc dữ liệu cho toàn bộ ứng dụng, đảm bảo tính chặt chẽ, an toàn kiểu dữ liệu và hỗ trợ chuyển đổi JSON.*

- [x] **Task 2.1:** Thiết kế `UserModel` và `AuthState` hỗ trợ thông tin người dùng và phân biệt trạng thái Guest vs Authenticated.
- [x] **Task 2.2:** Thiết kế `SongModel` chứa thông tin chi tiết bài hát (id, title, artist, audioUrl, coverUrl, lyricsUrl, duration).
- [x] **Task 2.3:** Thiết kế `PlaylistModel` hỗ trợ cả danh sách phát gợi ý và danh sách phát cá nhân hóa của người dùng.
- [x] **Task 2.4:** Thiết kế `LyricLine` hỗ trợ phân tích định dạng LRC (Synced Lyrics) theo thời gian thực (real-time).
- [x] **Task 2.5:** Đăng ký các TypeAdapters cho Hive để lưu trữ metadata bài hát offline và trạng thái phát nhạc cục bộ.

---

### Phase 3: Audio Service Native (Cấu hình Native & Tích hợp audio_service)
*Thiết lập các quyền truy cập hệ thống và cầu nối native để phát nhạc chạy ngầm mượt mà.*

- [x] **Task 3.1:** Cập nhật file `android/app/src/main/AndroidManifest.xml` (thêm các quyền hệ thống và khai báo `AudioService`, `MediaButtonReceiver`).
- [x] **Task 3.2:** Cập nhật file `ios/Runner/Info.plist` (đăng ký `UIBackgroundModes` cho `audio` và `fetch`, cấu hình `NSAppTransportSecurity`).
- [x] **Task 3.3:** Hiện thực lớp `AudioPlayerHandler` kế thừa từ `BaseAudioHandler` để điều phối giao tiếp giữa `just_audio` và hệ thống Lockscreen/Control Center của thiết bị.
- [x] **Task 3.4:** Thiết lập cơ chế kiểm soát Audio Focus để tự động tạm dừng nhạc khi có cuộc gọi đến hoặc ứng dụng khác phát âm thanh.

---

### Phase 4: Home UI & Auth (Màn hình Trang chủ & Phân quyền)
*Xây dựng giao diện Trang chủ phong cách Stitch Design và hệ thống phân quyền sử dụng Riverpod.*

- [x] **Task 4.1 (UI Home):** Xây dựng màn hình Trang chủ (`HomeScreen`) chuẩn Stitch Liquid Glass (bao gồm `HomeHeader`, `CategoryFilterBar`, `ForYouBanner`, `PopularSongList`, và `FloatingLiquidNavBar`).
- [x] **Task 4.2 (Auth State):** Hiện thực `AuthRepository` và `AuthController` bằng Riverpod để quản lý đăng nhập, đăng ký và Guest Mode.
- [x] **Task 4.3 (Guest Guard):** Thiết kế `GuestBottomSheet` để cảnh báo / yêu cầu đăng nhập khi người dùng Guest truy cập tính năng cần tài khoản.
- [x] **Task 4.4 (Personalization):** Hiện thực hiển thị Personalized Playlist và Recently Played phân theo `AuthState`.

---

### Phase 5: Liquid Mini Player & Full Player UI (Trình phát nhạc cao cấp)
*Xây dựng giao diện phát nhạc tinh tế với các hoạt ảnh mượt mà và bộ chỉnh âm.*

- [ ] **Task 5.1:** Thiết kế widget `MiniPlayer` dạng Floating Card bo góc, tích hợp hiệu ứng Liquid Glass mỏng nằm nổi trên Bottom Navigation.
- [ ] **Task 5.2:** Hiện thực hoạt ảnh xoay đĩa nhạc `VinylDiskAnimator` mượt mà (xoay liên tục khi phát, dừng chậm rãi khi tạm dừng).
- [ ] **Task 5.3:** Xây dựng màn hình `FullPlayerScreen` hiển thị ảnh bìa, thanh trượt thời gian (slider), các nút điều khiển chất lượng cao (Shuffle, Repeat, Play/Pause, Next/Prev).
- [ ] **Task 5.4:** Thiết kế giao diện Chạy lời bài hát đồng bộ (`SyncedLyricsViewer`) cuộn mượt mà theo giây của định dạng LRC.
- [ ] **Task 5.5:** Xây dựng hàng đợi phát nhạc `QueueList` hỗ trợ kéo thả đổi vị trí (reorderable list).
- [ ] **Task 5.6:** Tích hợp bộ hẹn giờ tắt nhạc `SleepTimer` với đếm ngược tự động và bộ chỉnh âm `Equalizer (EQ)` cơ bản.

---

### Phase 6: Offline Download (Tải & Phát nhạc ngoại tuyến)
*Hiện thực hóa tính năng nghe nhạc Offline không cần kết nối mạng.*

- [ ] **Task 6.1:** Xây dựng dịch vụ mạng `DioClient` để tải file MP3 với khả năng theo dõi tiến độ (download progress callback).
- [ ] **Task 6.2:** Hiện thực `OfflineDownloadRepository` để lưu file nhạc vật lý vào `ApplicationDocumentsDirectory` và ghi nhận thông tin vào cơ sở dữ liệu Hive.
- [ ] **Task 6.3:** Xây dựng giao diện quản lý nhạc đã tải "Downloaded Music" cho phép duyệt và xóa nhạc ngoại tuyến.
- [ ] **Task 6.4:** Xây dựng cơ chế phát nhạc offline từ file cục bộ khi không có kết nối mạng (hoặc khi người dùng chọn phát nhạc ngoại tuyến).

---

### Phase 7: Polish & Optimization (Tối ưu hóa & Hoàn thiện)
*Rà soát, tối ưu hóa hiệu năng, xử lý các trường hợp lỗi và đóng gói sản phẩm.*

- [ ] **Task 7.1:** Đảm bảo giải phóng bộ nhớ (Memory Safety) cho tất cả các Controller, Stream, và Audio Player khi không còn sử dụng.
- [ ] **Task 7.2:** Thêm xử lý lỗi mạng mượt mà bằng SnackBar trực quan hoặc các màn hình thông báo offline bắt mắt.
- [ ] **Task 7.3:** Tối ưu hóa hiệu năng dựng hình (rebuild) bằng cách gắn nhãn `const` cho các widget tĩnh và phân chia nhỏ widget.
- [ ] **Task 7.4:** Chạy thử nghiệm trên cả hai nền tảng Android & iOS để xác minh tính ổn định của tính năng phát chạy ngầm.
