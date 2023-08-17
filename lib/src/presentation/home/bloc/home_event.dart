abstract class HomeEvent{}

class AddToCart extends HomeEvent {
  int id;

  AddToCart(this.id);
}

class GetProduct extends HomeEvent {}
