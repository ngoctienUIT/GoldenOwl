import 'package:mobile_intern_assignment/src/data/entity/cart_item.dart';

import '../../../data/models/shoes.dart';

abstract class HomeState {}

class InitState extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  List<Shoes> listShoes;
  List<CartItem> listItem;

  HomeLoaded({required this.listShoes, required this.listItem});
}

class HomeError extends HomeState {
  String error;

  HomeError(this.error);
}
