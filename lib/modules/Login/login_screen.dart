import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/home_layout.dart';
import 'package:juniorproj/modules/register/register_screen.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {

   var emailController= TextEditingController();
   var passwordController= TextEditingController();
   var formKey= GlobalKey<FormState>();

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
          // if(state is LoginSuccessState)  //The Right way of handling the api, here if login is successful and there is such record then it will print message and token, else message only since there is no token.
          //   {
          //     if(state.loginModel.status == true)
          //     {
          //       print(state.loginModel.message);
          //       print(state.loginModel.data?.token);
          //
          //       await DefaultToast(
          //           msg: '${state.loginModel.message}',
          //           state: ToastStates.SUCCESS,
          //       );
          //
          //       CacheHelper.saveData(key: 'token', value: state.loginModel.data?.token).then((value)  //to save the token, so I have logged in and moved to home page.
          //       {
          //         token=state.loginModel.data!.token!;  //To renew the token if I logged out and went in again.
          //         navigateAndFinish(context, const Layout());
          //       });
          //     }
          //     else
          //     {
          //
          //       print(state.loginModel.message);
          //
          //       await DefaultToast(
          //           msg: '${state.loginModel.message}',
          //         state: ToastStates.ERROR,
          //       );
          //     }
          //
          //   }

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
                              // if(FormKey.currentState!.validate())
                              // {
                              //   LoginCubit.get(context).userLogin(
                              //     email: EmailController.text,
                              //     password: PasswordController.text,
                              //   );
                              // }
                            }
                        ),

                        const SizedBox(height: 30,),

                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          fallback: (context)=> const Center(child: CircularProgressIndicator()),
                          builder: (context)=> defaultButton(
                              function: ()
                              {
                                // if(FormKey.currentState!.validate())
                                //   {
                                //     // LoginCubit.get(context).userLogin(
                                //     //   email: EmailController.text,
                                //     //   password: PasswordController.text,
                                //
                                //   }
                                navigateAndFinish(context, const HomeLayout());
                              },
                              text: 'login'),
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
                                navigateTo(context, RegisterScreen());
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
