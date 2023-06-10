// ignore_for_file: must_be_immutable, avoid_print, use_key_in_widget_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/shop_layout.dart';
import 'package:salla/modules/login/cubit/login_cubit.dart';
import 'package:salla/modules/login/cubit/login_states.dart';
import 'package:salla/modules/register/register_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/network/local/cache_helper.dart';
import 'package:salla/shared/styles/colors.dart';


class ShopLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel!.status) {
              print(state.loginModel!.message);
              print(state.loginModel!.data!.token);

              CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel!.data!.token)
                  .then((value) {
                token = state.loginModel!.data!.token;
                navigateAndFinish(
                  context,
                  ShopLayout(),
                );
              });

              showToast(
                text: state.loginModel!.message,
                state: ToastStates.SUCCESS,
              );
            } else {
              print(state.loginModel!.message);

              showToast(
                text: state.loginModel!.message,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          var shopLoginCubit = ShopLoginCubit.get(context);

          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          keyboardtype: TextInputType.emailAddress,
                          controller: emailController,
                          labeltext: 'Email',
                          prefix: Icons.email_outlined,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is too short';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          keyboardtype: TextInputType.visiblePassword,
                          controller: passwordController,
                          obscure: shopLoginCubit.obscure,
                          labeltext: 'Password',
                          prefix: Icons.lock,
                          suffix: shopLoginCubit.suffix,
                          suffixpressed: () {
                            shopLoginCubit.changeObscure();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            } else {
                              return null;
                            }
                          },
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              shopLoginCubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                shopLoginCubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'login',
                            isUpperCase: true,
                            background: defaultColor,
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                            ),
                            defaultTextButton(
                              text: 'register now',
                              onPressed: () {
                                navigateTo(
                                  context,
                                  ShopRegisterScreen(),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
