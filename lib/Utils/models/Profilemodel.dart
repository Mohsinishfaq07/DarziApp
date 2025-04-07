class ProfileModel {
  final String name;
  final String email;
  final String mobile;
  final String shopName;
  final String shopAddress;

  ProfileModel({
    required this.name,
    required this.email,
    required this.mobile,
    required this.shopName,
    required this.shopAddress,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
      shopName: map['shopName'] ?? '',
      shopAddress: map['shopAddress'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'shopName': shopName,
      'shopAddress': shopAddress,
    };
  }

  ProfileModel copyWith({
    String? name,
    String? email,
    String? mobile,
    String? shopName,
    String? shopAddress,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      shopName: shopName ?? this.shopName,
      shopAddress: shopAddress ?? this.shopAddress,
    );
  }
}
