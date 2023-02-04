import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class WeeklyTip extends StatelessWidget {
  const WeeklyTip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: BlocConsumer<AppCubit,AppStates>(
          listener: (context,state){},
          builder: (context,state)
          {
            var cubit= AppCubit.get(context);
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Center(
                          child:  Text(
                            "Today's Tip :",
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
                          'Tip Headline',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color:  AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                          ),
                        ),

                        const SizedBox(height: 10,),

                        const Text(
                          'info to be added',
                          textAlign: TextAlign.start,
                          style:const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,),
                        ),
                      ],
                    ),
                  ),
              ),
            );
          },
      ),

      onWillPop: () async
      {
        //Get Next tip
        return true;
      },
    );
  }
}
