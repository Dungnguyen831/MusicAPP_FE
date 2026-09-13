import 'package:flutter_test/flutter_test.dart';
import 'package:project_test/features/auth/data/auth_repository.dart';
import 'package:project_test/features/auth/domain/auth_state.dart';
import 'package:project_test/features/auth/presentation/auth_controller.dart';

void main() {
  group('AuthController Tests', () {
    late MockAuthRepository mockRepository;
    late AuthController authController;

    setUp(() {
      mockRepository = MockAuthRepository();
      authController = AuthController(authRepository: mockRepository);
    });

    test('Initial checkAuthStatus should resolve to Unauthenticated for fresh repo', () async {
      await authController.checkAuthStatus();
      expect(authController.state, isA<Unauthenticated>());
      expect(authController.state.isAuthenticated, isFalse);
      expect(authController.state.isGuest, isFalse);
    });

    test('continueAsGuest should set state to AuthGuest', () async {
      await authController.continueAsGuest();
      expect(authController.state, isA<AuthGuest>());
      expect(authController.state.isGuest, isTrue);
      expect(authController.state.isAuthenticated, isFalse);
    });

    test('login with valid credentials should authenticate user', () async {
      final success = await authController.login(
        email: 'dung@stitchmusic.com',
        password: 'password123',
      );

      expect(success, isTrue);
      expect(authController.state, isA<Authenticated>());
      expect(authController.state.isAuthenticated, isTrue);
      expect(authController.state.currentUser?.displayName, equals('Dũng'));
      expect(authController.state.currentUser?.email, equals('dung@stitchmusic.com'));
    });

    test('login with invalid password should emit AuthError', () async {
      final success = await authController.login(
        email: 'dung@stitchmusic.com',
        password: 'wrongpassword',
      );

      expect(success, isFalse);
      expect(authController.state, isA<AuthError>());
      expect((authController.state as AuthError).message, contains('Email hoặc mật khẩu không chính xác'));
    });

    test('register with new credentials should succeed and authenticate', () async {
      final success = await authController.register(
        email: 'newuser@stitchmusic.com',
        password: 'securepassword',
        displayName: 'Lan Anh',
      );

      expect(success, isTrue);
      expect(authController.state, isA<Authenticated>());
      expect(authController.state.currentUser?.displayName, equals('Lan Anh'));
      expect(authController.state.currentUser?.email, equals('newuser@stitchmusic.com'));
    });

    test('register with invalid email should fail with AuthError', () async {
      final success = await authController.register(
        email: 'invalid-email-format',
        password: 'securepassword',
        displayName: 'Hải',
      );

      expect(success, isFalse);
      expect(authController.state, isA<AuthError>());
      expect((authController.state as AuthError).message, contains('Định dạng email không hợp lệ'));
    });

    test('logout should reset state to Unauthenticated', () async {
      // First login
      await authController.login(
        email: 'dung@stitchmusic.com',
        password: 'password123',
      );
      expect(authController.state, isA<Authenticated>());

      // Then logout
      await authController.logout();
      expect(authController.state, isA<Unauthenticated>());
      expect(authController.state.isAuthenticated, isFalse);
    });
  });
}
