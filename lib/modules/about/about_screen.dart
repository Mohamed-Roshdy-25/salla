// ignore_for_file: use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/cubit.dart';
import 'package:salla/layout/cubit/states.dart';
import '../../models/about_model.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(),
        body: ConditionalBuilder(
          condition: state is! GetAboutLoadingState,
          builder: (context) => aboutDetail(ShopCubit.get(context).aboutModel.data),
          fallback: (context) =>
          const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

Widget aboutDetail(Data model) => Padding(
  padding: const EdgeInsets.all(15.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        model.about,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.cyan.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
);
