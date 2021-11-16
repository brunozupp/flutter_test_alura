class Contact {
  final dynamic id;
  final String name;
  final int accountNumber;

  Contact(
    this.id,
    this.name,
    this.accountNumber,
  );

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, accountNumber: $accountNumber}';
  }

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        accountNumber = json['account_number'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'account_number': accountNumber,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Contact &&
      other.name == name &&
      other.accountNumber == accountNumber;
  }

  @override
  int get hashCode => name.hashCode ^ accountNumber.hashCode;
}
