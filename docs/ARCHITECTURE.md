# Tài liệu Kiến trúc Dự án (ARCHITECTURE.md)

Tài liệu này mô tả chi tiết kiến trúc phần mềm, cấu trúc thư mục, danh sách công nghệ sử dụng (Tech Stack) và các cấu hình hệ thống (Native Configuration) cần thiết để phát triển ứng dụng nghe nhạc đa nền tảng (iOS & Android).

---

## 1. Công nghệ Sử dụng (Tech Stack)

Hệ thống được thiết kế dựa trên các công nghệ hiện đại, đảm bảo tính hiệu năng cao, trải nghiệm người dùng mượt mà và khả năng bảo trì tốt:

*   **Framework chính:** `Flutter (Dart 3+)` với chế độ kiểm tra kiểu nghiêm ngặt (strict type-safety) và an toàn kiểu dữ liệu Null (null-safety).
*   **Quản lý trạng thái (State Management):** `flutter_riverpod` (kết hợp với `Riverpod Generator` nếu cần) để đảm bảo luồng dữ liệu một chiều phản ứng cực nhạy (reactive state handling), dễ kiểm thử (unit test) và tách biệt rõ ràng giữa logic nghiệp vụ (business logic) và giao diện hiển thị (UI).
*   **Trình phát âm thanh (Audio Engine):**
    *   `just_audio`: Thư viện phát âm thanh mạnh mẽ, hỗ trợ stream trực tuyến hiệu năng cao, đệm nhạc (buffering), điều khiển tốc độ phát và tích hợp bộ lọc âm thanh.
    *   `audio_service`: Hỗ trợ quản lý phát nhạc chạy ngầm (background playback) và hiển thị các điều khiển trên màn hình khóa (lock-screen), trung tâm điều khiển (iOS Control Center) và thanh thông báo (Android Notification).
*   **Xử lý mạng và Offline (Network & Offline Cache):**
    *   `dio`: Thư viện HTTP client mạnh mẽ hỗ trợ interceptor, cấu hình timeout, tải file cục bộ có tiến trình (download progress) và tự động thử lại khi mất kết nối.
    *   `hive` / `hive_flutter`: Cơ sở dữ liệu NoSQL dạng Key-Value cực nhanh, gọn nhẹ, được sử dụng để lưu trữ metadata bài hát ngoại tuyến, thông tin playlist cá nhân, lịch sử nghe nhạc và trạng thái ứng dụng.
    *   `path_provider`: Xác định đúng thư mục hệ thống an toàn để lưu trữ file nhạc vật lý (`ApplicationDocumentsDirectory`).

---

## 2. Cấu trúc thư mục theo Tính năng (Feature-First Architecture)

Ứng dụng áp dụng mô hình **Feature-First Clean Architecture**, giúp dự án dễ dàng mở rộng khi có thêm nhiều tính năng mới và hạn chế xung đột mã nguồn khi nhiều lập trình viên cùng làm việc.

