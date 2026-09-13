import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_state.dart';
import '../presentation/auth_controller.dart';
import '../widgets/guest_bottom_sheet.dart';

/// Lớp tiện ích kiểm soát và chặn quyền truy cập (Guard) cho các tính năng
/// chỉ dành cho người dùng đã xác thực (Authenticated User).
///
/// Nếu người dùng đang ở chế độ Khách (Guest) hoặc chưa đăng nhập,
/// Guard sẽ chặn action và kích hoạt hiển thị [GuestBottomSheet].
class GuestGuard {
  GuestGuard._();

  /// Thực thi [action] nếu người dùng đã đăng nhập.
  /// Nếu người dùng là Guest hoặc chưa đăng nhập, tự động hiển thị [GuestBottomSheet].
  ///
  /// Ví dụ sử dụng trong ConsumerWidget:
  /// ```dart
  /// GuestGuard.run(
  ///   context,
  ///   ref: ref,
  ///   action: () => createNewPlaylist(),
  ///   title: 'Tạo Playlist cá nhân',
  ///   message: 'Vui lòng đăng nhập để tạo và lưu trữ danh sách phát của bạn.',
  /// );
  /// ```
  static void run(
    BuildContext context, {
    required WidgetRef ref,
    required VoidCallback action,
    String? title,
    String? message,
    VoidCallback? onLoginPressed,
    VoidCallback? onDismissed,
  }) {
    final authState = ref.read(authControllerProvider);
    runWithState(
      context,
      authState: authState,
      action: action,
      title: title,
      message: message,
      onLoginPressed: onLoginPressed,
      onDismissed: onDismissed,
    );
  }

  /// Thực thi [action] dựa trên [AuthState] được truyền vào trực tiếp.
  static void runWithState(
    BuildContext context, {
    required AuthState authState,
    required VoidCallback action,
    String? title,
    String? message,
    VoidCallback? onLoginPressed,
    VoidCallback? onDismissed,
  }) {
    if (authState.isAuthenticated) {
      log('GuestGuard: Quyền truy cập hợp lệ (User: ${authState.currentUser?.displayName})', name: 'GuestGuard');
      action();
    } else {
      log('GuestGuard: Đã chặn action của Guest/Unauthenticated -> Hiển thị GuestBottomSheet', name: 'GuestGuard');
      GuestBottomSheet.show(
        context,
        title: title,
        message: message,
        onLoginPressed: onLoginPressed,
        onDismissed: onDismissed,
      );
    }
  }

  /// Kiểm tra xem người dùng hiện tại có được phép thực hiện thao tác hay không.
  /// Trả về `true` nếu đã đăng nhập, ngược lại hiển thị [GuestBottomSheet] và trả về `false`.
  ///
  /// Ví dụ sử dụng:
  /// ```dart
  /// final canProceed = await GuestGuard.check(context, ref: ref);
  /// if (canProceed) {
  ///   saveFavoriteSong();
  /// }
  /// ```
  static Future<bool> check(
    BuildContext context, {
    required WidgetRef ref,
    String? title,
    String? message,
    VoidCallback? onLoginPressed,
  }) async {
    final authState = ref.read(authControllerProvider);
    if (authState.isAuthenticated) {
      return true;
    }

    await GuestBottomSheet.show(
      context,
      title: title,
      message: message,
      onLoginPressed: onLoginPressed,
    );
    return ref.read(authControllerProvider).isAuthenticated;
  }
}
