import 'package:salla/models/change_favorites_model.dart';

abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

class SearchLoadingState extends SearchStates {}

class SearchSuccessState extends SearchStates {}

class SearchErrorState extends SearchStates {}

class SearchLoadingGetFavoritesState extends SearchStates {}

class SearchSuccessGetFavoritesState extends SearchStates {}

class SearchErrorGetFavoritesState extends SearchStates {}


class SearchChangeFavoritesState extends SearchStates {}

class SearchSuccessChangeFavoritesState extends SearchStates {
  final ChangeFavoritesModel? model;

  SearchSuccessChangeFavoritesState(this.model);
}

class SearchErrorChangeFavoritesState extends SearchStates {}

class SearchLoadingHomeDataState extends SearchStates {}

class SearchSuccessHomeDataState extends SearchStates {}

class SearchErrorHomeDataState extends SearchStates {}

