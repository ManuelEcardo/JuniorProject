import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Units/units.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:juniorproj/shared/styles/styles.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var model=AppCubit.userModel;
          return ConditionalBuilder(
            condition: AppCubit.userModel !=null,
            fallback: (context)=>const Center(child: CircularProgressIndicator(),),
            builder: (context)=>SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.black12,
                                radius: 50,
                                backgroundImage: AssetImage(
                                    'assets/images/robot.gif'), //assets/images/profile.jpg
                              ),

                              const SizedBox(
                                width: 50,
                              ),

                              Expanded(
                                child: Text(
                                  'Welcome Back, ${model!.data!.user![0].firstName}!',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: defaultHeadlineTextStyle,
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
                                    child: defaultButton(
                                        function: ()
                                        {
                                          navigateTo(context, Units());
                                        },
                                        text: "Let's Go")),
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

                    Container(
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: goldenColor, width: 4),
                      //   borderRadius: BorderRadius.circular(5),
                      // ),
                      //height: 180,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Daily Challenge:',
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
                                    child: defaultButton(
                                        function: () {}, text: 'Go Now !')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    myDivider(c: goldenColor),

                    Container(
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
                                child: CircularPercentIndicator(
                                  radius: 45.0,
                                  lineWidth: 8.0,
                                  animation: true,
                                  percent: 0.45,
                                  animationDuration: 800,
                                  progressColor: Colors.redAccent,
                                  backgroundColor: Colors.grey,
                                  center: const Text(
                                    "45.0%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
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
                    //           const Image(image: AssetImage('assets/images/ringfire.gif')),
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
}


