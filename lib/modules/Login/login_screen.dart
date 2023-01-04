import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/home_layout.dart';
import 'package:juniorproj/modules/register/register_screen.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';


//ignore: must_be_immutable
class LoginScreen extends StatefulWidget {


  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   var emailController= TextEditingController();

   var passwordController= TextEditingController();

   var formKey= GlobalKey<FormState>();

   @override
   void initState()
   {
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state) async
        {
          if(state is LoginSuccessState)  //The Right way of handling the api, here if login is successful and there is such record then it will print message and token, else message only since there is no token.
            {
              if(state.loginModel.message == 'success')  //Logged in Successfully
              {
                print(state.loginModel.message);
                print(state.loginModel.token);

                await defaultToast(
                    msg: 'Success', //${state.loginModel.message}
                    state: ToastStates.success,
                );

                CacheHelper.saveData(key: 'token', value: state.loginModel.token).then((value)  //to save the token, so I have logged in and moved to home page.
                {
                  token=state.loginModel.token!;  //To renew the token if I logged out and went in again.
                  AppCubit().userData(); //If the user Logged out and then signed in again, it will get the user data model.
                  AppCubit().getUserAchievements(); //Get The User Achievements.
                  navigateAndFinish(context,const HomeLayout());
                });
              }

              else
              {
                print(state.loginModel.message);

                await defaultToast(
                    msg: '${state.loginModel.message}',
                  state: ToastStates.error,
                );
              }

            }

          if(state is LoginErrorState)
            {
              await defaultToast(
                  msg: state.error.toString().substring(0,10),
                  state: ToastStates.error,
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
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline5,
                        ),

                        const SizedBox(height: 5,),

                        Text(
                          'It\'s Time To Learn a New Language!',
                          style: Theme.of(context).textTheme.subtitle1?.copyWith
                            (color: Colors.grey),
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
                            isObscure: LoginCubit.get(context).isPasswordShown,
                            prefix: Icons.lock_outlined,
                            suffix:  LoginCubit.get(context).suffix,
                            suffixIconColor: AppCubit.get(context).isDarkTheme ? Colors.white : Colors.black,
                            onPressedSuffixIcon: ()
                            {
                              LoginCubit.get(context).changePasswordVisibility();
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
                            {

                              if(formKey.currentState!.validate())
                              {
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            }
                        ),

                        const SizedBox(height: 30,),

                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          fallback: (context)=> const Center(child: CircularProgressIndicator()),
                          builder: (context)=> defaultButton(
                              function: ()
                              {
                                if(formKey.currentState!.validate())
                                  {
                                    LoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,);
                                  }
                                //navigateAndFinish(context, const HomeLayout());
                              },
                              text: 'login',
                              background: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                          ),
                        ),

                        const SizedBox(height: 15,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            const Text('Don\'t Have an Email yet?'),
                            const SizedBox(width: 5,),
                            defaultTextButton(
                              onPressed: ()
                              {
                                navigateTo(context, const RegisterScreen());
                              },
                              text: 'sign up',
                            )
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
