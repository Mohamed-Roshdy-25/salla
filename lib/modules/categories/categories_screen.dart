// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/cubit.dart';
import 'package:salla/layout/cubit/states.dart';
import 'package:salla/models/categories_model.dart';
import 'package:salla/modules/category_data/category_data_screen.dart';
import 'package:salla/shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildCatItem(
              ShopCubit.get(context).categoriesModel.data.data[index], context),
          separatorBuilder: (context, index) => const Divider(
            thickness: 2.0,
          ),
          itemCount: ShopCubit.get(context).categoriesModel.data.data.length,
        );
      },
    );
  }

  Widget buildCatItem(DataModel model, context) => InkWell(
        onTap: (){
          ShopCubit.get(context).getCategoryData(model.id);
          navigateTo(context, CategoryDataScreen());
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              FadeInImage(
                height: 80.0,
                width: 80.0,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) =>
                const Image(
                    height: 80.0,
                    width: 80.0,
                    fit: BoxFit.cover,
                    image:
                    AssetImage("assets/images/image_loading.gif")),
                placeholder:
                const AssetImage("assets/images/image_loading.gif"),
                image: NetworkImage(model.image),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                model.name,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      );
}
