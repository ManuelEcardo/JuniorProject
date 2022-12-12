import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/models/MainModel/content_model.dart';
import 'package:juniorproj/modules/Lessons/lesson.dart';
import 'package:juniorproj/modules/Quiz/quiz.dart';
import 'package:juniorproj/modules/Units/unitOverview.dart';
import 'package:juniorproj/modules/VideoPlayer/videoPlayer.dart';
import 'package:juniorproj/shared/components/components.dart';

class Unit extends StatelessWidget {

  // int? unitId;  //Get The Unit ID.

  const Unit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {},
      builder: (context,state)
      {
        //var cubit=AppCubit.get(context);
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
                          return AlertDialog(
                            title: Text(
                              'Content of each Unit',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: HexColor('8AA76C'),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            content:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children:
                              const[
                                Text(
                                  'Each Unit contains 2 Lessons and 4 Videos and a Quiz to test your abilities',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),

                                Text(
                                  '-Each Lesson will contain mandatory information to pass the unit',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),

                                Text(
                                  '- The video will improve your listening as well as your vocabularies.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),

                                Text(
                                  '- Quiz will contain a variety of questions, bypass them to get to the next unit.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
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
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index) => unitOverViewBuilder(context,model!.unitOverview!),
                              separatorBuilder: (context,index) => const SizedBox(height: 20,),
                              itemCount: 1),

                          // Visibility(
                          //     visible: model!.unitOverview !=null,
                          //     child: const SizedBox(height: 20,)),

                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index) => lessonBuilder(context,model!.lessons![index], index+1),
                              separatorBuilder: (context,index) => const SizedBox(height: 20,),
                              itemCount: model!.lessons!.length),

                           Visibility(
                            visible: model!.lessons !=null,
                            child: const SizedBox(height: 20,)),

                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index) => videoBuilder(context,model!.videos![index], index+1),
                              separatorBuilder: (context,index) => const SizedBox(height: 20,),
                              itemCount: model!.videos!.length),

                          Visibility(
                              visible: model!.videos !=null,
                              child: const SizedBox(height: 20,)),

                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index) => quizBuilder(context,model!.questions!),
                              separatorBuilder: (context,index) => const SizedBox(height: 20,),
                              itemCount: 1),

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

  Widget unitOverViewBuilder(BuildContext context, List<String> model)
  {

    return GestureDetector(
      onTap: ()
      {
          navigateTo(context,UnitOverview(model));
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top:8.0),
        child: Container(
          padding: const EdgeInsetsDirectional.only(end: 1 ,start: 1),
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey
          ),
          child: Column(
            children:const
            [
              Expanded(
                child: Text(
                    'UNIT OVERVIEW',
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget videoBuilder(BuildContext context, Videos model, int index)
  {

    return GestureDetector(
      onTap: ()
      {
          navigateTo(context,VideoGetter(model));

      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top:8.0),
        child: Container(
          padding: const EdgeInsetsDirectional.only(end: 1 ,start: 1),
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey
          ),
          child: Column(
            children: [
              Expanded(
                child: Text(
                  'VIDEO $index: ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              Expanded(
                child:  Text(
                  model.videoTitle!.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget lessonBuilder(BuildContext context, Lessons model, int index)
  {
    return GestureDetector(
      onTap: ()
      {
        navigateTo(context,Lesson(model));
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top:8.0),
        child: Container(
          padding: const EdgeInsetsDirectional.only(end: 1 ,start: 1),
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey
          ),
          child: Column(
            children: [
               Expanded(
                child: Text(
                  'LESSON $index:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              Expanded(
                child:  Text(
                  model.lessonTitle.toUpperCase(),
                  //textAlign: TextAlign.start,
                  style:const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quizBuilder(BuildContext context, List<Questions> model)
  {
    return GestureDetector(
      onTap: ()
      {
          // navigateTo(context,QuizPage(model));

        navigateAndSaveRouteSettings(context, QuizPage(model), 'quiz');
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top:8.0),
        child: Container(
          padding: const EdgeInsetsDirectional.only(end: 1 ,start: 1),
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey
          ),
          child: Column(
            children:const
            [
              Expanded(
                child: Text(
                  'QUIZ',
                  textAlign: TextAlign.center,
                  style:TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              Expanded(
                child:  Text(
                  'TEST YOURSELF IN THIS UNIT',
                  //textAlign: TextAlign.start,
                  style:TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// Widget itemBuilder(BuildContext context, List<String> list, ContentModel model)
// {
//   bool canNavigate=true;
//
//   Widget destination(String text) //Will decide the destination when the Container is pressed.
//   {
//     Widget w;
//     if(text =='unit')
//     {
//       w=const UnitOverview();
//     }
//     else if(text == 'video')
//     {
//       w= const VideoGetter();
//     }
//     else if(text=='lesson')
//     {
//       w= const Lesson();
//     }
//
//     else if(text=='quiz')
//     {
//       w= const QuizPage();
//     }
//     else
//     {
//       canNavigate=false;
//       w= const HomePage();
//       DefaultToast(msg: 'Can\'t Proceed', color: Colors.redAccent);
//     }
//
//     return w;
//   }
//
//   return GestureDetector(
//     onTap: ()
//     {
//       Widget navigationWidget=destination(list[2]);
//
//       if(canNavigate ==true)
//       {
//         navigateTo(context,navigationWidget);
//       }
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
//                 list[0].toUpperCase(),
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
//                 list[1].toUpperCase(),
//                 //textAlign: TextAlign.start,
//                 style: TextStyle(
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