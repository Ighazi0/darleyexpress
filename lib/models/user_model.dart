class UserModel {
  final String name;
  final String uid;
  final String email;
  final String phone;
  final String gender;
  final DateTime? birth;
  final DateTime? timestamp;
  final String link;
  final List? wallet;
  final List? address;
  bool verified;
  double coin;

  UserModel(
      {this.name = '',
      this.uid = '',
      this.email = '',
      this.phone = '',
      this.birth,
      this.gender = '',
      this.timestamp,
      this.coin = 0.0,
      this.link = '',
      this.wallet,
      this.address,
      this.verified = false});

  factory UserModel.fromJson(Map json) {
    return UserModel(
      name: json['name'] ?? '',
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      birth: json['birth'] ?? '',
      gender: json['gender'] ?? '',
      timestamp: json['timestamp'] ?? DateTime.now(),
      verified: json['verified'] ?? '',
      coin: json['coin'] ?? '',
      wallet: json['wallet'] ?? [],
      address: json['address'] ?? [],
      link: json['link'] ?? '',
    );
  }
}
