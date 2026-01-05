class Cashflow {
  final int id;
  final String title;
  final int amount;
  final String type; // 'income' or 'expense'
  final DateTime date;
  final DateTime createdAt;

  Cashflow({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.createdAt,
  });

  factory Cashflow.fromJson(Map<String, dynamic> json) {
    return Cashflow(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      type: json['type'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}