import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/stitch_colors.dart';
import '../../../core/widgets/liquid_glass_card.dart';
import '../domain/auth_state.dart';
import 'auth_controller.dart';

/// Màn hình đăng nhập & xác thực mang phong cách Stitch Liquid Glass
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  /// Hàm tiện ích điều hướng mở màn hình Login
  static Future<bool?> navigateTo(BuildContext context) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  bool _isRegisterMode = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Khởi tạo tài khoản thử nghiệm mặc định để dễ dàng kiểm thử
    _emailController = TextEditingController(text: 'dung@stitchmusic.com');
    _passwordController = TextEditingController(text: 'password123');
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final controller = ref.read(authControllerProvider.notifier);

    bool success = false;
    if (_isRegisterMode) {
      final name = _nameController.text.trim();
      success = await controller.register(
        email: email,
        password: password,
        displayName: name,
      );
    } else {
      success = await controller.login(
        email: email,
        password: password,
      );
    }

    if (mounted && success) {
      log('Đăng nhập thành công, đóng LoginScreen', name: 'LoginScreen');
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: StitchColors.darkBackground,
      body: Stack(
        children: [
          // Hiệu ứng Ambient Glow đỉnh màn hình
          Positioned(
            top: -100,
            left: -50,
            right: -50,
            height: 380,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    StitchColors.primary.withValues(alpha: 0.28),
                    StitchColors.secondary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: StitchColors.textPrimary,
                          size: 20,
                        ),
                        tooltip: 'Quay lại',
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          await ref.read(authControllerProvider.notifier).continueAsGuest();
                          if (context.mounted) {
                            Navigator.of(context).pop(false);
                          }
                        },
                        child: const Text(
                          'Chế độ Khách',
                          style: TextStyle(
                            color: StitchColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        // Logo Badge
                        Center(
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  StitchColors.primary,
                                  StitchColors.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: StitchColors.primary.withValues(alpha: 0.45),
                                  blurRadius: 28,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.music_note_rounded,
                              size: 40,
                              color: StitchColors.darkBackground,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title & Subtitle
                        Text(
                          _isRegisterMode ? 'Tạo tài khoản mới' : 'Chào mừng trở lại',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: StitchColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isRegisterMode
                              ? 'Tham gia cùng Stitch Music để lưu trữ âm nhạc bất tận'
                              : 'Đăng nhập để đồng bộ danh sách bài hát & playlist',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: StitchColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 32),

                        // Glass Form Container
                        LiquidGlassCard(
                          borderRadius: 24,
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_isRegisterMode) ...[
                                _buildTextField(
                                  controller: _nameController,
                                  hintText: 'Tên hiển thị',
                                  icon: Icons.person_outline_rounded,
                                ),
                                const SizedBox(height: 16),
                              ],
                              _buildTextField(
                                controller: _emailController,
                                hintText: 'Địa chỉ Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _passwordController,
                                hintText: 'Mật khẩu',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: StitchColors.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),

                              if (authState is AuthError) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: StitchColors.secondary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: StitchColors.secondary.withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: StitchColors.secondary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          authState.message,
                                          style: const TextStyle(
                                            color: StitchColors.secondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 24),

                              // Nút Submit chính
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: StitchColors.primary,
                                    foregroundColor: StitchColors.darkBackground,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    elevation: 4,
                                    shadowColor: StitchColors.primary.withValues(alpha: 0.5),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: StitchColors.darkBackground,
                                          ),
                                        )
                                      : Text(
                                          _isRegisterMode ? 'Đăng ký' : 'Đăng nhập ngay',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Chuyển đổi giữa Đăng nhập / Đăng ký
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isRegisterMode
                                  ? 'Đã có tài khoản?'
                                  : 'Chưa có tài khoản?',
                              style: const TextStyle(color: StitchColors.textSecondary),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isRegisterMode = !_isRegisterMode;
                                });
                                ref.read(authControllerProvider.notifier).clearError();
                              },
                              child: Text(
                                _isRegisterMode ? 'Đăng nhập' : 'Đăng ký ngay',
                                style: const TextStyle(
                                  color: StitchColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: StitchColors.darkSurface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: StitchColors.borderLight,
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: StitchColors.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: StitchColors.neutral.withValues(alpha: 0.8),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: StitchColors.primary.withValues(alpha: 0.8),
            size: 20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
