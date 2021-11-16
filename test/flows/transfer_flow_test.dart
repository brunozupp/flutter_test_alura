import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_contact_dao.dart';
import '../mocks/mock_transaction_web_client.dart';
import '../utils/matchers_utils.dart';

void main() {
  
  testWidgets("Should transfer to a contact", (tester) async {

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

    final contact = Contact(0,"Alex",1000);

    when(mockContactDao.findAll()).thenAnswer((realInvocation) async => [
      contact
    ]);

    final transferFeatureItem = find.byWidgetPredicate((widget) {
      return MatchersUtils.featureItemMatcher(widget,"Transfer", Icons.monetization_on);
    });
    expect(transferFeatureItem, findsOneWidget);

    await tester.tap(transferFeatureItem);

    // Após ir para a próxima página, o flutter leva um tempo para fazer a renderização da página novamente
    // então é preciso usar esse pump para poder aguardar esse rebuild da raiz do flutter, do BytebankApp
    //await tester.pumpAndSettle();
    for (int i = 0; i < 5; i++) {
      // because pumpAndSettle doesn't work with riverpod
      await tester.pump(Duration(seconds: 1));
    }

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDao.findAll());

    final contactItem = find.byWidgetPredicate((widget) {

      if(widget is ContactItem) {
        return widget.contact.name == "Alex" && widget.contact.accountNumber == 1000;
      }

      return false;
    });

    expect(contactItem, findsOneWidget);

    await tester.tap(contactItem);

    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);

    final contactName = find.text('Alex');
    expect(contactName, findsOneWidget);

    final contactAccountNumber = find.text('1000');
    expect(contactAccountNumber, findsOneWidget);

    final textFieldValue = find.byWidgetPredicate((widget) => MatchersUtils.textFieldMatcher(widget, "Value"));
    expect(textFieldValue, findsOneWidget);

    await tester.enterText(textFieldValue, '200');

    final transferButton = find.widgetWithText(ElevatedButton, "Transfer");
    expect(transferButton, findsOneWidget);
    await tester.tap(transferButton);

    for (int i = 0; i < 5; i++) {
      await tester.pump(Duration(seconds: 1));
    }

    final transactionAuthDialog = find.byType(TransactionAuthDialog);
    expect(transactionAuthDialog, findsOneWidget);

    final textFieldPassword = find.byKey(transactionAuthDialogTextFieldPassword);
    expect(textFieldPassword, findsOneWidget);

    await tester.enterText(textFieldPassword, "1000");

    final cancelButton = find.widgetWithText(TextButton, 'Cancel');
    expect(cancelButton, findsOneWidget);

    final confirmButton = find.widgetWithText(TextButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    when(mockTransactionWebClient.save(Transaction(null,200,contact), '1000'))
        .thenAnswer((realInvocation) async => Transaction(null,200,contact));

    await tester.tap(confirmButton);

    await tester.pumpAndSettle();

    final successDialog = find.byType(SuccessDialog);
    expect(successDialog, findsOneWidget);

    final okButton = find.widgetWithText(TextButton, "Ok");
    expect(okButton, findsOneWidget);

    await tester.tap(okButton);

    await tester.pumpAndSettle();

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);

  });
}