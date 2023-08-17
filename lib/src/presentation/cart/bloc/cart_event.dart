import '../../../data/entity/cart_item.dart';

abstract class CartEvent {}

class GetCart extends CartEvent {}

class ChangeProduct extends CartEvent {
  bool isIncrease;
  CartItem item;

  ChangeProduct({required this.isIncrease, required this.item});
}

class RemoveProduct extends CartEvent {
  int id;

  RemoveProduct(this.id);
}
