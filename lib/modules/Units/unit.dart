import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Home/home.dart';
import 'package:juniorproj/modules/Lessons/lesson.dart';
import 'package:juniorproj/modules/Quiz/quiz.dart';
import 'package:juniorproj/modules/Units/unitOverview.dart';
import 'package:juniorproj/modules/VideoPlayer/videoPlayer.dart';
import 'package:juniorproj/shared/components/components.dart';

import '../../shared/styles/colors.dart';

class Unit extends StatelessWidget {
  const Unit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {},
      builder: (context,state)
      {
        List<List<String>> list=
        [
          [
            'Unit Overview' , '' , 'unit'
          ],
          [
            'Lesson 1' , 'Remember Subject pronouns' ,'lesson'
          ],

          [
            'Video 1' , 'Interview with Bryan Adams' , 'video'
          ],

          [
            'Video 2' , 'Ellen Degeneres hosts Bill Gates' , 'video'
          ],

          [
            'Lesson 2', "Simple Past and it's uses" ,'lesson'
          ],

          [
            'Video 3', 'Noah Thompson Sings Heartbreak Warfare ' , 'video'
          ],

          [
            'Video 4', 'TED Talk: Waste' , 'video'
          ],

          [
            'Quiz','Test yourself in this unit','quiz'
          ],
        ];

        return Scaffold(
          appBar: AppBar(
            actions:
            [
              IconButton(onPressed: (){AppCubit.get(context).ChangeTheme();}, icon: const Icon(Icons.sunny)),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
              [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context,index) => itemBuilder(context, list[index]),
                      separatorBuilder: (context,index) => const SizedBox(height: 20,),
                      itemCount: list.length),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  Widget itemBuilder(BuildContext context, List<String> list)
  {
    bool canNavigate=true;
    
    Widget destination(String text) //Will decide the destination when the Container is pressed.
    {
      Widget w;
      if(text =='unit')
        {
          w=const UnitOverview();
        }
      else if(text == 'video')
        {
          w= const VideoGetter();
        }
      else if(text=='lesson')
        {
          w= const Lesson();
        }

      else if(text=='quiz')
        {
          w= const QuizPage();
        }
      else
        {
          canNavigate=false;
          w= const HomePage();
          DefaultToast(msg: 'Can\'t Proceed', color: Colors.redAccent);
        }

      return w;
    }
    
    return GestureDetector(
      onTap: ()
      {
        Widget navigationWidget=destination(list[2]);
        
        if(canNavigate ==true)
          {
            navigateTo(context,navigationWidget);
          }
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
                    list[0].toUpperCase(),
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
                  list[1].toUpperCase(),
                  //textAlign: TextAlign.start,
                  style: TextStyle(
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
