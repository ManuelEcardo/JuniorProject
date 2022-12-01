import 'package:flutter/material.dart';
import 'package:juniorproj/shared/network/local/cache_helper.dart';


import '../../modules/Login/login_screen.dart';
import 'components.dart';

void signOut(BuildContext context)  // A constant SignOut button
{
  CacheHelper.clearData(key: 'token').then((value)  // In order to sign out, delete the record that holds the token value.
  {
    if(value==true)
    {
      navigateAndFinish(context, LoginScreen());
    }
  });
}


void printFullText(String? text)  //If some text is big, it won't show fully, this method will allow it to print fully, no need to understand the code.
{
  final pattern= RegExp('.{1,800}');

  pattern.allMatches(text!).forEach((match)=> print(match.group(0)));
}


String token='';