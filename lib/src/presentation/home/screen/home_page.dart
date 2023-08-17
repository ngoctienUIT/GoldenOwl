import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_intern_assignment/src/core/utils/constants/app_colors.dart';
import 'package:mobile_intern_assignment/src/core/utils/constants/app_images.dart';
import 'package:mobile_intern_assignment/src/core/widget/custom_scaffold.dart';
import 'package:mobile_intern_assignment/src/data/models/shoes.dart';
import 'package:mobile_intern_assignment/src/presentation/cart/screen/cart_page.dart';
import 'package:mobile_intern_assignment/src/presentation/home/bloc/home_bloc.dart';
import 'package:mobile_intern_assignment/src/presentation/home/bloc/home_event.dart';
import 'package:mobile_intern_assignment/src/presentation/home/bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc()..add(GetProduct()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return CustomScaffold(
      title: "Our Products",
      actionWidget: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CartPage(
                onChange: () => context.read<HomeBloc>().add(GetProduct()),
              ),
            ),
          );
        },
        icon: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          return Stack(
            children: [
              Image.asset(AppImages.imgCart, height: 30),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Center(
                    child: Text(
                      state is HomeLoaded
                          ? state.listItem.length.toString()
                          : "0",
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(GetProduct());
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: state.listShoes.length,
                itemBuilder: (context, index) {
                  int indexShoes = state.listItem.indexWhere(
                      (element) => element.idItem == state.listShoes[index].id);
                  return _buildItem(
                    context,
                    state.listShoes[index],
                    width,
                    indexShoes != -1,
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

  Widget _buildItem(
      BuildContext context, Shoes shoes, double width, bool check) {
    int color = int.parse("0xFF${shoes.color.substring(1, 7)}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: (width - 40) * 1.3,
          width: width - 40,
          decoration: BoxDecoration(
            color: Color(color),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Transform.rotate(
            angle: -pi / 8,
            child: Image.network(shoes.image, height: 250, width: 250),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            shoes.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          shoes.description,
          style: const TextStyle(color: AppColors.gray, fontSize: 16),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              "\$${shoes.price}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 52,
              width: check ? 52 : null,
              child: ElevatedButton(
                onPressed: () {
                  if (!check) {
                    context.read<HomeBloc>().add(AddToCart(shoes.id));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  elevation: 0,
                  padding: check ? EdgeInsets.zero : null,
                ),
                child: check
                    ? Image.asset(AppImages.imgCheck, width: 20, height: 20)
                    : const Text(
                        "Add to cart",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            )
          ],
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
