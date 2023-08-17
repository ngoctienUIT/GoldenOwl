import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_intern_assignment/src/core/utils/constants/app_colors.dart';
import 'package:mobile_intern_assignment/src/core/utils/constants/app_images.dart';
import 'package:mobile_intern_assignment/src/core/widget/custom_scaffold.dart';
import 'package:mobile_intern_assignment/src/data/entity/cart_item.dart';
import 'package:mobile_intern_assignment/src/data/models/shoes.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.onChange});

  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (context) => CartBloc()..add(GetCart()),
      child: CartView(onChange: onChange),
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key, required this.onChange});

  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      actionWidget: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          double sum = 0;
          if (state is CartLoaded) {
            for (var item in state.listItem) {
              for (var shoes in state.listShoes) {
                if (item.idItem == shoes.id) {
                  sum += item.quantity * shoes.price;
                }
              }
            }
            return Text(
              "\$${sum.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          return const Text(
            "\$0",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      title: "Your cart",
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            onChange();
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CartBloc>().add(GetCart());
              },
              child: ListView.builder(
                itemCount: state.listItem.length,
                itemBuilder: (context, index) {
                  int indexShoes = state.listShoes.indexWhere(
                      (element) => element.id == state.listItem[index].idItem);
                  return buildItem(
                    context,
                    state.listShoes[indexShoes],
                    state.listItem[index],
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, Shoes shoes, CartItem item) {
    int color = int.parse("0xFF${shoes.color.substring(1, 7)}");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Color(color),
                  borderRadius: BorderRadius.circular(360),
                ),
              ),
              Transform.rotate(
                angle: -pi / 8,
                child: Image.network(
                  shoes.image,
                  height: 120,
                  width: 120,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shoes.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "\$${(shoes.price * item.quantity).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    customButton(
                      onTab: () {
                        context
                            .read<CartBloc>()
                            .add(ChangeProduct(isIncrease: false, item: item));
                      },
                      image: AppImages.imgMinus,
                      color: AppColors.gray.withOpacity(0.4),
                    ),
                    const SizedBox(width: 10),
                    Text(item.quantity.toString()),
                    const SizedBox(width: 10),
                    customButton(
                      onTab: () {
                        context
                            .read<CartBloc>()
                            .add(ChangeProduct(isIncrease: true, item: item));
                      },
                      image: AppImages.imgPlus,
                      color: AppColors.gray.withOpacity(0.4),
                    ),
                    const Spacer(),
                    customButton(
                      onTab: () {
                        context.read<CartBloc>().add(RemoveProduct(item.id));
                      },
                      image: AppImages.imgTrash,
                      color: AppColors.yellow,
                    ),
                    const SizedBox(width: 25)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget customButton({
    required VoidCallback onTab,
    required String image,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(360),
        ),
        child: Image.asset(image, height: 15),
      ),
    );
  }
}
