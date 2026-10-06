class DailyTotalsModel {
  final double totalIncome;
  final double totalOutcome;
  final String todayDate;

  DailyTotalsModel({
    required this.totalIncome,
    required this.totalOutcome,
    required this.todayDate,
  });

  factory DailyTotalsModel.fromJson(Map<String, dynamic> json) {
    final mappedJson = json['message'];
    final income = mappedJson['totalIncome'] ?? 0;
    final outcome = mappedJson['totalOutcome'] ?? 0;
    final today = mappedJson['todayDate'] ?? '-';

    return DailyTotalsModel(
      totalIncome: (income as num).toDouble(),
      totalOutcome: (outcome as num).toDouble(),
      todayDate: today,
    );
  }
}
