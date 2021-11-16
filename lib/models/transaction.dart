import 'contact.dart';

class Transaction {
  final dynamic id;
  final double value;
  final Contact? contact;

  Transaction(
    this.id,
    this.value,
    this.contact,
  ) : assert(value > 0, "Valor deve ser maior que 0");

  Transaction.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      value = json['value'],
      contact = Contact.fromJson(json['contact']);

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'value': value,
        'contact': contact?.toJson(),
      };

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Transaction &&
      other.value == value &&
      other.contact == contact;
  }

  @override
  int get hashCode => value.hashCode ^ contact.hashCode;
}
