

import 'package:salla/modules/login/login_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/network/local/cache_helper.dart';

void signOut(context)
{
   CacheHelper.removeData(key: 'token').then((value) {
    if(value)
    {

      navigateAndFinish(context, ShopLoginScreen());
    }
  });
}

String? token = '';