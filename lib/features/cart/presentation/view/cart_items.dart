import '../../../home/model/product_model.dart';
import '../../model/cart_model.dart';
import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();
List<Product> cartItems = [];
List<CartModel> allCarts = [
  CartModel(
    id: uuid.v4(),
    name: "My Personal Cart",
    ownerId: "temp",
    products: [],
    collaborators: [],
  ),
  CartModel(
    id: uuid.v4(),
    name: "Family Cart",
    ownerId: "temp",
    products: [],
    collaborators: [],
  ),
];
