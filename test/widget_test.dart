import 'package:flutter_test/flutter_test.dart';
import 'package:memory_land/app/app.dart';

void main() {
  testWidgets('renders island home shell', (tester) async {
    await tester.pumpWidget(const MemoryLandApp());
    await tester.pumpAndSettle();

    expect(find.text('海南岛 01'), findsOneWidget);
    expect(find.text('沙滩'), findsOneWidget);
    expect(find.text('漂流瓶'), findsOneWidget);
  });
}
