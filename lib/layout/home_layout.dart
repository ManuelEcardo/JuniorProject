import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Languages/addLanguage.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/components/constants.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeLayout extends StatefulWidget {

  final String homeLayoutCache='homeLayoutCache';  //Page Cache name, in order to not show again after first app launch
   const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {


  @override
  void initState()
  {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp)
    // {
    //   isFirstLaunch(widget.homeLayoutCache).then((value)
    //   {
    //     if(value)
    //     {
    //       print('SHOWING SHOWCASE');
    //       ShowCaseWidget.of(context).startShowCase([darkThemeKey]);
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    InternetPopup().initialize(context: context);  //Show Popup When internet connection is lost
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {},

      builder: (context,state)
      {
        var cubit=AppCubit.get(context);

        return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title:  GestureDetector(
                onTap: ()
                  {
                    defaultLaunchUrl('https://www.google.com');
                  },

                onLongPress: ()  //TBD, for developing now
                {
                  signOut(context);
                },
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                    fit: BoxFit.cover,
                    semanticsLabel: 'Logo',
                  ),
              ),

              actions:
              [
                //If is Home => Question mark Icon will show.
                Visibility(
                  visible: cubit.isHome(),
                  child: IconButton(
                    icon: const Icon(Icons.question_mark_rounded),
                    onPressed: ()
                    async {
                      await showDialog(
                          context: context,
                          builder: (context)
                          {
                            return defaultAlertDialog(
                              context: context,
                              title: 'Ready to learn a new language?',
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                  const[
                                     Text('-This is your home page, we will show you a recap here.',),

                                     Text('-If you would like to proceed then press Let\'s Go'),

                                     Text('-Check for challenges, each time you complete one you will earn points.',),

                                     Text('-Your Progress in the current active course will show here.',),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    },
                  ),
                ),

                //If is Language => Question mark Icon will show.
                Visibility(
                  visible: cubit.isLanguage(),
                  child: IconButton(
                    icon: const Icon(Icons.question_mark_rounded),

                    onPressed: ()
                    async {
                      await showDialog(
                          context: context,
                          builder: (context)
                          {
                            return defaultAlertDialog(
                                context: context,
                                title: 'Here You Can add new languages to learn !',
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                    const[
                                      Text('-Press on a language to proceed.',),

                                      Text('-Feeling up to it?\nPress + to take on a new course.',),

                                    ],
                                  ),
                                ),
                            );
                          }
                      );
                    },
                  ),
                ),

                //If is Achievements => Question mark Icon will show.
                Visibility(
                  visible: cubit.isAchievement(),
                  child: IconButton(
                    icon: const Icon(Icons.question_mark_rounded),

                    onPressed: ()
                    async {
                      await showDialog(
                          context: context,
                          builder: (context)
                          {
                            return defaultAlertDialog(
                                context: context,
                                title: 'Play and Earn !',
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                    const[
                                      Text('-Work hard and get paid !\nFor every achievement you get right you will score points.',),

                                      Text('-You can check the Leaderboards for the rivals with the highest points.',),
                                    ],
                                  ),
                                ),
                            );
                          }
                      );
                    },
                  ),
                ),

                //If is Profile => Question mark Icon will show.
                Visibility(
                  visible: cubit.isProfile(),
                  child: IconButton(
                    icon: const Icon(Icons.question_mark_rounded),

                    onPressed: ()
                    async {
                       await showDialog(
                          context: context,
                          builder: (context)
                      {
                        return defaultAlertDialog(
                            context: context,
                            title: 'You can change your personal info too !',
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children:
                                const[
                                  Text('If you\'d like to change your name, change the name box here, then click UPDATE.',),

                                  Text('Same applies for all the other choices.',),
                                ],
                              ),
                            ),
                        );
                      }
                      );
                    },
                  ),
                ),

                IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),

              ],
            ),

            body:  cubit.list[cubit.currentIndex],

            bottomNavigationBar: BottomNavigationBar(

              currentIndex: cubit.currentIndex,

              onTap: (index)
              {
                const Duration(milliseconds: 800);
                cubit.changeBottom(index);
              },

              items:
              const [
                BottomNavigationBarItem(label: 'Home' , icon: Icon(Icons.home_rounded)),

                BottomNavigationBarItem(label: 'Languages' , icon: Icon(Icons.language_rounded)),

                BottomNavigationBarItem(label: 'Achievements' , icon: Icon(Icons.gamepad_rounded)),

                BottomNavigationBarItem(label: 'Profile' , icon: Icon(Icons.person_rounded)),
              ],

            ),

            floatingActionButton:Visibility(  //used visibility in order to see if it's the languages page => then show the floating action button.
              visible: cubit.isLanguage(),
              child: FloatingActionButton(
                onPressed: ()
                {
                  cubit.getLanguages(); //Get The Languages available to be taken.
                  navigateTo(
                      context,
                      ShowCaseWidget(builder: Builder(builder: (context)=> const AddLanguage(),)),
                  );
                },
                child: const Icon(Icons.add,),

              ) ,
            ),


          ),

          //Alert Dialog if the user wants to log out.
          onWillPop: ()async
          {
            return ( await showDialog(
                context: context,
                builder: (context)
                {
                  return AlertDialog(
                    title: const Text('Are you sure?', textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                    content: const Icon(Icons.waving_hand, color: Colors.black87, size: 30,),
                    actions:
                    [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                }
            )) ?? false;
          },
        );
      },
    );
  }
}
