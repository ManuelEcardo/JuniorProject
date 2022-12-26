import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Achievements/leaderboards.dart';
import 'package:juniorproj/shared/components/components.dart';

import '../../models/MainModel/achievements_model.dart';
import '../../models/MainModel/userAchievements_model.dart';
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
        var model= AppCubit.achievementsModel; //All Achievements

        var userAchievements = AppCubit.userAchievementsModel; //User's Achievements.

        var cubit= AppCubit.get(context);

        return ConditionalBuilder(
            condition: model !=null,
            fallback: (context)=> const Center(child: CircularProgressIndicator(),),
            builder: (context)=> Padding(
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
                      itemBuilder: (context,index)=> achievementItemBuilder(model!.item[index], userAchievements!, index),
                      separatorBuilder: (context,index)=> myDivider(),
                      itemCount: model!.item.length,
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
            ),

        );
      },
    );
  }

  Widget achievementItemBuilder(AchievementItem model, UserAchievementsModel userModel, int index)
  {
    bool isUnlocked=false;

    for(var i in userModel.item)
      {
        if(i.achievementId==model.id)
          {
            if(i.unlockedAt !=null)
              {
                isUnlocked=true;
              }
          }
      }
    return Visibility(
      visible: model.secret==0,
      child: SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index+1}. ${model.name}',
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

                 Text(
                  isUnlocked==true ?'Completed' : 'Pending',
                  style:  TextStyle(
                    fontSize: 16,
                    letterSpacing: 2,
                    color: Colors.redAccent,
                    decoration: isUnlocked ==true ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }
}
