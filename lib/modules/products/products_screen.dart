// ignore_for_file: avoid_print, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/cubit.dart';
import 'package:salla/layout/cubit/states.dart';
import 'package:salla/models/categories_model.dart';
import 'package:salla/models/home_model.dart';
import 'package:salla/modules/category_data/category_data_screen.dart';
import 'package:salla/modules/product_details/product_details_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
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
          condition: ShopCubit.get(context).homeModel != null &&
              state is! ShopLoadingCategoriesState,
          builder: (context) => productsBuilder(
              ShopCubit.get(context).homeModel,
              ShopCubit.get(context).categoriesModel,
              context,
              state),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget productsBuilder(HomeModel? model, CategoriesModel? categoriesModel, context, state) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model!.data!.banners!
                  .map(
                    (banner) => FadeInImage(
                        imageErrorBuilder: (context, error, stackTrace) =>
                            const Image(
                                image: AssetImage(
                                    "assets/images/image_loading.gif")),
                        placeholder:
                            const AssetImage("assets/images/image_loading.gif"),
                        image: NetworkImage('${banner.image}')),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 230.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(
                  seconds: 3,
                ),
                autoPlayAnimationDuration: const Duration(
                  seconds: 1,
                ),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 100.0,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => buildCategoryItem(
                          categoriesModel.data.data[index], context),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10.0,
                      ),
                      itemCount: categoriesModel!.data.data.length,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1,
                childAspectRatio: 1 / 1.8,
                children: List.generate(
                  model.data!.products!.length,
                  (index) => buildGridProduct(
                      model.data!.products![index], context, state),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildGridProduct(ProductModel model, context, state) => InkWell(
        onTap: () {
          ShopCubit.get(context).getProductDetails(model.id);
          navigateTo(context, ProductDetailsScreen());
        },
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  FadeInImage(
                    width: double.infinity,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        const Image(
                            image:
                                AssetImage("assets/images/image_loading.gif")),
                    placeholder:
                        const AssetImage("assets/images/image_loading.gif"),
                    image: NetworkImage(model.image),
                    height: 200,
                  ),
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
                          fontSize: 8.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 1.3,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${model.price!.round()}',
                          style: const TextStyle(
                            fontSize: 9,
                            color: defaultColor,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (model.discount != 0)
                          Text(
                            '${model.oldPrice!.round()}',
                            style: const TextStyle(
                              fontSize: 7,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const Spacer(),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                ShopCubit.get(context)
                                    .changeFavorites(model.id);
                              },
                              icon: CircleAvatar(
                                radius: 15.0,
                                backgroundColor: ShopCubit.get(context)
                                            .favorites[model.id] ==
                                        true
                                    ? defaultColor
                                    : Colors.grey,
                                child: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ShopCubit.get(context).changeCarts(model.id);
                              },
                              icon: CircleAvatar(
                                radius: 15.0,
                                backgroundColor:
                                    ShopCubit.get(context).carts[model.id] ??
                                            false
                                        ? defaultColor
                                        : Colors.grey,
                                child: const Icon(
                                  Icons.add_shopping_cart_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildCategoryItem(DataModel model, context) => InkWell(
        onTap: () {
          ShopCubit.get(context).getCategoryData(model.id);
          navigateTo(context, CategoryDataScreen());
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            FadeInImage(
              imageErrorBuilder: (context, error, stackTrace) => const Image(
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/image_loading.gif")),
              placeholder: const AssetImage("assets/images/image_loading.gif"),
              image: NetworkImage(model.image),
            ),

            Container(
              color: Colors.black.withOpacity(
                .8,
              ),

              width: 100.0,
              child: Text(
                model.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
}
