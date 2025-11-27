

import '../model/cart_model.dart';

abstract class CartsState {}

class CartsInitial extends CartsState {}

class CartsLoading extends CartsState {}

class CartsLoaded extends CartsState {
  final List<CartModel> carts;
  CartsLoaded(this.carts);
}

class CartsError extends CartsState {
  final String message;
  CartsError(this.message);
}
