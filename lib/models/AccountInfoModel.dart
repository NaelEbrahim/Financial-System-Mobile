class AccountInfoModel {
  final String account_number;

  final double account_balance;

  AccountInfoModel(this.account_number, this.account_balance);

  factory AccountInfoModel.fromJson(Map<String, dynamic> json) {
    json = json['message'];
    return AccountInfoModel(json['accountnumber'], json['accountbalance']);
  }
}
