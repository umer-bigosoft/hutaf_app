class HutafSubscription {
  int balance;
  double price;
  String productId;

  HutafSubscription({this.balance, this.price, this.productId});

  HutafSubscription.fromSnapshot(Map<String, dynamic> snapshot) {
    balance = snapshot['balance'];
    price = snapshot['price'].toDouble();
    productId = snapshot['product_id'];
  }
}
