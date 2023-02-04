import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/styles.dart';
import 'package:showcaseview/showcaseview.dart';

class Settings extends StatefulWidget {

  final String settingsCache='mySettingsCache';  //Page Cache name, in order to not show again after first app launch


  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var lastNameController = TextEditingController();

  var firstNameController = TextEditingController();

  //Global keys for ShowCaseView
  final GlobalKey firstNameGlobalKey= GlobalKey();

  final GlobalKey lastNameGlobalKey= GlobalKey();

  @override
  void initState()
  {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp)
    {
      isFirstLaunch(widget.settingsCache).then((value)
      {
        if(value)
        {
          print('SHOWING SHOWCASE IN PROFILE');
          ShowCaseWidget.of(context).startShowCase([firstNameGlobalKey, lastNameGlobalKey]);
        }

        else
        {
          print('NO SHOWING SHOWCASE IN PROFILE');
        }
      });
    });
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {
          if (state is AppPutUserInfoSuccessState) {
            defaultToast(msg: 'Success');
          }
          if (state is AppPutUserInfoErrorState) {
            defaultToast(msg: 'Error While Updating');
          }

          if (state is AppPutUserInfoLoadingState) {
            defaultToast(msg: 'Updating...');
          }
        },
        builder: (context,state)
        {
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

          return Scaffold(
            appBar: AppBar(

              actions:
              [
                IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
              ],
            ),

            body: ConditionalBuilder(
              condition: AppCubit.userModel !=null,
              fallback: (context)=> const Center(child: CircularProgressIndicator(),),
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
                          const SizedBox(height: 10,),

                          if(state is AppPutUserInfoLoadingState || state is AppUserSignOutLoadingState)
                            const LinearProgressIndicator(),

                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              'Settings',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: defaultHeadlineTextStyle,
                            ),
                          ),

                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              'Change your first and last name',
                              style: Theme.of(context).textTheme.subtitle1?.copyWith
                                (color: Colors.grey),
                            ),
                          ),

                          const SizedBox(height: 75,),


                          ShowCaseView(
                            globalKey: firstNameGlobalKey,
                            title: 'First Name',
                            description: 'You Can Change your first name here, then click update',
                            shapeBorder: const Border(),
                            child: defaultFormField(
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
                          ),

                          const SizedBox(
                            height: 40,
                          ),


                          ShowCaseView(
                            globalKey: lastNameGlobalKey,
                            title: 'Last Name',
                            description: 'Change your last name as well !',
                            shapeBorder: const Border(),
                            child: defaultFormField(
                                controller: lastNameController,
                                keyboard: TextInputType.text,
                                label: 'Last Name',
                                prefix: Icons.person_rounded,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Last Name is Empty';
                                  }
                                  return null;
                                }
                            ),
                          ),

                          const SizedBox(
                            height: 40,
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
                            height: 40,
                          ),

                          defaultButton(
                            function: ()
                            {
                              cubit.logoutUserOut(context);
                            },
                            text: 'logout',
                          ),

                          const SizedBox(
                            height: 40,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                            content: SingleChildScrollView(
                                              child: Column(
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

                                                  Text('-Reports: Ebaa Safieh',),
                                                ],
                                              ),
                                            )
                                        );
                                      });
                                },
                              ),

                              const Spacer(),
                              TextButton(
                                child: const Text(
                                  'Contact Us',
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {

                                        return defaultAlertDialog(
                                            context: context,
                                            title: 'Contact Us Anytime!',
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Text('Get in touch with us through email.',),

                                                  Text('LearnWithVideosNow@gmail.com',),

                                                ],
                                              ),
                                            )
                                        );
                                      });
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

            ),
          );
        },

    );
  }
}
