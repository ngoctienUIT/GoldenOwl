import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_intern_assignment/src/data/entity/cart_item.dart';
import 'package:mobile_intern_assignment/src/data/models/shoes.dart';
import 'package:mobile_intern_assignment/src/presentation/home/bloc/home_event.dart';
import 'package:mobile_intern_assignment/src/presentation/home/bloc/home_state.dart';

import '../../../core/utils/helper/db_helper.dart';
import '../../../core/utils/helper/read_json.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DbHelper _dbHelper = DbHelper();
  List<Shoes>? _listShoes;

  HomeBloc() : super(InitState()) {
    on<GetProduct>(_getProduct);
    on<AddToCart>(_addToCart);
  }

  Future _getProduct(GetProduct event, Emitter emit) async {
    try {
      emit(HomeLoading());
      _listShoes ??= await readJson();
      emit(HomeLoaded(
        listShoes: _listShoes ?? [],
        listItem: await _dbHelper.getAllItem(),
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future _addToCart(AddToCart event, Emitter emit) async {
    await _dbHelper
        .addItemToCart(CartItem(id: 0, idItem: event.id, quantity: 1));
    emit(HomeLoaded(
      listShoes: _listShoes ?? [],
      listItem: await _dbHelper.getAllItem(),
    ));
  }
}
