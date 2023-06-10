// ignore_for_file: use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/cubit.dart';
import 'package:salla/layout/cubit/states.dart';
import 'package:salla/shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessChangeFavoritesState)
        {
          if(state.model!.status == false)
          {
            showToast(text: state.model!.message, state: ToastStates.ERROR,);
          }else{
            showToast(text: state.model!.message, state: ToastStates.SUCCESS,);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).favoritesModel?.data?.data?.isNotEmpty??false,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildListProduct(
                ShopCubit.get(context)
                    .favoritesModel!
                    .data!
                    .data![index]
                    .product,
                context),
            separatorBuilder: (context, index) => const Divider(
              thickness: 2.0,
            ),
            itemCount:
                ShopCubit.get(context).favoritesModel!.data!.data!.length,
          ),
          fallback: (context) => const Center(
            child: Text('Your favorites is empty',style: TextStyle(fontSize: 20.0),),
          ),
        );
      },
    );
  }
}
