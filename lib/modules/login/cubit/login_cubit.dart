// ignore_for_file: avoid_print


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/login_model.dart';
import 'package:salla/modules/login/cubit/login_states.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';


class ShopLoginCubit extends Cubit<ShopLoginStates>
{
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  bool obscure = true;
  IconData suffix = Icons.visibility_outlined;

  void changeObscure(){
    obscure = !obscure;
    suffix = obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopLoginChangeObscureState());
  }

  ShopLoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
  })
  {
    emit(ShopLoginLoadingState());

    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);

      emit(ShopLoginSuccessState(loginModel));

    });
  }

}