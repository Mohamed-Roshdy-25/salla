// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/search/cubit/search_cubit.dart';
import 'package:salla/modules/search/cubit/search_states.dart';
import 'package:salla/shared/components/components.dart';


class SearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context)
  {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {
          if(state is SearchSuccessChangeFavoritesState)
          {
            if(state.model!.status == false)
            {
              showToast(text: state.model!.message, state: ToastStates.ERROR,);
            }else{
              showToast(text: state.model!.message, state: ToastStates.SUCCESS,);
            }
          }
        },
        builder: (context, state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                      keyboardtype: TextInputType.text,
                      controller: searchController,
                      labeltext: 'search',
                      prefix: Icons.search,
                      onSubmit: (text) {
                        if(formKey.currentState!.validate()) {
                          SearchCubit.get(context).search(text);
                        }
                      },
                      validator: (value) {
                        if(value!.isEmpty)
                        {
                          return 'Enter text to search';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10.0,),
                    if(state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(height: 10.0,),
                    if(state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => buildListProduct(SearchCubit.get(context).model!.data!.data![index], context, isOldPrice: false,),
                          separatorBuilder: (context, index) => const Divider(thickness: 2.0,),
                          itemCount: SearchCubit.get(context).model!.data!.data!.length,
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}
