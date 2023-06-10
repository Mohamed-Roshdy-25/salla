// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:salla/layout/cubit/cubit.dart';
import 'package:salla/modules/about/about_screen.dart';
import 'package:salla/modules/faq/faq_screen.dart';
import 'package:salla/modules/profile/profile_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            item(context, Icons.person, 'Profile', () { ShopCubit.get(context).getUserData();
            navigateTo(context, ProfileScreen());}),
            const SizedBox(
              height: 30.0,
            ),
            item(context, Icons.question_answer_outlined, 'FAQ', () {ShopCubit.get(context).getFAQ();
            navigateTo(context, FAQScreen()); }),
            const SizedBox(
              height: 30.0,
            ),
            item(context, Icons.notification_important, 'About Us', () { ShopCubit.get(context).getAbout();
            navigateTo(context, AboutScreen());}),
            const SizedBox(
              height: 30.0,
            ),
            item(context, Icons.logout_outlined, 'Logout', () { signOut(context);}),
          ],
        ),
      ),
    );
  }

  item(context,IconData icon,String title,void Function()? onTap){
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30.0,
                color: Colors.cyan,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.cyan.shade700,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
