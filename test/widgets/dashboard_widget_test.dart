import 'package:bytebank/main.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_contact_dao.dart';
import '../mocks/mock_transaction_web_client.dart';

void main() {

  final mockContactDao = MockContactDao();
  final mockTransactionWebClient = MockTransactionWebClient();

  testWidgets("Should display the main image when the Dashboard is opened", (WidgetTester tester) async {

    await tester.pumpWidget(
      BytebankApp(
        contactDao: mockContactDao,
        transactionWebClient: mockTransactionWebClient,
      ),
    );

    final mainImage = find.byType(Image);
    
    expect(mainImage, findsOneWidget);
  });

  testWidgets("Should display the main image when the Dashboard is opened - using unnamed route", (WidgetTester tester) async {

    /* Aqui entra aquela questão dos testes de widget terem mais alto acoplamento que os de unidade, pois eu preciso inicializar
     * o MaterialApp para que o Dashboard funcione. No caso do teste acima, como já está configurado para acessar o Dashboard,
     * pode ser daquela maneira.
     */
    await tester.pumpWidget(MaterialApp(
      home: AppDependencies(
        transactionWebClient: mockTransactionWebClient,
        contactDao: MockContactDao(),
        child: Dashboard(),
      ),
    ));

    final mainImage = find.byType(Image);
    
    expect(mainImage, findsOneWidget);
  });

  // Não faz tanto sentido esse teste pois não define algo específico, logo abaixo, vai melhorar ele
  testWidgets("Should display the first feature when the Dashboard is opened", (tester) async {

    await initWidget(tester, Dashboard());

    final firstFeature = find.byType(FeatureItem);

    // expect(firstFeature, findsOneWidget); // vai dar erro pq tem dois elementos e não um
    // expect(firstFeature, findsNWidgets(2)); // vai dar certo pq existe dois elementos
    expect(firstFeature, findsWidgets);
  });

  testWidgets("Should display the transfer feature when the Dashboard is opened", (tester) async {

    await initWidget(tester, Dashboard());

    final iconTransferFeatureItem = find.widgetWithIcon(FeatureItem, Icons.monetization_on);
    expect(iconTransferFeatureItem, findsOneWidget);

    final textTransferFeatureItem = find.widgetWithText(FeatureItem, "Transfer");
    expect(textTransferFeatureItem, findsOneWidget);
  });

  testWidgets("Should display the Transaction Feed feature when the Dashboard is opened", (tester) async {

    await initWidget(tester, Dashboard());

    final iconTransactionFeedFeatureItem = find.widgetWithIcon(FeatureItem, Icons.description);
    expect(iconTransactionFeedFeatureItem, findsOneWidget);

    final textTransactionFeedFeatureItem = find.widgetWithText(FeatureItem, "Transaction Feed");
    expect(textTransactionFeedFeatureItem, findsOneWidget);
  });

  testWidgets("Should display the Transaction Feed feature when the Dashboard is opened - predicate method", (tester) async {

    final MockContactDao mockContactDao = MockContactDao();

    await tester.pumpWidget(
      BytebankApp(
        contactDao: mockContactDao,
        transactionWebClient: mockTransactionWebClient,
      ));

    final transactionFeedFeatureItem = find.byWidgetPredicate((widget) {

      if(widget is FeatureItem) {
        return widget.name == "Transaction Feed" && widget.icon == Icons.description;
      }

      return false;
    });

    expect(transactionFeedFeatureItem, findsOneWidget);
  });

  
}

Future<void> initWidget(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(
    AppDependencies(
      contactDao: MockContactDao(),
      transactionWebClient: MockTransactionWebClient(),
      child: MaterialApp(
        home: widget,
      ),
    ),
  );
}