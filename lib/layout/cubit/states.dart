

import 'package:salla/models/change_carts_model.dart';
import 'package:salla/models/change_favorites_model.dart';
import 'package:salla/models/login_model.dart';
import 'package:salla/models/update_cart_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {}

class ShopLoadingCategoryDataState extends ShopStates {}

class ShopSuccessCategoryDataState extends ShopStates {}

class ShopErrorCategoryDataState extends ShopStates {}

class ShopLoadingCategoriesState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {}

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {
  final ChangeFavoritesModel? model;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates {}

class ShopChangeCartsState extends ShopStates {}

class ShopSuccessChangeCartsState extends ShopStates {
  final ChangeCartsModel? model;

  ShopSuccessChangeCartsState(this.model);
}

class ShopErrorChangeCartsState extends ShopStates {}

class ShopUpdateCartsState extends ShopStates {}

class ShopSuccessUpdateCartsState extends ShopStates {
  final UpdateCartModel? model;

  ShopSuccessUpdateCartsState(this.model);
}

class ShopErrorUpdateCartsState extends ShopStates {}

class ShopClearCartsState extends ShopStates {}

class ShopSuccessClearCartsState extends ShopStates {}

class ShopErrorClearCartsState extends ShopStates {}

class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates {}

class ShopLoadingGetCartsState extends ShopStates {}

class ShopSuccessGetCartsState extends ShopStates {}

class ShopErrorGetCartsState extends ShopStates {}

class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {}

class ShopErrorUserDataState extends ShopStates {}

class ShopLoadingUpdateUserState extends ShopStates {}

class ShopSuccessUpdateUserState extends ShopStates {
  final ShopLoginModel? loginModel;

  ShopSuccessUpdateUserState(this.loginModel);
}

class ShopErrorUpdateUserState extends ShopStates {}

class GetProductDetailsLoadingState extends ShopStates {}

class GetProductDetailsSuccessState extends ShopStates {}

class GetProductDetailsErrorState extends ShopStates {}

class GetFAQLoadingState extends ShopStates {}

class GetFAQSuccessState extends ShopStates {}

class GetFAQErrorState extends ShopStates {}

class GetAboutLoadingState extends ShopStates {}

class GetAboutSuccessState extends ShopStates {}

class GetAboutErrorState extends ShopStates {}

