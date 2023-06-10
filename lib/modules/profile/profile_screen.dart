// ignore_for_file: unnecessary_null_comparison, must_be_immutable, use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/cubit.dart';
import 'package:salla/layout/cubit/states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model?.data?.name??'';
        emailController.text = model?.data?.email??'';
        phoneController.text = model?.data?.phone??'';
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: ConditionalBuilder(
            condition: ShopCubit.get(context).userModel != null,
            builder: (context) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (state is ShopLoadingUpdateUserState)
                        const LinearProgressIndicator(),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        keyboardtype: TextInputType.name,
                        controller: nameController,
                        labeltext: 'Name',
                        prefix: Icons.person,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        keyboardtype: TextInputType.emailAddress,
                        controller: emailController,
                        labeltext: 'Email',
                        prefix: Icons.email_outlined,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        keyboardtype: TextInputType.phone,
                        controller: phoneController,
                        labeltext: 'Phone Number',
                        prefix: Icons.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      defaultButton(
                        function: () {
                          if (formKey.currentState!.validate()) {
                            ShopCubit.get(context).updateUserData(
                              name: nameController.text,
                              phone: phoneController.text,
                              email: emailController.text,
                            );
                          }
                        },
                        text: 'update',
                        background: defaultColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
