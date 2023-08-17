import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../data/entity/cart_item.dart';

class DbHelper {
  final String tblName = 'cart';
  final String columnQuantity = 'quantity';
  final String columnIdItem = 'idItem';
  final String columnId = 'id';

  static final DbHelper _dbHelper = DbHelper._internal();
  factory DbHelper() => _dbHelper;
  DbHelper._internal();

  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dbDirectory.path, 'mydb.db');
    return await openDatabase(dbPath, version: 1, onCreate: createDb);
  }

  Future createDb(Database db, int version) async {
    return await db.execute(
        "CREATE TABLE $tblName($columnId INTEGER PRIMARY KEY, $columnIdItem INTEGER, $columnQuantity INTEGER)");
  }

  Future<int?> addItemToCart(CartItem cartItem) async {
    var dbClient = await db;
    int? result = await dbClient?.rawInsert(
        "INSERT INTO $tblName($columnIdItem, $columnQuantity) VALUES('${cartItem.idItem}','${cartItem.quantity}')");
    print(cartItem.idItem);
    return result;
  }

  Future<List<CartItem>> getAllItem() async {
    final dbClient = await db;
    var result = await dbClient?.query(tblName);
    List<CartItem> list = result!.isNotEmpty
        ? result.map((item) => CartItem.fromMap(item)).toList()
        : [];
    print(list);
    return list;
  }

  Future<int?> deleteItem(int id) async {
    var dbClient = await db;
    var result =
        await dbClient?.rawDelete('DELETE FROM $tblName WHERE $columnId = $id');
    return result;
  }

  Future<int?> updateItem(CartItem cartItem) async {
    final dbClient = await db;
    var result = await dbClient?.update(tblName, cartItem.toMap(),
        where: "$columnId = ?", whereArgs: [cartItem.id]);
    return result;
  }
}
