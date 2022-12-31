class UserSubscription {
  bool active;
  int balance;
  String type;

  UserSubscription({this.active, this.balance, this.type});

  UserSubscription.fromSnapshot(Map<String, dynamic> snapshot) {
    active = snapshot['active'];
    balance = snapshot['balance'];
    type = snapshot['type'];
  }
}
