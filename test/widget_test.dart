import 'package:flutter_test/flutter_test.dart';
import 'package:memory_land/app/app.dart';

void main() {
  testWidgets('renders journal style globe home', (tester) async {
    await tester.pumpWidget(const MemoryLandApp());
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('海南岛 01'), findsOneWidget);
    expect(find.text('灯塔'), findsOneWidget);
    expect(find.text('写今天'), findsOneWidget);
  });
}
