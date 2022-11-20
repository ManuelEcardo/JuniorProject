import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/modules/register/cubit/states.dart';


class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit(): super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  // LoginModel? loginModel; //Add the id,name,email .... , we kept it as LoginModel since it has the same model so no need to change it.

  IconData suffix= Icons.visibility_outlined;

  bool isPasswordShown=true;

  void changePasswordVisibility()
  {
    isPasswordShown=!isPasswordShown;

    suffix= isPasswordShown? Icons.visibility_outlined :Icons.visibility_off_outlined;

    emit(RegisterPasswordVisibilityChangeState());
  }

  // void userRegister(
  // {
  //   required String name,
  //   required String phone,
  //   required String email,
  //   required String password
  // })
  // {
  //   emit(RegisterLoadingState());
  //   DioHelper.postData(
  //     url: REGISTER,
  //     data:
  //     {
  //       'name':name,
  //       'phone':phone,
  //       'email':email,
  //       'password':password,
  //     },
  //   ).then((value)  //when we get the data.
  //   {
  //     print(value.data);
  //     loginModel=LoginModel?.fromJson(value.data);
  //     emit(RegisterSuccessState(loginModel!));
  //   }
  //     ).catchError((error)
  //     {
  //       print(error.toString());
  //       emit(RegisterErrorState(error.toString()));
  //     }
  //     );
  // }

}