# Product Requirement Document (PRD) - Cross-Platform Music App

## 1. Tổng quan sản phẩm
Ứng dụng nghe nhạc đa nền tảng (iOS & Android) được xây dựng bằng Flutter. Sản phẩm hướng tới trải nghiệm âm thanh mượt mà, giao diện sang trọng theo phong cách Stitch Design phối cùng hiệu ứng thẻ nổi Liquid Glass.

## 2. Phân quyền & Chế độ người dùng (Authentication)
- **Guest Mode (Chưa đăng nhập):**
  - Được phép duyệt Trang chủ, nghe các bài hát gợi ý, bài hát nổi bật và tìm kiếm nhạc public.
  - Khi bấm tạo Playlist hoặc Lưu nhạc yêu thích: Hiển thị BottomSheet yêu cầu Đăng nhập/Đăng ký.
- **Authenticated User (Đã đăng nhập):**
  - Mở khóa Playlist cá nhân hóa, Danh sách bài hát yêu thích (Liked Songs) và Lịch sử nghe gần đây.
  - Đồng bộ dữ liệu cá nhân hóa qua Cloud API.

## 3. Kiến trúc Tính năng Cốt lõi

### A. Màn hình Trang chủ (Home Screen)
- **Featured Section:** Banner các bài hát/nghệ sĩ nổi bật.
- **New Releases:** Horizontal Scroll danh sách Album mới phát hành.
- **Personalized Playlist:** Danh sách phát dành riêng cho user (Chỉ hiển thị khi đã Login).
- **Recently Played:** Các bài hát/album đã nghe gần đây.
- **Recommended Playlists:** Các danh sách nhạc gợi ý theo chủ đề/thể loại.

### B. Mini Player & Full Player UI
- **Mini Player (Thẻ nổi Liquid Glass):**
  - Thiết kế dạng Floating Card bo góc nằm nổi trên thanh điều hướng Bottom Navigation.
  - Hiệu ứng kính mỏng Liquid Glass (`BackdropFilter` blur + viền phát sáng gradient mỏng).
  - Thao tác nhanh: Play/Pause, Next track, Chạm để mở Full Player.
- **Full Player Screen:**
  - **Vinyl Disk Animation:** Hiệu ứng đĩa nhạc quay tròn mượt mà khi phát nhạc và dừng lại khi Pause.
  - **Synced Lyrics:** Hiệu ứng chạy lời bài hát theo thời gian thực (LRC format).
  - **Queue List:** Quản lý danh sách các bài hát chuẩn bị phát (Kéo thả reorder).
  - **Equalizer (EQ):** Bộ chỉnh âm thanh (Bass Boost, Pop, Rock, Classical...).
  - **Sleep Timer:** Bộ hẹn giờ đếm ngược tự động tắt nhạc (15m, 30m, 60m, Custom).

### C. Quản lý Âm thanh & Offline Mode
- **Online Streaming:** Stream nhạc MP3 trực tuyến qua URL chất lượng cao.
- **Offline Download:** Tải file MP3 về bộ nhớ cục bộ của thiết bị (`ApplicationDocumentsDirectory`). Quản lý bài hát đã tải trong mục "Downloaded Music".
- **Background & Lockscreen Controls:** Tích hợp `audio_service` hiển thị nhạc trên Lockscreen iOS (Control Center) và Notification Android.

## 4. Quy chuẩn Giao diện (Design Tokens)
- **Theme:** Stitch Color Palette (Bảng màu tùy chỉnh độc bản, không trùng lặp phong cách AI mặc định).
- **Glassmorphism:** Sử dụng hiệu ứng mờ nhòe kính (Liquid Glass) với độ xuyên sáng tinh tế.