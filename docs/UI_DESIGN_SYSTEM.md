# UI Design System - Stitch Music

Tài liệu này quy định các tiêu chuẩn thiết kế (Design Tokens) và thành phần giao diện (UI Components) chuẩn cho dự án Stitch Music, đảm bảo tính nhất quán và trải nghiệm người dùng cao cấp.

---

## 1. Design Tokens

### A. Màu sắc (Color Palette)
Định nghĩa trong `StitchColors` tại `lib/core/theme/stitch_colors.dart`.

| Tên biến | Mã Hex | Mục đích sử dụng |
| :--- | :--- | :--- |
| `primary` | `#C084C4` | Màu tím hồng chủ đạo cho các thành phần Active, Button chính. |
| `secondary` | `#E05A5A` | Màu đỏ cam cho các trạng thái Error hoặc nhấn mạnh đặc biệt. |
| `tertiary` | `#8DA14B` | Màu xanh lá phong cách retro cho một số thẻ bài hát/playlist. |
| `neutral` | `#7C757A` | Màu xám trầm cho các văn bản phụ, biểu tượng không active. |
| `darkBackground` | `#0E0B0E` | Màu nền tối sâu thẳm pha ánh tím cho Scaffold. |
| `darkSurface` | `#1E1A1F` | Màu bề mặt cho thẻ Liquid Glass, Menu. |
| `darkSurfaceVariant`| `#2E2930` | Biến thể của bề mặt cho các vùng phân tách. |
| `textPrimary` | `#F5F3F5` | Màu chữ chính, độ tương phản cao. |
| `textSecondary` | `#A59EA4` | Màu chữ phụ, mô tả ngắn. |
| `borderLight` | `#33C084C4` | Viền phát sáng mỏng cho hiệu ứng Liquid Glass. |

### B. Typography
Sử dụng phông chữ qua thư viện `google_fonts` trong `lib/core/theme/app_theme.dart`.

- **Headings & Body:** `Plus Jakarta Sans`
  - Bold: Cho Headlines và Buttons.
  - Normal: Cho nội dung văn bản.
- **Labels & Timestamps:** `JetBrains Mono`
  - Sử dụng cho thông số thời gian, nhãn nhỏ cần sự chính xác.

---

## 2. Hiệu ứng Đặc trưng

### A. Ambient Glow (Nền mờ ảo)
Hiệu ứng tỏa sáng tại đỉnh màn hình trong `home_screen.dart`.
- **Loại:** `LinearGradient`
- **Màu sắc:** `StitchColors.primary.withOpacity(0.28)` tỏa xuống `StitchColors.darkBackground`.
- **Vị trí:** Bắt đầu từ `Alignment.topCenter` đến `Alignment.bottomCenter`.

### B. Liquid Glass (Thẻ kính mờ)
Quy chuẩn cho widget `LiquidGlassCard` tại `lib/core/widgets/liquid_glass_card.dart`.
- **Blur:** `sigmaX: 20.0, sigmaY: 20.0` dùng `ImageFilter.blur`.
- **Màu nền:** `StitchColors.darkSurface.withOpacity(0.45)`.
- **Viền:** `Border.all` màu `StitchColors.borderLight` (hoặc `Colors.white.withOpacity(0.12)` tùy ngữ cảnh) với độ dày `1.2`.

---

## 3. Quy chuẩn Thành phần (Components)

### A. Home Header
- **SafeArea:** Bắt buộc có `SizedBox(height: MediaQuery.of(context).padding.top)` phía trên.
- **Avatar:** Hình tròn, bán kính 24px.
- **Nút chức năng:** Nút tròn kính mờ, kích thước 48x48px, icon 24px.

### B. Category Filter Bar
- **Hình dạng:** Dạng Pill (Viên thuốc), bo góc 20px.
- **Active:** Nền `StitchColors.primary`, chữ đen đậm.
- **Inactive:** Thẻ `LiquidGlassCard` mờ, chữ màu `StitchColors.neutral`.

### C. For You Banner (Feature Cards)
- **Bo góc:** 24px.
- **Bố cục:** Chữ căn lề trái, ảnh/gradient căn lề phải.
- **Nút CTA:** Pill shape, nền tím mờ `primary.withOpacity(0.2)`, viền phát sáng.

### D. Song Tile (Danh sách bài hát)
- **Thumbnail:** Bo góc 14px, kích thước 64x64px.
- **Typography:** Tên bài `headlineSmall` (Bold), Ca sĩ `bodyMedium` (Secondary text).
- **Play Button:** Hình tròn nền xám mờ `darkSurface.withOpacity(0.6)`, icon trắng.

### E. Floating Liquid Nav Bar
- **Cấu trúc:** Floating Pill bo tròn hoàn toàn (Radius 36px).
- **Tương tác:**
  - Hỗ trợ **Tap** để chuyển tab.
  - Hỗ trợ **Gesture Drag/Pan** để di chuyển vòng tròn Active mượt mà.
- **Vòng tròn Active:** Màu `StitchColors.primary`, kích thước 56x56px, chỉ chứa icon.

---

## 4. Thông số Đo lường (Metrics)

- **Spacing:**
  - Padding màn hình (Horizontal): 24px.
  - Bottom Padding an toàn: 100px (để tránh Nav Bar).
- **Border Radius:**
  - Small (Thumbnail): 14px.
  - Medium (Chips): 20px.
  - Large (Cards): 24px.
  - Full (Pill/Nav): 36px.

---

## 5. Quy tắc dành cho Agent

1. **Bất biến:** Tuyệt đối không hardcode mã màu Hex trong Widget UI. Luôn sử dụng `StitchColors`.
2. **Tái sử dụng:** Ưu tiên sử dụng `LiquidGlassCard` thay vì tạo `BackdropFilter` thủ công.
3. **Typography:** Sử dụng các kiểu text có sẵn trong `Theme.of(context).textTheme` (ví dụ: `headlineLarge`, `bodyMedium`).
4. **Layout:** Luôn kiểm tra `SafeArea` và Padding đáy cho các màn hình có chứa `FloatingLiquidNavBar`.
