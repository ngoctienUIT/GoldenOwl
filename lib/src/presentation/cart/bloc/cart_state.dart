import 'package:mobile_intern_assignment/src/data/entity/cart_item.dart';

import '../../../data/models/shoes.dart';

abstract class CartState {}

class InitState extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  List<Shoes> listShoes;
  List<CartItem> listItem;

  CartLoaded({required this.listShoes, required this.listItem});
}

class CartError extends CartState {
  String error;

  CartError(this.error);
}
