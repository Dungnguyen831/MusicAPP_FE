import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';

/// Controller quản lý trạng thái xác thực và phân quyền (Riverpod StateNotifier)
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthInitial()) {
    checkAuthStatus();
  }

  /// Kiểm tra trạng thái xác thực hiện tại (User đã lưu vs Guest vs Chưa đăng nhập)
  Future<void> checkAuthStatus() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        state = Authenticated(user);
        return;
      }

      final isGuest = await _authRepository.isGuest();
      if (isGuest) {
        state = const AuthGuest();
        return;
      }

      state = const Unauthenticated();
    } catch (e, st) {
      log('Lỗi kiểm tra auth status: $e', name: 'AuthController', error: e, stackTrace: st);
      state = AuthError('Không thể kiểm tra trạng thái đăng nhập: $e');
    }
  }

  /// Đăng nhập tài khoản
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      state = Authenticated(user);
      return true;
    } catch (e, st) {
      final message = e is FormatException ? e.message : 'Đăng nhập thất bại: $e';
      log('Đăng nhập lỗi: $message', name: 'AuthController', error: e, stackTrace: st);
      state = AuthError(message);
      return false;
    }
  }

  /// Đăng ký tài khoản mới
  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = Authenticated(user);
      return true;
    } catch (e, st) {
      final message = e is FormatException ? e.message : 'Đăng ký thất bại: $e';
      log('Đăng ký lỗi: $message', name: 'AuthController', error: e, stackTrace: st);
      state = AuthError(message);
      return false;
    }
  }

  /// Tiếp tục trải nghiệm ở chế độ khách (Guest Mode)
  Future<void> continueAsGuest() async {
    try {
      await _authRepository.setGuestMode(true);
      state = const AuthGuest();
      log('Đã chuyển sang Guest Mode', name: 'AuthController');
    } catch (e, st) {
      log('Lỗi chuyển Guest Mode: $e', name: 'AuthController', error: e, stackTrace: st);
      state = AuthError('Không thể kích hoạt Guest Mode: $e');
    }
  }

  /// Đăng xuất khỏi hệ thống
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      state = const Unauthenticated();
      log('Đã đăng xuất', name: 'AuthController');
    } catch (e, st) {
      log('Lỗi khi đăng xuất: $e', name: 'AuthController', error: e, stackTrace: st);
      state = AuthError('Không thể đăng xuất: $e');
    }
  }

  /// Đặt lại trạng thái về Unauthenticated khi cần bỏ qua lỗi
  void clearError() {
    if (state is AuthError) {
      state = const Unauthenticated();
    }
  }
}

/// Riverpod Provider quản lý AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: repository);
});
