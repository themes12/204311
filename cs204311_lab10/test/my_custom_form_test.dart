import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cs204311_lab10/my_custom_form.dart';

void main() {
  group('MyCustomForm Widget', () {
    testWidgets('autocomplete shows Chom Thong when input Thong',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
            const MaterialApp(home: Scaffold(body: MyCustomForm())));

        await tester.enterText(find.byType(Autocomplete).first, 'Thong');
        await tester.pumpAndSettle();

        expect(find.text('Chom Thong'), findsOneWidget);
      });
    });

    testWidgets('autocomplete does not show list when input f',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
            const MaterialApp(home: Scaffold(body: MyCustomForm())));

        await tester.enterText(find.byType(Autocomplete).first, 'f');
        await tester.pumpAndSettle();

        expect(find.byType(ListTile), findsNothing);
      });
    });

    testWidgets('autocomplete shows Chom Thong when input Thong 2',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
            const MaterialApp(home: Scaffold(body: MyCustomForm())));

        await tester.enterText(find.byType(Autocomplete).first, 'Thong');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Chom Thong'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(Autocomplete).last, 'Pae');
        await tester.pumpAndSettle();

        expect(find.text('Ban Pae'), findsOneWidget);
      });
    });
  });
}
