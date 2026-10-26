import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_fundamentals/main.dart';

void main() {
  testWidgets('Course Explorer app can be created', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CourseExplorerApp());

    expect(find.byType(CourseExplorerApp), findsOneWidget);
  });
}