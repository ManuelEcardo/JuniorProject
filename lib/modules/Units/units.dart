import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Units/unit.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';


class Units extends StatelessWidget{

  final String langName;

  const Units(this.langName, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {},
        builder: (context,state)
        {
          var cubit=AppCubit.get(context);
          var model=AppCubit.unitsModel;  //Get The unit model, contains name,level,status and it's language ID.
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
                            title: 'This Course Units',
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children:
                              const[
                                Text(
                                  'Each Course has 6 units, pass all the quizzes to complete the language\'s course.',
                                ),
                              ],
                            ),
                        );
                      }
                      );
                    },
                  ),

                  IconButton(
                      onPressed: ()
                      {
                        AppCubit.get(context).changeTheme();
                      },

                      icon: const Icon(Icons.sunny)),
                ],
              ),
              body: ConditionalBuilder(
                condition: AppCubit.unitsModel !=null,
                fallback: (context)=>const Center(child: CircularProgressIndicator(),),
                builder: (context)=>SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Center(
                          child: Text(
                            '$langName Course',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: pistachioColor,
                            ),

                          ),
                        ),

                        const SizedBox(height: 10,),

                        myDivider(padding: 10),

                        const SizedBox(height: 30,),

                        GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 25,
                          crossAxisSpacing: 25,
                          childAspectRatio: 1/1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children:
                          List.generate(
                            model!.item.length,
                                (index)=> defaultUnitButton(
                                function: ()
                                {
                                  try
                                  {
                                    if(AppCubit.userModel!.user!.userUnits[model!.item[index].languageId]!.contains(model!.item[index].id!)) //If this unit is not locked, then enable navigation to this unit
                                    {
                                      cubit.getUnitContent(model!.item[index].id!); //Get the content of this unit and put it in contentModel
                                      navigateAndSaveRouteSettings(context, Unit(model!.item[index].id!), 'unit');
                                    }
                                    else
                                    {
                                      defaultToast(msg: 'Unit is Locked');
                                    }
                                  }
                                  catch(error)
                                  {
                                    print('error in opening unit, ${error.toString()}');
                                  }
                                },
                                text: 'Unit ${index+1}',
                                isIcon: AppCubit.userModel!.user!.userUnits[model!.item[index].languageId]!.contains(model!.item[index].id!) ? false :true, //If Locked then Lock icon is to be shown
                                icon: AppCubit.userModel!.user!.userUnits[model!.item[index].languageId]!.contains(model!.item[index].id!) ? null : Icons.lock, //Send Lock Icon
                                iconColor: AppCubit.userModel!.user!.userUnits[model!.item[index].languageId]!.contains(model!.item[index].id!)? null : Colors.white //Set it's Color to white
                                ),
                          )
                          ,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            onWillPop: ()async
            {
              model=null;
              AppCubit.unitsModel=null;
              return true;
            },
          );
        },
    );
  }
}
