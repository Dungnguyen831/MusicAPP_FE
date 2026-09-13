import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_model.dart';

/// Abstract interface định nghĩa các giao thức xác thực người dùng
abstract interface class AuthRepository {
  /// Lấy thông tin người dùng đã xác thực trong phiên hiện tại (nếu có)
  Future<UserModel?> getCurrentUser();

  /// Kiểm tra xem ứng dụng có đang chạy ở phiên Guest hay không
  Future<bool> isGuest();

  /// Thiết lập trạng thái chế độ Guest
  Future<void> setGuestMode(bool isGuest);

  /// Đăng nhập tài khoản với email và password
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Đăng ký tài khoản mới
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
  });

  /// Đăng xuất và xóa phiên làm việc
  Future<void> logout();
}

/// Hiện thực mô phỏng MockAuthRepository với validation thực tế và logging
class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;
  bool _isGuestMode = false;

  // Danh sách tài khoản giả lập
  final Map<String, ({String password, UserModel user})> _mockUsers = {
    'dung@stitchmusic.com': (
      password: 'password123',
      user: UserModel(
        id: 'user_001',
        email: 'dung@stitchmusic.com',
        displayName: 'Dũng',
        photoUrl: 'https://picsum.photos/id/64/200/200',
        isPremium: true,
      ),
    ),
  };

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentUser;
  }

  @override
  Future<bool> isGuest() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _isGuestMode;
  }

  @override
  Future<void> setGuestMode(bool isGuest) async {
    _isGuestMode = isGuest;
    if (isGuest) {
      _currentUser = null;
    }
    log('AuthRepository: setGuestMode -> $isGuest', name: 'AuthRepository');
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    log('AuthRepository: login attempt for $email', name: 'AuthRepository');
    await Future.delayed(const Duration(milliseconds: 500));

    final cleanEmail = email.trim().toLowerCase();
    if (!_isValidEmail(cleanEmail)) {
      throw const FormatException('Email không hợp lệ.');
    }
    if (password.length < 6) {
      throw const FormatException('Mật khẩu phải có tối thiểu 6 ký tự.');
    }

    final entry = _mockUsers[cleanEmail];
    if (entry == null || entry.password != password) {
      throw const FormatException('Email hoặc mật khẩu không chính xác.');
    }

    _currentUser = entry.user;
    _isGuestMode = false;
    log('AuthRepository: login successful for ${_currentUser!.displayName}', name: 'AuthRepository');
    return _currentUser!;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    log('AuthRepository: register attempt for $email', name: 'AuthRepository');
    await Future.delayed(const Duration(milliseconds: 600));

    final cleanEmail = email.trim().toLowerCase();
    final cleanName = displayName.trim();

    if (cleanName.isEmpty) {
      throw const FormatException('Tên hiển thị không được để trống.');
    }
    if (!_isValidEmail(cleanEmail)) {
      throw const FormatException('Định dạng email không hợp lệ.');
    }
    if (password.length < 6) {
      throw const FormatException('Mật khẩu phải có độ dài từ 6 ký tự trở lên.');
    }
    if (_mockUsers.containsKey(cleanEmail)) {
      throw const FormatException('Email này đã được đăng ký trên hệ thống.');
    }

    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: cleanEmail,
      displayName: cleanName,
      isPremium: false,
    );

    _mockUsers[cleanEmail] = (password: password, user: newUser);
    _currentUser = newUser;
    _isGuestMode = false;

    log('AuthRepository: registered new user: ${newUser.displayName}', name: 'AuthRepository');
    return newUser;
  }

  @override
  Future<void> logout() async {
    log('AuthRepository: logging out', name: 'AuthRepository');
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _isGuestMode = false;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// Riverpod Provider cung cấp AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});
