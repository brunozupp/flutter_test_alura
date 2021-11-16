import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:flutter/material.dart';

import 'package:bytebank/database/dao/contact_dao.dart';

class AppDependencies extends InheritedWidget {

  final ContactDao contactDao;
  final TransactionWebClient transactionWebClient;
  final Widget child;
  
  AppDependencies({
    required this.contactDao,
    required this.transactionWebClient,
    required this.child,
  }) : super(child: child);

  static AppDependencies of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppDependencies>()!;
  }
  
  @override
  bool updateShouldNotify(covariant AppDependencies oldWidget) {
    return contactDao != oldWidget.contactDao || transactionWebClient != oldWidget.transactionWebClient;
  }

}
