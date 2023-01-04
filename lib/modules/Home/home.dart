import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Units/units.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/network/local/cache_helper.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:juniorproj/shared/styles/styles.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../shared/network/local/cache_helper.dart';

class HomePage extends StatefulWidget {

   final String homeCache='myHomeCache';  //Page Cache name, in order to not show again after first app launch

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Three Global keys for ShowCaseView
  final GlobalKey continueKey= GlobalKey();

  final GlobalKey progressKey= GlobalKey();

  final GlobalKey challengeKey= GlobalKey();

  @override
  void initState()
  {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp)
    {
      isFirstLaunch(widget.homeCache).then((value)
      {
        if(value)
        {
          print('SHOWING SHOWCASE');
          ShowCaseWidget.of(context).startShowCase([continueKey, challengeKey, progressKey]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var model=AppCubit.userModel;
          var cubit= AppCubit.get(context);
          return ConditionalBuilder(
            condition: model !=null, //was AppCubit.userModel != null
            fallback: (context)=>const Center(child: CircularProgressIndicator(),),
            builder: (context)=>SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: CircleAvatar(
                                 backgroundColor: Colors.black12,
                                 radius: 50,
                                 backgroundImage: AssetImage(
                                     'assets/images/${model!.user!.userPhoto}'), //assets/images/profile.jpg
                              ),
                                onTap: ()
                                {
                                  cubit.changeBottom(3);
                                },
                              ),

                              const SizedBox(
                                width: 50,
                              ),

                              Expanded(
                                child: Text(
                                  'Welcome Back, ${model.user!.firstName}!',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Padding(
                            padding: const EdgeInsetsDirectional.only(start:5 ),
                            child: Text(
                              'Continue Where You Left Off?',
                              style: ordinaryTextStyle,
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: [
                                const Spacer(),
                                Expanded(
                                    child: ShowCaseView(
                                      globalKey: continueKey,
                                      title: 'Continue your course',
                                      description: 'When pressed, it will take you to the last accessed course',
                                      child: defaultButton(
                                          function: ()
                                          {
                                            List<String>? i;
                                            try
                                            {
                                              i=CacheHelper.getData(key: 'lastAccessedUnit'); //Get Cached Data
                                              if(i !=null) //If units has been accessed before
                                                  {
                                                cubit.getAllUnits(i[0].toInt()!);  // i[0] contains the language Id, i[1] contains the name of the language
                                                navigateTo(context, Units(i[1]));
                                              }
                                              else //No Cached Data, will move user to Languages Page.
                                                  {
                                                cubit.changeBottom(1);
                                              }
                                            }
                                            catch(error)
                                            {
                                              print('Error, ${error.toString()}');
                                              defaultToast(msg: 'You Haven\'t opened a unit yet.');
                                            }

                                          },
                                          text: "Let's Go",
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    myDivider(c: goldenColor),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Daily Challenge',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: defaultHeadlineTextStyle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 5),
                            child: Text(
                              'Learn Five New Words',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ordinaryTextStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Spacer(),

                              Expanded(
                                  child: ShowCaseView(
                                    globalKey: challengeKey,
                                    title: 'Challenges',
                                    description: 'Daily Challenges to increase your points',
                                    child: defaultButton(
                                        function: () {}, text: 'Go Now !'),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    myDivider(c: goldenColor),

                    SizedBox(
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: Colors.black),
                      //   borderRadius: BorderRadius.circular(5),
                      // ),
                      height: 125,

                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Your Progress',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: defaultHeadlineTextStyle,
                            ),
                            const Spacer(),
                            Padding(
                                padding: const EdgeInsetsDirectional.only(start: 10, top: 5),
                                child: ShowCaseView(
                                  globalKey: progressKey,
                                  title: 'Progress',
                                  description: 'You can see your last accessed course progress here!',
                                  child: CircularPercentIndicator(
                                    radius: 45.0,
                                    lineWidth: 8.0,
                                    animation: true,
                                    percent: getCurrentProgress('double'),
                                    animationDuration: 800,
                                    progressColor: Colors.redAccent,
                                    backgroundColor: Colors.grey,
                                    center: Text(
                                      getCurrentProgress('string'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                )
                              // Container(
                              //   height: 80,
                              //   width: 80,
                              //   decoration: BoxDecoration(
                              //       border: Border.all(
                              //         color: Colors.grey,
                              //       ),
                              //       borderRadius:
                              //           const BorderRadius.all(Radius.circular(40))),
                              //   child: Center(
                              //       child: Text(
                              //     '75%',
                              //     style: TextStyle(
                              //       fontSize: 20,
                              //       color: defaultFontColor,
                              //     ),
                              //   )),
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    //
                    // Container(
                    //   height: 160,
                    //   width: 500,
                    //   color: Colors.blue,
                    //
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children:
                    //     [
                    //       Stack(
                    //
                    //         children:
                    //         [
                    //           const Image(image: AssetImage('assets/images/fire-ring.gif')),
                    //
                    //            Container(
                    //              width:250,
                    //              child: const Image(
                    //                image: AssetImage('assets/images/fire.gif'),
                    //                height: 50,
                    //                width: 50,
                    //                alignment: Alignment.center,
                    //              ),
                    //            ),
                    //
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  dynamic getCurrentProgress(String type)
  {
    if(type == 'string')
    {
      List<String>? i;
      double myLangProgress =0.0;
      int langId;

      try
      {
        i=CacheHelper.getData(key: 'lastAccessedUnit');

        if(i !=null)
        {
          print('Getting Cached Progress Bar');

          AppCubit.userModel!.userProgress?.forEach((element) //Loop Through User's Languages
          {
            if(element.languageId == i![0].toInt())
            {
              print('got String Matched Progress Bar');
              myLangProgress = element.progress!;
            }
          });
        }

        else
        {
          if(AppCubit.userModel!.user!.userLanguages.isNotEmpty) //There are languages in his list
              {
            langId= AppCubit.userModel!.user!.userLanguages[0]; //Take the first one

            AppCubit.userModel!.userProgress?.forEach((element) //Loop Through User's Languages
            {
              if(element.languageId == langId)
              {
                myLangProgress = element.progress!;
              }
            });
          }

          // print('Current Language Progress is : $myLangProgress');
          // return myLangProgress;
        }

      }


      catch (error)
      {
        print('Getting Non - Cached Progress Bar');

        if(AppCubit.userModel!.user!.userLanguages.isNotEmpty) //There are languages in his list
            {
          langId= AppCubit.userModel!.user!.userLanguages[0]; //Take the first one
          AppCubit.userModel!.userProgress?.forEach((element) //Loop Through User's Languages
          {
            print(element.languageId);
            if(element.languageId == langId)
            {
              myLangProgress = element.progress!;
            }
          });
        }
      }

      print('Current String Language Progress is : $myLangProgress');
      return '${myLangProgress.toString()}%';
    }

    else if (type =='double')
    {
      List<String>? i;
      double myLangProgress= 0.0;
      String toSwitch='';
      int langId;
      try
      {
        i=CacheHelper.getData(key: 'lastAccessedUnit');

        if(i !=null)
        {
          print('Getting Double Cached Progress Bar');
          AppCubit.userModel!.userProgress?.forEach((element) //Loop Through User's Languages
          {
            if(element.languageId == i![0].toInt())
            {
              print('Progress is: ${element.progress!}');
              myLangProgress = element.progress!;
            }
          });
        }

        else
        {
          if(AppCubit.userModel!.user!.userLanguages.isNotEmpty) //There are languages in his list
              {
            langId= AppCubit.userModel!.user!.userLanguages[0]; //Take the first one

            AppCubit.userModel!.userProgress?.forEach((element) //Loop Through User's Languages
            {
              if(element.languageId == langId)
              {
                myLangProgress = element.progress!;
              }
            });
          }
          //
          // print('Current Language Progress is : $myLangProgress');
          // return myLangProgress;
        }

      }


      catch (error)
      {
        print('Getting Double Non-Cached Progress Bar, ${error.toString()}');

        if(AppCubit.userModel!.user!.userLanguages.isNotEmpty) //There are languages in his list
            {
          langId= AppCubit.userModel!.user!.userLanguages[0]; //Take the first one

          AppCubit.userModel!.userProgress?.forEach((element) //Loop Through User's Languages
          {
            if(element.languageId == langId)
            {
              myLangProgress = element.progress!;
            }
          });
        }
      }

      print('Current Double Language Progress is : $myLangProgress');

      //Adding 0.realValue
      toSwitch= myLangProgress.toString();
      toSwitch= '0.$toSwitch'.substring(0,4);
      myLangProgress= (myLangProgress /100);
      print('myLANG $myLangProgress');
      return myLangProgress;
    }
  }
}




