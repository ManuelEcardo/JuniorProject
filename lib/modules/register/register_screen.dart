import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:juniorproj/layout/home_layout.dart';
import 'package:juniorproj/modules/register/cubit/cubit.dart';
import 'package:juniorproj/modules/register/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';

import '../../layout/cubit/cubit.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var firstNameController= TextEditingController();
  var lastNameController= TextEditingController();

  var phoneController= TextEditingController();
  var emailController= TextEditingController();

  var passwordController= TextEditingController();
  var birthDateController= TextEditingController();

  var formKey= GlobalKey<FormState>();

  List<String> listOfGenders = ['M','F'];
  String currentGender='M';  //User's Gender.

  @override
  Widget build(BuildContext context) {
    return BlocProvider( create:(context)=> RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(

        listener: (context,state) async
        {
          if(state is RegisterSuccessState)  //The Right way of handling the api, here if login is successful and there is such record then it will print message and token, else message only since there is no token.
              {
            if(state.registerModel.message == null)
            {
              print(state.registerModel.message);
              print(state.registerModel.token);

              await defaultToast(
                  msg: 'Success', //${state.registerModel.message}
                  state: ToastStates.success,
              );

              CacheHelper.saveData(key: 'token', value: state.registerModel.token).then((value)  //to save the token, so I have logged in and moved to home page.
              {
                token=state.registerModel.token!;  //To renew the token if I logged out and went in again.

                AppCubit().userData(); //If the user Registered, it will get the user data model.

                AppCubit().getUserAchievements(); //Get The User Achievements.

                AppCubit().getLeaderboards(); //Get Leaderboards because new registered user so we need to update the leaderboards model.

                navigateAndFinish(context, const HomeLayout());
              });
            }
            else
            {
              print(state.registerModel.message);

              await defaultToast(
                  msg: '${state.registerModel.message}',
                  state: ToastStates.error,
              );
            }

          }

          if(state is RegisterErrorState)
            {
              await defaultToast(
                msg: state.error.toString(),
                state: ToastStates.error
              );
            }
        },

        builder: (context,state)
        {
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
                      children:
                      [
                        Text(
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline5,
                        ),

                        const SizedBox(height: 5,),

                        Text(
                          'Register NOW to stay ahead of everyone in every language!',
                          style: Theme.of(context).textTheme.subtitle1?.copyWith
                            (color: Colors.grey),
                        ),

                        const SizedBox(height: 30,),

                        //First Name
                        defaultFormField(
                            controller: firstNameController,
                            keyboard: TextInputType.name,
                            label: 'First Name',
                            prefix: Icons.person,
                            validate: (String? value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'First Name is Empty';
                              }
                              return null;
                            }
                        ),

                        const SizedBox(height: 30,),

                        //Last Name
                        defaultFormField(
                            controller: lastNameController,
                            keyboard: TextInputType.name,
                            label: 'Last Name',
                            prefix: Icons.person,
                            validate: (String? value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Last Name is Empty';
                              }
                              return null;
                            }
                        ),

                        const SizedBox(height: 30,),

                        //Gender Drop Down List.
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  errorStyle:const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                  labelText: 'Gender',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  style: TextStyle(color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor),

                                  value: currentGender,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      currentGender = newValue!;
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: listOfGenders.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),


                        const SizedBox(height: 30,),

                        //Birth Date
                        defaultFormField(
                            controller: birthDateController,
                            keyboard: TextInputType.datetime,
                            label: 'Birth Date',
                            prefix: Icons.date_range,
                            onTap: ()
                            {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1920),
                                  lastDate: DateTime.now(),

                              ).then((value)
                              {
                                birthDateController.text = DateFormat("yyyy-MM-dd").format(value!);  //2011-08-05 DateFormat.yMd().format(value!)
                              });
                            },
                            validate: (String? value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Birth Date is Empty';
                              }
                              return null;
                            }
                        ),

                        const SizedBox(height: 30,),

                        defaultFormField(
                            controller: emailController,
                            keyboard: TextInputType.emailAddress,
                            label: 'Email Address',
                            prefix: Icons.email_outlined,
                            validate: (String? value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Email Address is Empty';
                              }
                              return null;
                            }
                        ),


                        const SizedBox(height: 30,),

                        defaultFormField(
                            controller: passwordController,
                            keyboard: TextInputType.visiblePassword,
                            label: 'Password',
                            isObscure: RegisterCubit.get(context).isPasswordShown,
                            prefix: Icons.lock_outlined,
                            suffix:  RegisterCubit.get(context).suffix,
                            onPressedSuffixIcon: ()
                            {
                              RegisterCubit.get(context).changePasswordVisibility();
                            },
                            validate: (String? value)
                            {
                              if(value!.isEmpty)
                              {
                                return 'Password is Empty';
                              }
                              return null;
                            },

                            onSubmit: (value)
                            {}
                        ),

                        const SizedBox(height: 30,),

                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          fallback: (context)=> const Center(child: CircularProgressIndicator()),
                          builder: (context)=> defaultButton(
                              function: ()
                              {
                                if(formKey.currentState!.validate())
                                {
                                  RegisterCubit.get(context).userRegister(
                                    firstname: firstNameController.text,
                                    lastname: lastNameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    gender: currentGender,
                                    birthdate: birthDateController.text,
                                  );
                                  //navigateAndFinish(context, const HomeLayout());  //Should be removed after connecting with the Database.
                                }
                              },
                              background: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                              text: 'Register'),
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
