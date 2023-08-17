class CartItem {
  int id;
  int idItem;
  int quantity;

  CartItem({required this.id, required this.idItem, required this.quantity});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'idItem': idItem,
      'quantity': quantity,
    };
    return map;
  }

  factory CartItem.fromMap(Map<String, dynamic> map) =>
      CartItem(id: map['id'], idItem: map['idItem'], quantity: map['quantity']);

  CartItem copyWith(int? quantity) {
    return CartItem(
        id: id, idItem: idItem, quantity: quantity ?? this.quantity);
  }
}
