import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Units/unit.dart';
import 'package:juniorproj/shared/components/components.dart';


class Units extends StatelessWidget{

  const Units({Key? key}) : super(key: key);
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
                        return AlertDialog(
                          title: Text(
                            'This Course Units',
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
                                'Each Course has 6 units, pass all the quizzes to complete the language\'s course.',
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
                                function: (){
                                  cubit.getUnitContent(model!.item[index].id!); //Get the content of this unit and put it in contentModel
                                  navigateTo(context,const Unit());
                                },
                                text: 'Unit ${index+1}'),
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
