import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/models/MainModel/content_model.dart';
// import 'package:juniorproj/modules/Lessons/lesson.dart';
import 'package:juniorproj/modules/Quiz/quiz.dart';
import 'package:juniorproj/modules/Units/unitOverview.dart';
import 'package:juniorproj/modules/Videos/UnitsVideos.dart';
// import 'package:juniorproj/modules/Videos/VideoPlayer/videoPlayer.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
// import 'package:showcaseview/showcaseview.dart';

class Unit extends StatefulWidget {


  const Unit({Key? key}) : super(key: key);

  @override
  State<Unit> createState() => _UnitState();
}

class _UnitState extends State<Unit> {


  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        ContentModel? model=AppCubit.contentModel; //Get the content of this unit, UnitOverview, Lessons, Questions and videos

        return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              actions:
              [
                IconButton(
                  icon:const Icon(Icons.question_mark_rounded),
                  onPressed: ()
                  async {
                    await showDialog(
                        context: context,
                        builder: (context)
                        {

                          return defaultAlertDialog(
                              context: context,
                              title: 'Content of each Unit',
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children:
                                const[
                                  Text('Each Unit contains 2 Lessons and 4 Videos and a Quiz to test your abilities',),

                                  Text('-Each Lesson will contain mandatory information to pass the unit',),

                                  Text('- The video will improve your listening as well as your vocabularies.',),

                                  Text('- Quiz will contain a variety of questions, bypass them to get to the next unit.',),
                                ],
                              ),
                          );
                        }
                    );
                  },
                ),

                IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
              ],
            ),

            body: ConditionalBuilder(
              condition: AppCubit.contentModel!=null,
              fallback: (context)=>const Center(child: CircularProgressIndicator(),),
              builder: (context)
                {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                        [
                          Center(
                            child: Text(
                              'Unit Content',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: pistachioColor,
                              ),
                            ),
                          ),

                          const SizedBox(height: 45,),

                          Row(
                            children:
                            [
                              Expanded(child: defaultButtonItem(
                                  function: ()
                                  {
                                    navigateTo(context,UnitOverview(model!.unitOverview!));
                                  },
                                  mainText: 'Unit Overview',
                                  description: "Unit's Goal",
                                  backgroundColor: Colors.grey,
                                  iconColor: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                  icon: Icons.view_agenda_outlined),

                              ),

                              const SizedBox(width: 15,),

                              Expanded(child: defaultButtonItem(
                                  function: ()
                                  {
                                    navigateTo(context, UnitVideos(model!.videos!));
                                  },
                                  mainText: 'Videos',
                                  description: "Unit's Videos",
                                  iconColor: cubit.isDarkTheme? defaultColor : defaultDarkColor,
                                  icon: Icons.ondemand_video_outlined)
                              ),
                            ],
                          ),

                          const SizedBox(height: 15,),

                          Row(
                            children:
                            [
                              Expanded(child: defaultButtonItem(function: (){}, mainText: 'Lessons', iconColor: cubit.isDarkTheme? defaultColor : defaultDarkColor, description: "Unit's Lessons", icon: Icons.play_lesson_outlined)),

                              const SizedBox(width: 15,),

                              Expanded(child:defaultButtonItem(
                                  function: ()
                                  {
                                    if(model!.questions!.isNotEmpty)
                                    {
                                      navigateAndSaveRouteSettings(context, QuizPage(model!.questions!), 'quiz');
                                    }
                                    else if (model!.questions!.isEmpty)
                                    {
                                      defaultToast(msg: 'Quiz is in development');
                                    }
                                  },
                                  mainText: 'Quiz',
                                  description: "Unit's Quiz",
                                  backgroundColor: Colors.grey,
                                  iconColor: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                  icon: Icons.quiz_outlined,

                              )
                              ),
                            ],
                          ),

                          // ListView.separated(
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     itemBuilder: (context,index) => unitOverViewBuilder(context,model!.unitOverview!),
                          //     separatorBuilder: (context,index) => const SizedBox(height: 20,),
                          //     itemCount: 1),
                          //
                          // //NON USED VISIBILITY
                          // // Visibility(
                          // //     visible: model!.unitOverview !=null,
                          // //     child: const SizedBox(height: 20,)),
                          //
                          // ListView.separated(
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     itemBuilder: (context,index) => lessonBuilder(context,model!.lessons![index], index+1),
                          //     separatorBuilder: (context,index) => const SizedBox(height: 20,),
                          //     itemCount: model!.lessons!.length),
                          //
                          //  Visibility(
                          //   visible: model!.lessons !=null,
                          //   child: const SizedBox(height: 20,)),
                          //
                          // ListView.separated(
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     itemBuilder: (context,index) => videoBuilder(context,model!.videos![index], index+1),
                          //     separatorBuilder: (context,index) => const SizedBox(height: 20,),
                          //     itemCount: model!.videos!.length),
                          //
                          // Visibility(
                          //     visible: model!.videos !=null,
                          //     child: const SizedBox(height: 20,)),
                          //
                          // ListView.separated(
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     itemBuilder: (context,index) => quizBuilder(context,model!.questions!),
                          //     separatorBuilder: (context,index) => const SizedBox(height: 20,),
                          //     itemCount: 1),

                        ],
                      ),
                    ),
                  );
                }
            ),
          ),

          onWillPop: ()async
          {
            model=null;
            AppCubit.contentModel=null;
            return true;
          },
        );
      },
    );
  }

  // Widget unitOverViewBuilder(BuildContext context, List<String> model)
  // {
  //
  //   return GestureDetector(
  //     onTap: ()
  //     {
  //         navigateTo(context,UnitOverview(model));
  //     },
  //     child: Padding(
  //       padding: const EdgeInsetsDirectional.only(top:8.0),
  //       child: Container(
  //         padding: const EdgeInsetsDirectional.only(end: 1 ,start: 1),
  //         height: 60,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(5),
  //           color: Colors.grey
  //         ),
  //         child: Column(
  //           children:const
  //           [
  //             Expanded(
  //               child: Text(
  //                   'UNIT OVERVIEW',
  //                 textAlign: TextAlign.center,
  //                 style:  TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget videoBuilder(BuildContext context, Videos model, int index)
  // {
  //
  //   return GestureDetector(
  //     onTap: ()
  //     {
  //         navigateTo(
  //             context,
  //             ShowCaseWidget(
  //                 builder: Builder(
  //                   builder: (context)=>VideoGetter(model),
  //                 )
  //             ),
  //         );
  //
  //     },
  //     child: Padding(
  //       padding: const EdgeInsetsDirectional.only(top:8.0),
  //       child: Container(
  //         padding: const EdgeInsetsDirectional.only(end: 1 ,start: 1),
  //         height: 60,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(5),
  //             color: Colors.grey
  //         ),
  //         child: Column(
  //           children: [
  //             Expanded(
  //               child: Text(
  //                 'VIDEO $index: ',
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //
  //             Expanded(
  //               child:  Text(
  //                 model.videoTitle!.toUpperCase(),
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w300,
  //                   color: Colors.white,
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget lessonBuilder(BuildContext context, Lessons model, int index)
  // {
  //   return GestureDetector(
  //     onTap: ()
  //     {
  //       navigateTo(context,Lesson(model));
  //     },
  //     child: Padding(
  //       padding: const EdgeInsetsDirectional.only(top:8.0),
  //       child: Container(
  //         padding: const EdgeInsetsDirectional.only(end: 1 ,start: 1),
  //         height: 60,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(5),
  //             color: Colors.grey
  //         ),
  //         child: Column(
  //           children: [
  //              Expanded(
  //               child: Text(
  //                 'LESSON $index:',
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //
  //             Expanded(
  //               child:  Text(
  //                 model.lessonTitle.toUpperCase(),
  //                 //textAlign: TextAlign.start,
  //                 style:const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w300,
  //                   color: Colors.white,
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget quizBuilder(BuildContext context, List<Questions> model)
  // {
  //   return GestureDetector(
  //     onTap: ()
  //     {
  //         // navigateTo(context,QuizPage(model));
  //       if(model.isNotEmpty)
  //         {
  //           navigateAndSaveRouteSettings(context, QuizPage(model), 'quiz');
  //         }
  //       else if (model.isEmpty)
  //         {
  //           defaultToast(msg: 'Quiz is in development');
  //         }
  //     },
  //     child: Padding(
  //       padding: const EdgeInsetsDirectional.only(top:8.0),
  //       child: Container(
  //         padding: const EdgeInsetsDirectional.only(end: 1 ,start: 1),
  //         height: 60,
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(5),
  //             color: Colors.grey
  //         ),
  //         child: Column(
  //           children:const
  //           [
  //             Expanded(
  //               child: Text(
  //                 'QUIZ',
  //                 textAlign: TextAlign.center,
  //                 style:TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //
  //             Expanded(
  //               child:  Text(
  //                 'TEST YOURSELF IN THIS UNIT',
  //                 //textAlign: TextAlign.start,
  //                 style:TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w300,
  //                   color: Colors.white,
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
