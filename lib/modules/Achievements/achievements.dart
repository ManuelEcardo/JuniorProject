import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Achievements/leaderboards.dart';
import 'package:juniorproj/shared/components/components.dart';

import '../../shared/styles/styles.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {},

      builder: (context,state)
      {
        var cubit= AppCubit.get(context);

        List<String> achieveList=
        [
          '1. Complete Your Information',
          '2. Start a Lesson',
          '3. Take a Quiz',
          '4. Complete a quiz with no mistakes',
          '5. Change your picture'
        ];
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children:
            [
              Text(
                'Achievements:',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: defaultHeadlineTextStyle,
              ),

              const SizedBox(height: 25,),

              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context,index)=> achievementItemBuilder(achieveList[index]),
                    separatorBuilder: (context,index)=> myDivider(),
                    itemCount: achieveList.length,
                ),
              ),

              const SizedBox(height: 10,),

              TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/crown.svg',
                      color: cubit.isDarkTheme? Colors.deepOrange : Colors.blue,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      semanticsLabel: 'Crown',

                    ),

                    const SizedBox(width:15,),

                    const Text(
                        'Leaderboards',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),

                onPressed: ()
                {
                  navigateTo(context, const Leaderboards());
                },
              ),
            ],
          ),
        );
      },
    );


  }
  Widget achievementItemBuilder(String text)
  {
    return SizedBox(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: achievementsStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),

          const SizedBox(height: 10,),
          Row(
            children:
            [
              Text(
                'Status:',
                style: secondaryTextStyle,
              ),

              const SizedBox(width: 5,),
              const Text(
                'Completed',
                style:  TextStyle(
                  fontSize: 16,
                  letterSpacing: 2,
                  color: Colors.redAccent,
                  decoration: TextDecoration.lineThrough
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }
}
