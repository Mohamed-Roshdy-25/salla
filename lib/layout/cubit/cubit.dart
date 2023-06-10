// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/states.dart';
import 'package:salla/models/about_model.dart';
import 'package:salla/models/carts_model.dart';
import 'package:salla/models/categories_model.dart';
import 'package:salla/models/category_data_model.dart';
import 'package:salla/models/change_carts_model.dart';
import 'package:salla/models/change_favorites_model.dart';
import 'package:salla/models/faq_model.dart';
import 'package:salla/models/favorites_model.dart';
import 'package:salla/models/home_model.dart';
import 'package:salla/models/login_model.dart';
import 'package:salla/models/product_details_model.dart';
import 'package:salla/models/update_cart_model.dart';
import 'package:salla/modules/cart/cart_screen.dart';
import 'package:salla/modules/categories/categories_screen.dart';
import 'package:salla/modules/favorites/favorites_screen.dart';
import 'package:salla/modules/products/products_screen.dart';
import 'package:salla/modules/settings/settings_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    CartScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  Map<int?, bool?> carts = {};

  Map<int?, bool?> favorites = {};

  HomeModel? homeModel;

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      for (var element in homeModel!.data!.products!) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
        carts.addAll({
          element.id: element.inCart,
        });
      }

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  ChangeCartsModel? changeCartsModel;

  void changeCarts(int? productId) {
    carts[productId] = !(carts[productId] ?? false);
    emit(ShopChangeCartsState());

    DioHelper.postData(
      url: CARTS,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) async {
      changeCartsModel = ChangeCartsModel.fromJson(value.data);

      if (changeCartsModel?.status == false) {
        carts[productId] = !(carts[productId] ?? false);
        emit(ShopChangeCartsState());
      } else {
        await getCarts();
        emit(ShopSuccessChangeCartsState(changeCartsModel));
      }
    }).catchError((error) {
      carts[productId] = !(carts[productId] ?? false);
      emit(ShopErrorChangeCartsState());
    });
  }

  CartsModel? cartsModel;

  Future<void> getCarts() async {
    emit(ShopLoadingGetCartsState());

    DioHelper.getData(
      url: CARTS,
      token: token,
    ).then((value) {
      cartsModel = CartsModel.fromJson(value.data);

      emit(ShopSuccessGetCartsState());
    }).catchError((error) {
      emit(ShopErrorGetCartsState());
      print(error.toString());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  UpdateCartModel? updateCartModel;

  void updateCartData({required int productId, required int quantity}) {
    emit(ShopUpdateCartsState());

    DioHelper.putData(
      url: 'carts/$productId',
      data: {
        'quantity': '$quantity',
      },
      token: token,
    ).then((value) async {
      updateCartModel = UpdateCartModel.fromJson(value.data);
      if (updateCartModel!.status == true) {
       await getCarts();
        emit(ShopSuccessUpdateCartsState(updateCartModel));
      } else {
        showToast(
          text: updateCartModel!.message,
          state: ToastStates.SUCCESS,
        );
      }

    }).catchError((error) {
      emit(ShopErrorUpdateCartsState());
      print(error.toString());
    });
  }

  void clearCart() {
    emit(ShopClearCartsState());

    DioHelper.deleteAllData(
      url: CARTS,
      token: token,
    ).then((value) {
      emit(ShopSuccessClearCartsState());
    })
            .catchError((error){
          emit(ShopErrorClearCartsState());
        });
  }

  void changeFavorites(int? productId) {
    favorites[productId] == true
        ? favorites[productId] = false
        : favorites[productId] = true;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (changeFavoritesModel!.status == false) {
        favorites[productId] == true
            ? favorites[productId] = false
            : favorites[productId] = true;
        emit(ShopChangeFavoritesState());
      } else {
        getFavorites();
        emit(ShopSuccessChangeFavoritesState(changeFavoritesModel));
      }
    }).catchError((error) {
      favorites[productId] == true
          ? favorites[productId] = false
          : favorites[productId] = true;
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  CategoryDataModel? categoryDataModel;

  void getCategoryData(int? categoryId) {
    emit(ShopLoadingCategoryDataState());

    DioHelper.getData(url: GET_CATEGORIES_DATA, token: token, query: {
      'category_id': '$categoryId',
    }).then((value) {
      categoryDataModel = CategoryDataModel.fromJson(value.data);

      for (var element in categoryDataModel!.data!.data) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      }

      // print(homeModel!.data!.banners![0].image);
      // print(homeModel!.status);

      // print(favorites.toString());

      emit(ShopSuccessCategoryDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoryDataState());
    });
  }

  late CategoriesModel categoriesModel;

  void getCategories() {
    emit(ShopLoadingCategoriesState());

    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      print(userModel!.data!.name);

      emit(ShopSuccessUserDataState());
    })
    //     .catchError((error) {
    //   print(error.toString());
    //   emit(ShopErrorUserDataState());
    // })
    ;
  }

  void updateUserData(
      {required String name, required String email, required String phone}) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      print(userModel!.data!.name);

      emit(ShopSuccessUpdateUserState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }

  late ProductDetailsModel productDetailsModel;

  void getProductDetails(int productId) {
    emit(GetProductDetailsLoadingState());

    DioHelper.getData(
      url: 'products/$productId',
    ).then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      emit(GetProductDetailsSuccessState());
    }).catchError((error) {
      emit(GetProductDetailsErrorState());
      print(error.toString());
    });
  }

  late FaqModel faqModel;

  void getFAQ() {
    emit(GetFAQLoadingState());

    DioHelper.getData(
      url: FAQ,
    ).then((value) {
      faqModel = FaqModel.fromJson(value.data);
      emit(GetFAQSuccessState());
    }).catchError((error) {
      emit(GetFAQErrorState());
      print(error.toString());
    });
  }

  late AboutModel aboutModel;

  void getAbout() {
    emit(GetAboutLoadingState());

    DioHelper.getData(
      url: About,
    ).then((value) {
      aboutModel = AboutModel.fromJson(value.data);
      emit(GetAboutSuccessState());
    }).catchError((error) {
      emit(GetAboutErrorState());
      print(error.toString());
    });
  }
}
