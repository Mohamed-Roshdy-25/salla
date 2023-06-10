// ignore_for_file: use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/cubit.dart';
import 'package:salla/layout/cubit/states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';

import '../../models/product_details_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) => ConditionalBuilder(
          condition: state is! GetProductDetailsLoadingState,
          builder: (context) {
            Data model = ShopCubit.get(context).productDetailsModel.data;
            return Column(
              children: [
                Expanded(
                  flex: 9,
                  child: productDetails(model),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      defaultButton(
                        function: (){
                          ShopCubit.get(context).changeCarts(model.id);
                        },
                        text: ShopCubit.get(context).carts[model.id] == true ? 'In Cart' : 'Add To Cart',
                        width: 150.0,
                        background: ShopCubit.get(context).carts[model.id] == true ? defaultColor : Colors.grey,
                      ),
                      defaultButton(
                        function: (){
                          ShopCubit.get(context).changeFavorites(model.id);
                        },
                        text: ShopCubit.get(context).favorites[model.id] == true ? 'In Favorites' : 'Add To Favorites',
                        width: 150.0,
                        background: ShopCubit.get(context).favorites[model.id] == true ? defaultColor : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

Widget productDetails(Data model) => Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(model.image),
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image),
                  height: 200.0,
                  width: double.infinity,
                ),
                if (model.discount != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    color: Colors.red,
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              model.name,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                const Text(
                  'Price : ',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: defaultColor,
                  ),
                ),
                Text(
                  '${model.price} \$',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                if (model.discount != 0)
                  Text(
                    '${model.oldPrice} \$',
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Description :',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: defaultColor,
              ),
            ),
            Text(
              model.description,
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
