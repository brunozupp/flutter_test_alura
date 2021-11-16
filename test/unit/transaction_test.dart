import 'package:bytebank/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test("Should return the value when create a transaction", () {
    
    final transcation = Transaction(null, 200, null);
    
    expect(transcation.value, 200);
  });

  test("Should show error when create transcation with value less than zero", () {
    expect(() => Transaction(null, 0, null), throwsAssertionError);
  });
}