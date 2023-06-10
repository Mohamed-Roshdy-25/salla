// ignore_for_file: unnecessary_null_comparison, avoid_print, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/cubit.dart';
import 'package:salla/layout/shop_layout.dart';
import 'package:salla/modules/login/login_screen.dart';
import 'package:salla/modules/onBoarding/onBoarding_screen.dart';
import 'package:salla/modules/search/cubit/search_cubit.dart';
import 'package:salla/shared/bloc_observer.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/network/local/cache_helper.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';
import 'package:salla/shared/styles/themes.dart';

void main() {
  BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      DioHelper.init();
      await CacheHelper.init();

      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

      token = CacheHelper.getData(key: 'token');

      print(token);

      Widget? widget;

      if (onBoarding != null) {
        if (token != null) {
          widget = ShopLayout();
        } else {
          widget = ShopLoginScreen();
        }
      } else {
        widget = OnBoardingScreen();
      }

      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  MyApp({this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => ShopCubit()..getCategories()..getHomeData()..getCarts()..getFavorites(),),
      BlocProvider(create: (context) => SearchCubit(),),
    ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      themeMode: ThemeMode.light,
      home: startWidget,
    ),);
  }
}
