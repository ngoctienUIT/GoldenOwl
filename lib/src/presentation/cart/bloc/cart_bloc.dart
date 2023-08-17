import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/helper/db_helper.dart';
import '../../../core/utils/helper/read_json.dart';
import '../../../data/models/shoes.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final DbHelper _dbHelper = DbHelper();
  List<Shoes>? _listShoes;

  CartBloc() : super(InitState()) {
    on<GetCart>(_getProduct);
    on<ChangeProduct>(_changeProduct);
    on<RemoveProduct>(_removeProduct);
  }

  Future _getProduct(GetCart event, Emitter emit) async {
    try {
      emit(CartLoading());
      _listShoes ??= await readJson();
      emit(CartLoaded(
        listShoes: _listShoes ?? [],
        listItem: await _dbHelper.getAllItem(),
      ));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future _changeProduct(ChangeProduct event, Emitter emit) async {
    var quantity =
        event.isIncrease ? ++event.item.quantity : --event.item.quantity;
    print(quantity);
    if (quantity > 0) {
      await _dbHelper.updateItem(event.item.copyWith(quantity));
    } else {
      await _dbHelper.deleteItem(event.item.id);
    }
    emit(CartLoaded(
      listShoes: _listShoes ?? [],
      listItem: await _dbHelper.getAllItem(),
    ));
  }

  Future _removeProduct(RemoveProduct event, Emitter emit) async {
    await _dbHelper.deleteItem(event.id);
    emit(CartLoaded(
      listShoes: _listShoes ?? [],
      listItem: await _dbHelper.getAllItem(),
    ));
  }
}
