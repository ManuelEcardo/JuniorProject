import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Favourites/favourites.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:juniorproj/shared/styles/styles.dart';
import 'package:showcaseview/showcaseview.dart';

import '../Settings/settings.dart';
import 'change_profile_picture.dart';

//ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  final String profileCache =
      'myProfileCache'; //Page Cache name, in order to not show again after first app launch

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var lastNameController = TextEditingController();

  var firstNameController = TextEditingController();

  //Four Global keys for ShowCaseView
  final GlobalKey firstNameGlobalKey = GlobalKey();

  final GlobalKey lastNameGlobalKey = GlobalKey();

  final GlobalKey likesGlobalKey = GlobalKey();

  final GlobalKey imageGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isFirstLaunch(widget.profileCache).then((value) {
        if (value) {
          print('SHOWING SHOWCASE IN PROFILE');
          ShowCaseWidget.of(context).startShowCase([
            imageGlobalKey,
            likesGlobalKey,
            firstNameGlobalKey,
            lastNameGlobalKey
          ]);
        } else {
          print('NO SHOWING SHOWCASE IN PROFILE');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = AppCubit.userModel;
        return ConditionalBuilder(
          condition: AppCubit.userModel != null,
          fallback: (context) => const Center(child: CircularProgressIndicator(),),

          builder: (context) => Form(
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
                      const SizedBox(
                        height: 10,
                      ),

                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(30),
                              highlightColor: Colors.grey,
                              onTap: () {
                                navigateTo(
                                    context, const ChangeProfilePicture());
                              },
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ShowCaseView(
                                    globalKey: imageGlobalKey,
                                    title: 'Change your profile image',
                                    description:
                                    'Click on the image to change your picture',
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black12,
                                      radius: 55,
                                      backgroundImage: AssetImage(
                                          'assets/images/${model!.user!.userPhoto}'),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        end: 6, bottom: 2),
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

                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Points',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${model.user!.points}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            width: 15,
                          ),

                          RotatedBox(
                            quarterTurns: 1,
                            child: Container(
                              height: 3,
                              width: 60,
                              color: goldenColor,
                            ),
                          ),

                          const SizedBox(
                            width: 20,
                          ),

                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Rank',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),

                                Text(
                                  '${model.rank}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 70,
                      ),

                      Row(
                        children: [
                          defaultButtonItem(
                              mainText: 'Favourites',
                              icon: Icons.favorite,
                              description: 'Check Your Library',
                              backgroundColor: Colors.redAccent.withOpacity(0.8),
                              function: ()
                              {
                                navigateTo(context, const Favourites());
                              }),

                          const Spacer(),

                          defaultButtonItem(
                              mainText: 'Settings',
                              icon: Icons.settings,
                              description: 'Go To Settings',
                              backgroundColor: Colors.grey,
                              iconColor: Colors.grey,
                              function: ()
                              {
                                navigateTo(
                                    context,
                                    ShowCaseWidget(builder: Builder(builder: (context)=>const Settings(),)));
                              })
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

  Widget defaultButtonItem({
    required void Function()? function,
    required String mainText,
    required String description,
    required IconData icon,
    Color backgroundColor= Colors.redAccent,
    Color iconColor= Colors.redAccent
  }) =>
      InkWell(
        borderRadius: BorderRadius.circular(20),
        highlightColor: Colors.grey.withOpacity(0.5),
        onTap: function,
        child: Container(
          width: 150,
          height: 175,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 15.0),
                child: Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 15.0),
                child: Text(
                  mainText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
               Padding(
                padding: const EdgeInsetsDirectional.only(start: 15.0),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8.0, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
