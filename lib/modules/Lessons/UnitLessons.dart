import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import '../../models/MainModel/content_model.dart';
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
              child: Column(
                children:
                [
                  TextButton(
                    onPressed: ()
                    {
                      navigateTo(context,Lesson(model[7]));
                    },
                      child: Text('item'),
                  )
                ],
              ),
            ),
          );
        }
    );
  }


}
