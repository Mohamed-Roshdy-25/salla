// ignore_for_file: use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/cubit.dart';
import 'package:salla/layout/cubit/states.dart';
import 'package:salla/models/faq_model.dart';
import 'package:salla/shared/styles/colors.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(),
        body: ConditionalBuilder(
          condition: state is! GetFAQLoadingState,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                faqDetail(ShopCubit.get(context).faqModel.data!.data![index]),
            separatorBuilder: (context, index) => const Divider(
              thickness: 2.0,
            ),
            itemCount: ShopCubit.get(context).faqModel.data!.data!.length,
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

Widget faqDetail(Datum model) => Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.question,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: defaultColor,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            model.answer,
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
