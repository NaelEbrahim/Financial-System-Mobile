class TransactionModel {
  final String referenceNumber;
  final bool income;
  final double amount;
  final String recordedAt;

  TransactionModel(
    this.referenceNumber,
    this.income,
    this.amount,
    this.recordedAt,
  );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      json['referenceNumber'],
      json['income'],
      json['amount'],
      json['recordedAt'],
    );
  }

  static List<TransactionModel> parseList(Map<String, dynamic> json) {
    final List<dynamic> list = json['message'];

    return List<TransactionModel>.from(
      list.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)),
    );
  }
}
