import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/components/constants.dart';
import 'package:juniorproj/shared/styles/styles.dart';

import 'change_profile_picture.dart';

class ProfilePage extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var lastNameController = TextEditingController();

  var firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit= AppCubit.get(context);
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
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
                        children: const
                        [
                          CircleAvatar(
                            backgroundColor: Colors.black12,
                            radius: 55,
                            backgroundImage:
                                AssetImage('assets/images/robot.gif'),
                          ),

                          Padding(
                            padding: EdgeInsetsDirectional.only(end:6, bottom: 2),
                            child: Icon(Icons.camera_alt_outlined),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Mohammad',
                      style: defaultHeadlineTextStyle,
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
                        cubit.putUserInfo(
                            firstNameController.text,
                            lastNameController.text,
                            null,
                        );
                      },
                      text: 'update',
                    ),

                    const SizedBox(
                      height: 20,
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
                                  return AlertDialog(
                                    title: Text(
                                      'Thanks for Using our App!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: HexColor('8AA76C'),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          'A work of sincere people',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '-Mobile Application: Mohammad Bali',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '-Website: Ayhem Khatib',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '-Back End: Mostafa Hamwi',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '-Structure: Yazan',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '-Reports: Ibaa Safieh',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
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
                            signOut(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
