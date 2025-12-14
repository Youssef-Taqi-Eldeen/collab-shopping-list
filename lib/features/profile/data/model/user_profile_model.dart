class UserProfileModel {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;

  const UserProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
  });

  UserProfileModel copyWith({
    String? name,
    String? phone,
    String? address,
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolder: cardHolder ?? this.cardHolder,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}
