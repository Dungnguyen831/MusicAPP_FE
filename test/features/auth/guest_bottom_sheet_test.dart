import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_test/features/auth/widgets/guest_bottom_sheet.dart';

void main() {
  group('GuestBottomSheet Widget Tests', () {
    testWidgets('Renders default title, message, and action buttons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GuestBottomSheet(),
          ),
        ),
      );

      expect(find.text('Trải nghiệm trọn vẹn âm nhạc'), findsOneWidget);
      expect(
        find.textContaining('Đăng nhập để lưu bài hát yêu thích'),
        findsOneWidget,
      );
      expect(find.text('Đăng nhập ngay'), findsOneWidget);
      expect(find.text('Để sau'), findsOneWidget);
      expect(find.byIcon(Icons.lock_person_rounded), findsOneWidget);
      expect(find.text('Lưu bài hát vào danh sách Yêu thích'), findsOneWidget);
    });

    testWidgets('Renders custom title and message when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GuestBottomSheet(
              title: 'Cần đăng nhập để thích bài hát',
              message: 'Hãy đăng nhập để thêm bài này vào bộ sưu tập của bạn.',
            ),
          ),
        ),
      );

      expect(find.text('Cần đăng nhập để thích bài hát'), findsOneWidget);
      expect(
        find.text('Hãy đăng nhập để thêm bài này vào bộ sưu tập của bạn.'),
        findsOneWidget,
      );
    });

    testWidgets('Tapping onLoginPressed invokes callback', (tester) async {
      bool loginPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GuestBottomSheet(
              onLoginPressed: () {
                loginPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Đăng nhập ngay'));
      await tester.pumpAndSettle();

      expect(loginPressed, isTrue);
    });

    testWidgets('Tapping "Để sau" invokes onDismissed callback', (tester) async {
      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GuestBottomSheet(
              onDismissed: () {
                dismissed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Để sau'));
      await tester.pumpAndSettle();

      expect(dismissed, isTrue);
    });

    testWidgets('GuestBottomSheet.show opens modal bottom sheet', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  GuestBottomSheet.show(
                    context,
                    title: 'Tiêu đề Modal Test',
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tiêu đề Modal Test'), findsNothing);

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Tiêu đề Modal Test'), findsOneWidget);
      expect(find.byType(GuestBottomSheet), findsOneWidget);

      // Tap "Để sau" should close bottom sheet
      await tester.tap(find.text('Để sau'));
      await tester.pumpAndSettle();

      expect(find.text('Tiêu đề Modal Test'), findsNothing);
    });
  });
}
