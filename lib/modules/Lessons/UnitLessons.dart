import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Lessons/paragraph.dart';
import 'package:juniorproj/shared/components/components.dart';

import '../../models/MainModel/userData_model.dart';

class UnitLessons extends StatelessWidget {

  final int unitId; //Current Unit ID.

  const UnitLessons(this.unitId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var userModel= AppCubit.userModel;
          return Scaffold(
            appBar: AppBar(
              actions:
              [
                IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
              ],
            ),

            body: SingleChildScrollView(
              child: Column(
                children:
                [
                  Center(child: defaultTextButton(
                  onPressed: ()
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
                  text: 'Admit'),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

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
