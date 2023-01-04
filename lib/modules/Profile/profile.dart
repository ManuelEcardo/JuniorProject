import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Favourites/favourites.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/styles.dart';

import 'change_profile_picture.dart';

//ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var lastNameController = TextEditingController();

  var firstNameController = TextEditingController();

  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state)
      {
        if(state is AppPutUserInfoSuccessState)
          {
            defaultToast(msg: 'Success');
          }
        if(state is AppPutUserInfoErrorState)
          {
            defaultToast(msg: 'Error While Updating');
          }

        if(state is AppPutUserInfoLoadingState)
          {
            defaultToast(msg: 'Updating...');
          }
      },
      builder: (context, state) {
        var cubit= AppCubit.get(context);
        var model=AppCubit.userModel;

        if(model!= null)
        {
          final data = model.user!;

          //had if (data !=null) {firstNameController.text etc.....}
          firstNameController.text= data.firstName!;

          emailController.text=data.email! ;

          lastNameController.text=data.lastName! ;
        }

        return ConditionalBuilder(
            condition: AppCubit.userModel !=null,
            fallback: (context)=>const Center(child: CircularProgressIndicator(),),
            builder: (context)=>Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        if(state is AppPutUserInfoLoadingState || state is AppUserSignOutLoadingState)
                          const LinearProgressIndicator(),

                        const SizedBox(height: 10,),

                        Row(
                          // mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            const Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: TextButton(
                                  onPressed:null,
                                  child: SizedBox(),),
                              ),
                            ),

                            const Spacer(),

                            Align(
                              alignment: AlignmentDirectional.center,
                              child: Column(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    highlightColor: Colors.grey,
                                    onTap: ()
                                    {
                                      navigateTo(context, const ChangeProfilePicture());
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children:
                                      [
                                        CircleAvatar(
                                          backgroundColor: Colors.black12,
                                          radius: 55,
                                          backgroundImage:
                                          AssetImage('assets/images/${model!.user!.userPhoto}'),
                                        ),

                                         const Padding(
                                          padding: EdgeInsetsDirectional.only(end:6, bottom: 2),
                                          child: Icon(
                                              Icons.camera_alt_outlined,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    model.user!.firstName!,
                                    style: defaultHeadlineTextStyle,
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),

                            Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: TextButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:const
                                    [
                                      Text(
                                        'Likes',
                                        style:TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 25,
                                        ),
                                      ),

                                      SizedBox(width: 10,),

                                      Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.redAccent,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                  onPressed: ()
                                  {
                                    navigateTo(context, Favourites());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        defaultFormField(
                            controller: firstNameController,
                            keyboard: TextInputType.text,
                            label: 'First Name',
                            prefix: Icons.person_rounded,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Name is Empty';
                              }
                              return null;
                            }
                        ),

                        const SizedBox(
                          height: 25,
                        ),



                        defaultFormField(
                            controller: lastNameController,
                            keyboard: TextInputType.phone,
                            label: 'Last Name',
                            prefix: Icons.person_rounded,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Phone is Empty';
                              }
                              return null;
                            }
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        // defaultFormField(
                        //     controller: emailController,
                        //     keyboard: TextInputType.emailAddress,
                        //     label: 'Email Address',
                        //     prefix: Icons.email_rounded,
                        //     validate: (String? value) {
                        //       if (value!.isEmpty) {
                        //         return 'Email Address is Empty';
                        //       }
                        //       return null;
                        //     }
                        //     ),

                        const SizedBox(
                          height: 30,
                        ),

                        defaultButton(
                          function: ()
                          {
                            if(formKey.currentState?.validate()==true)
                              {
                                cubit.putUserInfo(
                                  firstNameController.text,
                                  lastNameController.text,
                                  null,
                                );
                              }
                          },
                          text: 'update',
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        Row(
                          children: [
                            TextButton(
                              child: const Text(
                                'Developers',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) {

                                      return defaultAlertDialog(
                                          context: context,
                                          title: 'Thanks for Using our App!',
                                          content: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text('A work of sincere people',),

                                              Text('-Mobile Application: Mohammad Bali',),

                                              Text('-Website: Ayhem Khatib',),

                                              Text('-Back End: Mostafa Hamwi',),

                                              Text('-Structure: Yazan Abd Alkarem',),

                                              Text('-Reports: Ibaa Safieh',),
                                            ],
                                          )
                                      );
                                    });
                              },
                            ),
                            const Spacer(),
                            TextButton(
                              child: const Text(
                                'Logout',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                cubit.logoutUserOut(context);
                                //signOut(context);
                              },
                            ),
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
    );
  }
}
