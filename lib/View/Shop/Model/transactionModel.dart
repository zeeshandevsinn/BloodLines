class TransactionModel {
  String image;
  String name;
  String price;
  String date;
  String quantity;

  TransactionModel(
      {this.image = "assets/profile/dp.png",
      this.name = "Wellness CORE Natural Grain",
      this.price = "-\$68.12",
      this.date = "12 dec",
      this.quantity = "2 pc"});
}

List<TransactionModel> transactionList = [
  TransactionModel(),
  TransactionModel(),
  TransactionModel(),
  TransactionModel(),
  TransactionModel(),
];
