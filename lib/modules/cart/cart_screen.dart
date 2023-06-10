// ignore_for_file: use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/cubit.dart';
import 'package:salla/layout/cubit/states.dart';
import 'package:salla/models/carts_model.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeCartsState) {
          if (state.model!.status == false) {
            showToast(
              text: state.model!.message,
              state: ToastStates.ERROR,
            );
          } else {
            showToast(
              text: state.model!.message,
              state: ToastStates.SUCCESS,
            );
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition:
              ShopCubit.get(context).cartsModel!.data!.cartItems!.isNotEmpty,
          builder: (context) => Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => buildListProduct(
                          ShopCubit.get(context)
                              .cartsModel!
                              .data!
                              .cartItems![index],
                          context),
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 2.0,
                      ),
                      itemCount: ShopCubit.get(context)
                          .cartsModel!
                          .data!
                          .cartItems!
                          .length,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: defaultColor,
                          border: Border.all(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            const Text('Total Price :',
                                style: TextStyle(fontSize: 20)),
                            const Spacer(),
                            Text(
                                '${ShopCubit.get(context).cartsModel!.data!.total} LE',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if(state is ShopChangeCartsState || state is ShopUpdateCartsState)
                Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(.3),
                  child: const CircularProgressIndicator(color: Colors.cyan,),
                )
            ],
          ),
          fallback: (context) => const Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
      },
    );
  }

  Widget buildListProduct(CartItem? model, context, {bool isOldPrice = true}) =>
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      FadeInImage(
                        height: 120.0,
                        width: 120.0,
                        imageErrorBuilder: (context, error, stackTrace) =>
                        const Image(
                            height: 120.0,
                            width: 120.0,
                            image:
                            AssetImage("assets/images/image_loading.gif")),
                        placeholder:
                        const AssetImage("assets/images/image_loading.gif"),
                        image: NetworkImage(model!.product!.image),
                      ),
                      if (model.product!.discount != 0 && isOldPrice)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          color: Colors.red,
                          child: const Text(
                            'DISCOUNT',
                            style: TextStyle(
                              fontSize: 8.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        model.product!.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.0,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text(
                            model.product!.price.toString(),
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: defaultColor,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          if (model.product!.discount != 0 && isOldPrice)
                            Text(
                              model.product!.oldPrice.toString(),
                              style: const TextStyle(
                                fontSize: 10.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const Spacer(),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  int quantity = model.quantity - 1;
                                  if (quantity != 0) {
                                    ShopCubit.get(context).updateCartData(
                                      productId: model.id,
                                      quantity: quantity,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text('${model.quantity}'),
                              IconButton(
                                onPressed: () {
                                  int quantity = model.quantity + 1;
                                  if (quantity <= 5) {
                                    ShopCubit.get(context).updateCartData(
                                      productId: model.id,
                                      quantity: quantity,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 30),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: defaultColor)
                        ),
                        child: InkWell(
                          onTap: () => ShopCubit.get(context).changeCarts(model.product!.id),
                          child: const Text(
                            'Remove',
                            style: TextStyle(
                              color: defaultColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
