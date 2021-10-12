// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cnpj_company/modules/cnpj_module/cnpj_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Run app and check widgets', (tester) async {
    // Build our app and trigger a frame.

    final Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: CnpjPage(title: 'Pesquisa CNPJ')));

    await tester.pumpWidget(testWidget);

    // Verify that our counter starts at 0.
    expect(find.text('Pesquisa CNPJ'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Find and tap the search button.
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byIcon(Icons.search), findsNothing);

    final btnSearch = find.text('Pesquisar');

    await tester.tap(btnSearch);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('válido'), findsOneWidget);
    expect(find.textContaining('wendreo'), findsNothing);
  });

  testWidgets('Check other widgets', (tester) async {
    // Build our app and trigger a frame.

    final Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: CnpjPage(title: 'Pesquisa CNPJ')));

    await tester.pumpWidget(testWidget);

    expect(find.byIcon(Icons.share), findsOneWidget);
    // final btnShare = find.byIcon(Icons.share);
    // await tester.tap(btnShare);
  });
}
