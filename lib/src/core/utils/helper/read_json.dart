import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../data/models/shoes.dart';

Future<List<Shoes>> readJson() async {
  List<Shoes> listShoes = [];
  final String response =
  await rootBundle.loadString('assets/json/shoes.json');
  final data = await json.decode(response);
  for (var element in (data["shoes"] as List<dynamic>)) {
    listShoes.add(Shoes.fromJson(element));
  }
  return listShoes;
}