import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import '../../models/MainModel/content_model.dart';
import '../../shared/styles/colors.dart';
import 'lesson.dart';

class UnitLessons extends StatelessWidget {

  final int unitId; //Current Unit ID.

  final List<Lessons> model;

  const UnitLessons(this.unitId, this.model, {Key? key}) : super(key: key);

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
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  [
                    Center(
                      child: Text(
                        "Unit's Lessons",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: pistachioColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40,),

                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index)=> lessonBuilder(context, model[index], index+1),
                        separatorBuilder: (context,index)=> const SizedBox(height: 15,),
                        itemCount: model.length
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget lessonBuilder(BuildContext context, Lessons model, int index)
  {
    return GestureDetector(
      onTap: ()
      {
        navigateTo(context,Lesson(model, index));
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top:8.0),
        child: Container(
          padding: const EdgeInsetsDirectional.only(end: 1 ,start: 1),
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withOpacity(0.7),
          ),
          child: Column(
            children: [
              const Spacer(),

              Text(
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

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }


}
