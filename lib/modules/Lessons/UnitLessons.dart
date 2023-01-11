import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Lessons/paragraph.dart';
import 'package:juniorproj/shared/components/components.dart';

class UnitLessons extends StatelessWidget {
  const UnitLessons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
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
              child: Column(
                children:
                [
                  Center(child: defaultTextButton(
                  onPressed: ()
                  {
                    navigateTo(context, const Paragraph(isSubmitted: true, isChecked: true, mark: 'A+',)); //Values should come from UserData, aka userModel
                  },
                  text: 'Admit'),),
                ],
              ),
            ),
          );
        }
    );
  }
}