```text
lib/
├── core/                           # Chứa các định nghĩa chung, dùng toàn hệ thống
│   ├── constants/                  # Hằng số hệ thống (màu sắc, kích thước, API endpoints...)
│   ├── theme/                      # Cấu hình giao diện (Stitch Color Palette, Liquid Glass effect)
│   ├── services/                   # Dịch vụ toàn cục (Global Services: Network, Logger, v.v.)
│   └── utils/                      # Các hàm tiện ích (helpers, formatters)
│
├── features/                       # Các thư mục chứa các tính năng độc lập
│   │
│   ├── auth/                       # 1. Tính năng Xác thực & Phân quyền (Guest vs Authenticated User)
│   │   ├── data/                   # Tương tác dữ liệu: auth_repository, auth_api_client
│   │   ├── domain/                 # Nghiệp vụ & Thực thể: user_model, auth_state
│   │   ├── presentation/           # Giao diện: login_screen, register_screen, auth_controller (Riverpod)
│   │   └── widgets/                # Các thành phần UI nhỏ: login_form, guest_bottom_sheet
│   │
│   ├── home/                       # 2. Tính năng Trang chủ (Duyệt nhạc trực tuyến)
│   │   ├── data/                   # Tương tác dữ liệu: home_repository, banner_api
│   │   ├── domain/                 # Nghiệp vụ & Thực thể: banner_model, recommendation_model
│   │   ├── presentation/           # Giao diện: home_screen, home_controller
│   │   └── widgets/                # Các thành phần UI nhỏ: featured_banner, personalized_playlist_card, recently_played_list
│   │
│   ├── player/                     # 3. Tính năng Trình phát nhạc (Mini Player & Full Player)
│   │   ├── data/                   # Tương tác dữ liệu: song_repository, lyric_repository
│   │   ├── domain/                 # Nghiệp vụ & Thực thể: song_model, lyric_model, queue_state
│   │   ├── presentation/           # Giao diện: player_screen, player_controller (quản lý trạng thái Play/Pause, EQ, Sleep Timer)
│   │   └── widgets/                # Các thành phần UI nhỏ: mini_player_bar, vinyl_disk_animator, lyric_viewer, eq_panel_dialog
│   │
│   ├── playlist/                   # 4. Tính năng Quản lý Playlist & Bài hát yêu thích (Liked Songs)
│   │   ├── data/                   # Tương tác dữ liệu: playlist_repository
│   │   ├── domain/                 # Nghiệp vụ & Thực thể: playlist_model
│   │   ├── presentation/           # Giao diện: playlist_detail_screen, liked_songs_screen, playlist_controller
│   │   └── widgets/                # Các thành phần UI nhỏ: playlist_song_tile, create_playlist_dialog
│   │
│   └── offline/                    # 5. Tính năng Quản lý nhạc Offline (Tải & Phát ngoại tuyến)
│       ├── data/                   # Tương tác dữ liệu: offline_download_repository, offline_storage_service (Hive, Dio)
│       ├── domain/                 # Nghiệp vụ & Thực thể: download_task_model, downloaded_song_model
│       ├── presentation/           # Giao diện: downloaded_music_screen, offline_download_controller
│       └── widgets/                # Các thành phần UI nhỏ: download_progress_bar, offline_song_tile
│
└── main.dart                       # Điểm khởi chạy ứng dụng (Initialization, Riverpod ProviderScope)
```

### Nguyên tắc thiết kế cốt lõi trong từng Feature:
1.  **Mô hình 3 lớp (Data - Domain - Presentation):**
    *   **Data Layer:** Chịu trách nhiệm lấy dữ liệu thô từ API (Remote) hoặc từ Database cục bộ (Local). Chứa các file `RepositoryImpl`, `DataSource`.
    *   **Domain Layer:** Chứa các thực thể (`Entities/Models`) thuần túy và định nghĩa Interface cho `Repository`. Lớp này hoàn toàn độc lập với UI và Framework.
    *   **Presentation Layer:** Chứa màn hình UI (`Screens`), widget cục bộ và lớp điều khiển trạng thái (`Controllers` hoặc `Providers` của Riverpod).
2.  **Memory Safety:** Mọi luồng Stream (StreamSubscription), trình phát nhạc (`AudioPlayer`), hoặc bộ điều khiển nhập liệu (`TextEditingController`) bắt buộc phải được giải phóng qua phương thức `dispose()` hoặc `ref.onDispose()` của Riverpod để tránh rò rỉ bộ nhớ (memory leaks).
3.  **Immutability:** Ưu tiên sử dụng `const` constructor cho UI widgets để tăng tốc độ dựng hình (rebuild optimization).

---

## 3. Cấu hình Hệ thống (Native System Configuration)

Để hỗ trợ đầy đủ các tính năng phát nhạc chạy ngầm (Background Audio), hiển thị thông tin bài hát ngoài màn hình khóa, và tải nhạc ngoại tuyến (Offline Download) xuống thiết bị, chúng ta cần khai báo các cấu hình Native đặc thù sau:

### A. Cấu hình cho Android (`android/app/src/main/AndroidManifest.xml`)

Cần cập nhật các quyền hệ thống và khai báo Service của `audio_service` để hệ điều hành không giải phóng ứng dụng khi đang phát nhạc chạy ngầm.

Mở file `android/app/src/main/AndroidManifest.xml` và thêm các nội dung sau:

