import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';

import '../../shared/styles/colors.dart';
import '../../shared/styles/styles.dart';

class ChangeProfilePicture extends StatelessWidget {
  const ChangeProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},

        builder: (context,state)
        {
          var cubit= AppCubit.get(context);

          List<String> list=
          [
            'assets/images/robot.gif', 'assets/images/robot 2.gif' ,'assets/images/robot 3.gif' ,'assets/images/robot 4.gif'
          ];

          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children:
                [
                     Center(
                      child: Text(
                        'Choose a New Picture',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: defaultHeadlineTextStyle,
                      ),
                    ),

                    const SizedBox(height: 50,),

                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 25,
                      childAspectRatio: 1.19,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                          list.length,
                          (index) => itemBuilder(cubit, list[index])
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }

  Widget itemBuilder(AppCubit cubit, String image)
  {
    return Column(
      children: [
        InkWell(
          highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            backgroundColor: Colors.black12,
            radius: 60,
            backgroundImage: AssetImage(image),

          ),
          onTap: () //Change User's profile picture.
          {

          },
        ),

        const SizedBox(height: 5,),
        myDivider(),
      ],
    );
  }
}
