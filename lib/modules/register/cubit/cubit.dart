import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/modules/register/cubit/states.dart';

import '../../../models/MainModel/register_model.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/main_dio_helper.dart';


class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit(): super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  RegisterModel? registerModel; //Add the id,name,email, etc...

  IconData suffix= Icons.visibility_outlined;

  bool isPasswordShown=true;

  void changePasswordVisibility()
  {
    isPasswordShown=!isPasswordShown;

    suffix= isPasswordShown? Icons.visibility_outlined :Icons.visibility_off_outlined;

    emit(RegisterPasswordVisibilityChangeState());
  }

  void userRegister(
  {
    required String firstname,
    required String lastname,
    required String gender,
    required String birthdate,
    required String email,
    required String password,
  })
  {
    emit(RegisterLoadingState());
    MainDioHelper.postData(
      url: REGISTER,
      data:
      {
        'first_name':firstname,
        'last_name':lastname,
        'gender':gender,
        'birth_date':birthdate,
        'email':email,
        'password':password,
        'password_confirmation':password,
      },
    ).then((value)  //when we get the data.
    {
      print(value.data);
      registerModel=RegisterModel?.fromJson(value.data);
      emit(RegisterSuccessState(registerModel!));
    }
      ).catchError((error)
      {
        print(error.toString());
        emit(RegisterErrorState(error.toString()));
      }
      );
  }

}