#### 1. Khai báo các quyền truy cập hệ thống (ngoài thẻ `<application>`):
```xml
<!-- Quyền kết nối Internet để stream nhạc trực tuyến -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

<!-- Quyền chạy dịch vụ ngầm phát nhạc (Yêu cầu từ Android 9 / API 28 trở lên) -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

<!-- Quyền chạy dịch vụ ngầm loại Media Playback (Bắt buộc từ Android 14 / API 34 trở lên) -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />

<!-- Quyền đánh thức thiết bị phát nhạc khi màn hình tắt -->
<uses-permission android:name="android.permission.WAKE_LOCK" />

<!-- Quyền lưu trữ nhạc offline (Cho Android 9 trở xuống, Android 10+ tự động sử dụng Scoped Storage hoặc App Folder không cần quyền này) -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="28"/>
```

#### 2. Khai báo AudioService và MediaButtonReceiver (nằm trong thẻ `<application>`):
```xml
<!-- Khai báo Audio Service để chạy ngầm và xử lý sự kiện tai nghe/bluetooth -->
<service android:name="com.ryanheise.audioservice.AudioService"
         android:foregroundServiceType="mediaPlayback"
         android:exported="true"
         tools:ignore="Instantiatable">
    <intent-filter>
        <action android:name="android.media.browse.MediaBrowserService" />
    </intent-filter>
</service>

<!-- Bộ nhận tín hiệu từ các phím vật lý trên tai nghe, màn hình khóa hoặc bluetooth -->
<receiver android:name="com.ryanheise.audioservice.MediaButtonReceiver"
          android:exported="true"
          tools:ignore="Instantiatable">
    <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON" />
    </intent-filter>
</receiver>
```
*(Lưu ý: Hãy đảm bảo đã thêm thuộc tính `xmlns:tools="http://schemas.android.com/tools"` vào thẻ `<manifest>` ở đầu file).*

---

### B. Cấu hình cho iOS (`ios/Runner/Info.plist`)

Cần đăng ký khả năng phát âm thanh chạy ngầm (Background Capabilities) và cho phép tải nhạc thông qua mạng nội bộ hoặc internet an toàn.

Mở file `ios/Runner/Info.plist` và thêm các cặp thẻ `<key>` - `<value>` sau trước thẻ đóng `</dict>` cuối cùng:

#### 1. Đăng ký tính năng chạy ngầm (Background Audio & Fetch):
```xml
<key>UIBackgroundModes</key>
<array>
    <!-- Cho phép âm thanh tiếp tục phát khi khóa màn hình hoặc chuyển ứng dụng -->
    <string>audio</string>
    <!-- Cho phép tải dữ liệu chạy ngầm nếu cần -->
    <string>fetch</string>
</array>
```

#### 2. Cấu hình bảo mật mạng (Cho phép tải nhạc từ các nguồn HTTP/HTTPS):
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <!-- Cho phép tải/stream luồng âm thanh từ các server lưu trữ nhạc không bắt buộc HTTPS khắt khe -->
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

#### 3. Cấu hình lưu trữ offline và chia sẻ file (Tùy chọn):
Nếu muốn cho phép người dùng xem các tệp nhạc đã tải về thông qua ứng dụng "Tệp" (Files) mặc định trên iOS:
```xml
<!-- Cho phép chia sẻ thư mục tài liệu của ứng dụng ra ngoài -->
<key>UIFileSharingEnabled</key>
<true/>
<!-- Cho phép mở trực tiếp các tài liệu tại chỗ -->
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

---

## 4. Kiểm thử và Xác minh Kiến trúc

Để đảm bảo các cấu hình và thiết kế thư mục hoạt động đúng chuẩn:
1.  **Xác minh cấu trúc:** Luôn chạy lệnh `flutter analyze` để phát hiện kịp thời các import bị sai hoặc không tuân thủ cấu trúc feature-first.
2.  **Kiểm tra phát nhạc nền:** Build ứng dụng trên thiết bị thật (hoặc Simulator/Emulator), bật bài hát trực tuyến, khóa màn hình và kiểm tra xem nhạc có tiếp tục phát và hiển thị đúng bìa đĩa nhạc (artwork) cũng như điều khiển âm thanh hay không.
3.  **Kiểm tra Offline:** Tắt kết nối Wifi/4G, truy cập vào tab "Downloaded Music" trong ứng dụng và kiểm tra xem danh sách bài hát tải ngoại tuyến có phát bình thường từ bộ nhớ lưu trữ Hive và file vật lý không.
