import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/models/MainModel/content_model.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/MainModel/userData_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../Lessons/paragraph.dart';
import '../Quiz/quiz.dart';

class Exam extends StatelessWidget {

  ContentModel model;

  final int unitId;

  Exam({Key? key, required this.model, required this.unitId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          // var cubit= AppCubit.get(context);
          var userModel= AppCubit.userModel;
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  [
                    Center(
                      child: Text(
                        'Exams',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: pistachioColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40,),

                    Row(
                      children:
                      [
                        const SizedBox(width: 10,),

                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: defaultButtonItem(
                              function: ()
                              {
                                bool isChecked;
                                bool isSubmitted;

                                String? evaluation= getEvaluation(userModel, unitId); //Get Evaluation for this paragraph.

                                String? para= getParagraph(userModel, unitId); //Get paragraph.

                                //No paragraph has been stored yet, so empty => the user hasn't submitted this unit's paragraph before.
                                if(para == null)
                                {
                                  isSubmitted=false;
                                  para='';
                                }
                                else
                                {
                                  isSubmitted=true;
                                }

                                if (evaluation ==null)
                                {
                                  isChecked=false;  //No evaluation, then isChecked is false because no professor has checked it yet
                                  evaluation='';
                                }

                                else
                                {
                                  isChecked=true;
                                }

                                navigateTo(context, Paragraph(unitId:unitId, isSubmitted: isSubmitted, isChecked: isChecked, mark: evaluation, previousParagraph:para ,));

                              },
                              mainText: 'Paragraph',
                              backgroundColor: HexColor('623b5a'),
                              iconColor: HexColor('623b5a'),
                              icon: Icons.text_snippet_outlined,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: defaultButtonItem(
                              function: ()
                              {
                                if(model.questions!.isNotEmpty)
                                {
                                  navigateAndSaveRouteSettings(context, QuizPage(model.questions!), 'quiz');
                                }
                                else if (model.questions!.isEmpty)
                                {
                                  defaultToast(msg: 'Quiz is in development');
                                }
                              },
                              mainText: 'Quiz',
                              backgroundColor: Colors.grey,
                              iconColor: Colors.grey,
                              icon: Icons.quiz_outlined,),
                          ),
                        ),

                        const SizedBox(width: 10,),
                      ],
                    ),

                  ],
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
    required IconData icon,
    Color backgroundColor= Colors.redAccent,
    Color iconColor= Colors.redAccent
  }) =>
      InkWell(
        borderRadius: BorderRadius.circular(20),
        highlightColor: Colors.grey.withOpacity(0.5),
        onTap: function,
        child: Container(
          width: 130,
          height: 130,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
                  size: 28,
                ),
              ),

              Text(
                mainText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );


  String? getEvaluation(UserModel? userModel, int unitId) //Get User Evaluation
  {
    for (var element in userModel!.user!.units!)
    {
      if(element.unitId ==unitId)
      {
        return element.pivot!.evaluation;
      }
    }
    return '';
  }

  String? getParagraph(UserModel? userModel, int unitId)  //Get User Paragraph, if empty then user hasn't submitted one yet, if there is, then we will check for evaluation mark.
  {
    for (var element in userModel!.user!.units!)
    {
      if(element.unitId ==unitId)
      {
        return element.pivot!.paragraph;
      }
    }
    return '';

  }
}
