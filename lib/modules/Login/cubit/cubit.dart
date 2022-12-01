import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/modules/Login/cubit/states.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit(): super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  //LoginModel? loginModel; //Add the id,name,email ....

  IconData suffix= Icons.visibility_outlined;

  bool isPasswordShown=true;

  void changePasswordVisibility()
  {
    isPasswordShown=!isPasswordShown;

    suffix= isPasswordShown? Icons.visibility_outlined :Icons.visibility_off_outlined;

    emit(PasswordVisibilityChangeState());
  }

  // void userLogin(
  // {
  //   required String email,
  //   required String password
  // })
  // {
  //   emit(LoginLoadingState());
  //   MainDioHelper.postData(
  //     url: LOGIN,
  //     data:
  //     {
  //       'email':email,
  //       'password':password,
  //     },
  //   ).then((value)  //when we get the data.
  //   {
  //     print(value.data);
  //     loginModel=LoginModel?.fromJson(value.data);
  //     emit(ShopLoginSuccessState(loginModel!));
  //   }
  //     ).catchError((error)
  //     {
  //       print('ERROR_IN_CUBIT_SIGN_IN_$error');
  //       emit(ShopLoginErrorState(error.toString()));
  //     }
  //     );
  // }

}