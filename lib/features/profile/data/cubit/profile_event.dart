abstract class ProfileEvent {}

class LoadInitialProfile extends ProfileEvent {
  final String name;
  final String email;
  LoadInitialProfile({required this.name, required this.email});
}

class UpdateBasicInfo extends ProfileEvent {
  final String name;
  final String phone;
  UpdateBasicInfo(this.name, this.phone);
}

class UpdateAddress extends ProfileEvent {
  final String address;
  UpdateAddress(this.address);
}

class UpdatePayment extends ProfileEvent {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  UpdatePayment(this.cardNumber, this.cardHolder, this.expiryDate);
}
