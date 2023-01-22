import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../models/MainModel/content_model.dart';

//ignore: must_be_immutable
class Lesson extends StatelessWidget {

  Lessons model;

  Lesson(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {},

      builder: (context,state)
      {
        return Scaffold(
          appBar: AppBar(
            actions:
            [
              IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox( //was Container
                //height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: itemBuilder(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget itemBuilder(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        Center(
          child:Text(
            'Lesson ${model.id}:',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color:  AppCubit.get(context).isDarkTheme? defaultColor : defaultDarkColor,
            ),
          ),
        ),

        const SizedBox(height: 20,),

        myDivider(),

        const SizedBox(height: 20,),

        Text(
          'Remember:',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
          ),
        ),

        const SizedBox(height: 10,),

        Text(
          model.lessonContent,
          textAlign: TextAlign.start,
          style:const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w100,
          ),
        ),

        const SizedBox(height: 20,),

        Column(
          children:
          [
            Text(
              'Answer the Following: ',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey
              ),
            ),

            const SizedBox(height: 10,),

            Text(
              'What is my Name?',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10,),

            Row(
              children:
              [
                const SizedBox(width: 5,),

                boxBuilder('Choice1'),

                boxBuilder('Choice2'),

                const SizedBox(width: 5,),
              ],
            ),
          ],
        ),

        // Center(
        //   child: TextButton(
        //     onPressed: ()
        //     {
        //
        //     },
        //     child: Text(
        //       'Test yourself ?',
        //       style: TextStyle(
        //         fontSize: 24,
        //         fontWeight: FontWeight.w500,
        //         color: AppCubit.get(context).isDarkTheme? defaultColor : defaultDarkColor,
        //       ),
        //     ),
        //   ),
        // ),

      ],
    );
  }

  Widget boxBuilder(String text,)
  {
    return Expanded(
      child: GestureDetector(

        onTap: ()
        {
          // if(cubit.isBoxTappedQuiz==false)
          // {
          //   print('Box Tapped');
          //   cubit.changeIsBoxTappedQuiz(true);  //Set that the box has been tapped so the user won't be able to change his answer.
          //   cubit.changeIsAnimation(true);
          //   if(answerId == 1)
          //   {
          //     cubit.changeIsCorrectQuiz(true);
          //     correctFalseBuilder(cubit);
          //   }
          //   else
          //   {
          //     cubit.changeIsCorrectQuiz(false);
          //     correctFalseBuilder(cubit);
          //   }
          // }
          // else
          // {
          //   defaultToast(msg: 'You\'ve already chosen an answer');
          // }
        },
        onLongPress: ()
        {
          defaultToast(msg: 'Just Press it :)');
        },

        child: Stack(
          alignment: Alignment.center,
          children:
          [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey, //HexColor('8AA76C'),
              ),
              width: 120,
              height: 75,
            ),

            Text(
              text.capitalize!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
