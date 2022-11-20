import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Units/unit.dart';
import 'package:juniorproj/shared/components/components.dart';

import '../VideoPlayer/videoPlayer.dart';

class Units extends StatelessWidget {
  const Units({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {},
        builder: (context,state)
        {
          var cubit=AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              actions:
              [
                IconButton(onPressed: (){AppCubit.get(context).ChangeTheme();}, icon: const Icon(Icons.sunny)),
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
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 25,
                      childAspectRatio: 1/1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children:
                      List.generate(
                        6,
                            (index)=> defaultUnitButton(
                                function: (){
                                  navigateTo(context, const Unit() );
                                  },
                                text: 'Unit ${index+1}'),
                      )
                      ,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}
