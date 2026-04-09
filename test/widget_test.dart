import 'package:flutter_test/flutter_test.dart';
import 'package:memory_land/app/app.dart';

void main() {
  testWidgets('renders app shell', (tester) async {
    await tester.pumpWidget(const MemoryLandApp());
    await tester.pumpAndSettle();

    expect(find.text('回忆岛'), findsOneWidget);
    expect(find.text('沙滩'), findsOneWidget);
    expect(find.text('投放'), findsOneWidget);
  });
}
