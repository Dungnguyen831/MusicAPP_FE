import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_test/features/auth/data/auth_repository.dart';
import 'package:project_test/features/auth/domain/auth_state.dart';
import 'package:project_test/features/auth/domain/user_model.dart';
import 'package:project_test/features/auth/utils/guest_guard.dart';
import 'package:project_test/features/auth/widgets/guest_bottom_sheet.dart';

void main() {
  group('GuestGuard Tests', () {
    final testUser = UserModel(
      id: 'test_user_1',
      email: 'test@stitchmusic.com',
      displayName: 'Stitch Test',
    );

    testWidgets('GuestGuard.runWithState executes action when Authenticated', (tester) async {
      bool actionExecuted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GuestGuard.runWithState(
                    context,
                    authState: Authenticated(testUser),
                    action: () {
                      actionExecuted = true;
                    },
                  );
                },
                child: const Text('Execute Action'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Execute Action'));
      await tester.pumpAndSettle();

      expect(actionExecuted, isTrue);
      expect(find.byType(GuestBottomSheet), findsNothing);
    });

    testWidgets('GuestGuard.runWithState blocks action and shows GuestBottomSheet when AuthGuest', (tester) async {
      bool actionExecuted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GuestGuard.runWithState(
                    context,
                    authState: const AuthGuest(),
                    action: () {
                      actionExecuted = true;
                    },
                  );
                },
                child: const Text('Execute Action'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Execute Action'));
      await tester.pumpAndSettle();

      expect(actionExecuted, isFalse);
      expect(find.byType(GuestBottomSheet), findsOneWidget);
    });

    testWidgets('GuestGuard.run blocks action when state in provider is AuthGuest', (tester) async {
      bool actionExecuted = false;

      final mockRepo = MockAuthRepository();
      // Set to guest
      await mockRepo.setGuestMode(true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) => ElevatedButton(
                  onPressed: () {
                    GuestGuard.run(
                      context,
                      ref: ref,
                      action: () {
                        actionExecuted = true;
                      },
                    );
                  },
                  child: const Text('Guarded Button'),
                ),
              ),
            ),
          ),
        ),
      );

      // Wait for auth check status in controller
      await tester.pumpAndSettle();

      await tester.tap(find.text('Guarded Button'));
      await tester.pumpAndSettle();

      expect(actionExecuted, isFalse);
      expect(find.byType(GuestBottomSheet), findsOneWidget);
    });

    testWidgets('GuestGuard.check returns true for Authenticated and false for Guest', (tester) async {
      final mockRepo = MockAuthRepository();
      await mockRepo.setGuestMode(true);

      bool? checkResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) => ElevatedButton(
                  onPressed: () async {
                    checkResult = await GuestGuard.check(context, ref: ref);
                  },
                  child: const Text('Check Guard'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Check Guard'));
      await tester.pumpAndSettle();

      expect(find.byType(GuestBottomSheet), findsOneWidget);

      // Dismiss bottom sheet via "Để sau"
      await tester.tap(find.text('Để sau'));
      await tester.pumpAndSettle();

      expect(checkResult, isFalse);
      expect(find.byType(GuestBottomSheet), findsNothing);
    });

    testWidgets('GuestGuard.check returns true immediately for Authenticated user', (tester) async {
      final mockRepo = MockAuthRepository();
      // Login as test user
      await mockRepo.login(email: 'dung@stitchmusic.com', password: 'password123');

      bool? checkResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) => ElevatedButton(
                  onPressed: () async {
                    checkResult = await GuestGuard.check(context, ref: ref);
                  },
                  child: const Text('Check Guard Authenticated'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Check Guard Authenticated'));
      await tester.pumpAndSettle();

      expect(checkResult, isTrue);
      expect(find.byType(GuestBottomSheet), findsNothing);
    });
  });
}
