import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../models/MainModel/content_model.dart';

//ignore: must_be_immutable
class Lesson extends StatefulWidget {

  Lessons model;

  Lesson(this.model, {Key? key}) : super(key: key);

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {

  bool isQuestionShown=false;
  bool isAnswersShown=false;

  @override
  void initState()
  {
    isQuestionShown=false;
    isAnswersShown=false;
    super.initState();
  }

  @override
  void dispose()
  {
    isQuestionShown=false;
    isAnswersShown=false;
    super.dispose();
  }

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
                child: itemBuilder(context, widget.model),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget itemBuilder(BuildContext context, Lessons model)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        Center(
          child:Text(
            'Lesson ${widget.model.id}:',
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
          widget.model.lessonContent,
          textAlign: TextAlign.start,
          style:const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w100,
          ),
        ),

        const SizedBox(height: 20,),

        Visibility(
          visible: isQuestionShown==true && model.answer !=null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
               Text(
                'Answer the Following: ',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  color: AppCubit.get(context).isDarkTheme ? goldenColor : Colors.grey
                ),
              ),

              const SizedBox(height: 10,),

              Align(
                alignment: Alignment.center,
                child: Text(
                  model.question!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 15,),

              Row(
                children:
                [
                  const SizedBox(width: 5,),

                  boxBuilder(model.answer,HexColor('8AA76C') ),

                  boxBuilder(model.choice1, Colors.redAccent),

                  const SizedBox(width: 5,),
                ],
              ),
            ],
          ),
        ),

        Visibility(
          visible: isQuestionShown==false,
          child: Center(
            child: TextButton(
              onPressed: ()
              {
                if(model.answer ==null)
                  {
                    defaultToast(msg: 'No Current Questions', length: Toast.LENGTH_LONG);
                  }

                else
                  {
                    setState(()
                    {
                      isQuestionShown=true;
                    });
                  }
              },
              child: Text(
                'Test yourself ?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppCubit.get(context).isDarkTheme? defaultColor : defaultDarkColor,
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

  Widget boxBuilder(String? text, Color color)
  {
    return Expanded(
      child: GestureDetector(

        onTap: ()
        {
          setState(()
          {
            isAnswersShown=true;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children:
          [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: isAnswersShown ? color : Colors.grey, //HexColor('8AA76C'),
              ),
              width: 120,
              height: 75,
            ),

            Text(
              '$text',
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
