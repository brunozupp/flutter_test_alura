import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_contact_dao.dart';
import '../mocks/mock_transaction_web_client.dart';
import '../utils/matchers_utils.dart';

void main() {

  testWidgets("Should save a contact", (tester) async {

    final MockContactDao mockContactDao = MockContactDao();
    final mockTransactionWebClient = MockTransactionWebClient();

    await tester.pumpWidget(
      BytebankApp(
        contactDao: mockContactDao,
        transactionWebClient: mockTransactionWebClient,
      )
    );

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final transferFeatureItem = find.byWidgetPredicate((widget) {
      return MatchersUtils.featureItemMatcher(widget,"Transfer",Icons.monetization_on);
    });
    expect(transferFeatureItem, findsOneWidget);

    await tester.tap(transferFeatureItem);

    // Após ir para a próxima página, o flutter leva um tempo para fazer a renderização da página novamente
    // então é preciso usar esse pump para poder aguardar esse rebuild da raiz do flutter, do BytebankApp
    //await tester.pumpAndSettle();
    for (int i = 0; i < 5; i++) {
      await tester.pump(Duration(seconds: 1));
    }

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll());

    final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
    expect(fabNewContact, findsOneWidget);

    await tester.tap(fabNewContact);
    //await tester.pumpAndSettle(); // vai fazer varias chamadas do pump até que seja resolvida todas as pendências
    for (int i = 0; i < 5; i++) {
      await tester.pump(Duration(seconds: 1));
    }

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    final nameTextField = find.byWidgetPredicate((widget) => MatchersUtils.textFieldMatcher(widget, "Full name"));
    expect(nameTextField, findsOneWidget);
    await tester.enterText(nameTextField, "Roberval");

    final accountNumberTextField = find.byWidgetPredicate((widget) => MatchersUtils.textFieldMatcher(widget, "Account number"));
    expect(accountNumberTextField, findsOneWidget);
    await tester.enterText(accountNumberTextField, "1567");

    final createButton = find.widgetWithText(ElevatedButton, 'Create');
    expect(createButton, findsOneWidget);

    await tester.tap(createButton);

    verify(mockContactDao.save(Contact(0, 'Bruno', 1234)));

    //await tester.pumpAndSettle();
    for (int i = 0; i < 5; i++) {
      // because pumpAndSettle doesn't work with riverpod
      await tester.pump(Duration(seconds: 1));
    }

    await tester.pageBack();

    //await tester.pumpAndSettle(); // Não pega, dá erro de timeout
    for (int i = 0; i < 5; i++) {
      await tester.pump(Duration(seconds: 1));
    }

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);

    verify(mockContactDao.findAll());
  });
}