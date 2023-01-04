import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/modules/Login/cubit/states.dart';

import '../../../models/MainModel/login_model.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/main_dio_helper.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit(): super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData suffix= Icons.visibility_outlined;

  bool isPasswordShown=true;

  void changePasswordVisibility()
  {
    isPasswordShown=!isPasswordShown;

    suffix= isPasswordShown? Icons.visibility_outlined :Icons.visibility_off_outlined;

    emit(PasswordVisibilityChangeState());
  }

  LoginModel? loginModel; // Add the id,name,email ....


  void userLogin(
  {
    required String email,
    required String password
  })
  {
    emit(LoginLoadingState());
    MainDioHelper.postData(
      url: login,
      data:
      {
        'email':email,
        'password':password,
      },
      isStatusCheck: true
    ).then((value)  //when we get the data.
    {
      print(value.data);
      loginModel=LoginModel?.fromJson(value.data);
      emit(LoginSuccessState(loginModel!));
    }
      ).catchError((error)
      {
        print('ERROR_IN_CUBIT_SIGN_IN_$error');
        emit(LoginErrorState(error.toString()));
      }
      );
  }

}