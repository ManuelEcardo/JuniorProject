import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/models/MainModel/leaderboards_model.dart';
import 'package:juniorproj/models/MainModel/userData_model.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';

import '../../shared/styles/styles.dart';

class Leaderboards extends StatelessWidget {
  const Leaderboards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state) {},

        builder: (context,state)
        {
          var cubit= AppCubit.get(context);
          LeaderboardsModel? model= AppCubit.leaderboardsModel;
          return Scaffold(
            appBar: AppBar(
              actions:
              [
                IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
              ],
            ),
            body: ConditionalBuilder(
                condition: model !=null,
                fallback: (context)=> const Center(child: CircularProgressIndicator(),),
                builder: (context)=> mainBuilder(cubit, AppCubit.userModel!, model!),
            ),
          );
        },
    );
  }

  Widget mainBuilder(AppCubit cubit, UserModel userModel,  LeaderboardsModel leaderModel)
  {
    List<LeaderboardsUser> myModel= leaderboardItemCalculator(userModel, leaderModel);
    myModel.sort((a,b) => a.rank!.compareTo(b.rank!));  //Sorting items by their rank.

    return Padding(
      padding: const EdgeInsetsDirectional.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Center(
            child: Text(
              'Leaderboards:',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: defaultHeadlineTextStyle,
            ),
          ),

          const SizedBox(height: 40,),

          Expanded(
            child: ListView.separated(
              itemBuilder: (context,index)
              {
                if(index==0)
                  {
                    return itemBuilder(cubit, myModel[index], userModel.user!.id!,0);
                  }
                else
                  {
                    return itemBuilder(cubit, myModel[index], userModel.user!.id!, myModel[index-1].rank!);
                  }
              },
              separatorBuilder: (context,index) => myDivider(),
              itemCount: myModel.length,
            ),
          ),

        ],
      ),
    );
  }


  //Setting the Five Users to show.
  List<LeaderboardsUser> leaderboardItemCalculator(UserModel userModel, LeaderboardsModel leaderboardsModel)
  {
    List<LeaderboardsUser> modelList= <LeaderboardsUser>[]; //List to be returned containing 5 users.

    LeaderboardsUser? userRegisteredModel;

    int i=0; //Keep item tracking

    if(leaderboardsModel.item.length >=10)  //There Are 5 Users or more in the list
      {
        for (var element in leaderboardsModel.item) //Looping through user's to find current user.
          {
            if(i<9) //Start to loop through 4 items
                {
                  if(element.user!.id == userModel.user!.id)
                  {
                    LeaderboardsItem a=LeaderboardsItem(id: element.user!.id, firstName: element.user!.firstName, lastName: element.user!.lastName, fullName: element.user!.fullName, points: element.user!.points, userPhoto: element.user!.userPhoto);
                    userRegisteredModel= LeaderboardsUser(rank: element.rank, user: a);
                    modelList.add(userRegisteredModel);
                  }

                  else
                  {
                    LeaderboardsItem? newModel= LeaderboardsItem(id: element.user!.id, firstName: element.user!.firstName, lastName: element.user!.lastName, fullName: element.user!.fullName, points: element.user!.points, userPhoto: element.user!.userPhoto);
                    modelList.add(LeaderboardsUser(rank: element.rank, user: newModel));
                    newModel =null; //Clearing newModel
                  }
                  i++; //Incrementing the number of registered users.
                }

            else if (i==9 && userRegisteredModel ==null) //4 Items have been registered and the user isn't among them, then find him and add him
                {
                  if(element.user!.id == userModel.user!.id)
                  {
                    LeaderboardsItem a=LeaderboardsItem(id: element.user!.id, firstName: element.user!.firstName, lastName: element.user!.lastName, fullName: element.user!.fullName, points: element.user!.points, userPhoto: element.user!.userPhoto);
                    userRegisteredModel= LeaderboardsUser(rank: element.rank, user: a);
                    modelList.add(userRegisteredModel);
                    i++;
                  }
                }

            else if (i==9 && userRegisteredModel!.user!.firstName!.isNotEmpty) //4 Items have been registered and the user is among them, add the last item.
                {
                  LeaderboardsItem? newModel= LeaderboardsItem(id: element.user!.id, firstName: element.user!.firstName, lastName: element.user!.lastName, fullName: element.user!.fullName, points: element.user!.points, userPhoto: element.user!.userPhoto);
                  modelList.add(LeaderboardsUser(rank: element.rank, user: newModel));
                  newModel =null; //Clearing newModel
                  i++;
                }
          }
      }

    else  //Less than five, then send them back.
      {
        modelList= leaderboardsModel.item;
      }

    return modelList;
  }


  //UI Item Builder
  Widget itemBuilder(AppCubit cubit, LeaderboardsUser model, int userId, int previousRank)
  {
   return Padding(
     padding: const EdgeInsetsDirectional.only(end: 15.0),
     child: Column(
       children: [
         const SizedBox(height: 10,),

         if(model.rank != previousRank + 1)  //If It's not the next ex 9-> 12  --> put ... , otherwise it's 1->2  or 9->10 , but if there is a jump then add ...

         RichText(
           text:  TextSpan(
               text: '•\r\n•',
              style: TextStyle(
                  fontSize: 20,
                  color: cubit.isDarkTheme? Colors.white : Colors.black
              ),
           ),
         ),

         Row(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.center,
           //mainAxisSize: MainAxisSize.max,
           children:
           [
             CircleAvatar(
               backgroundColor: Colors.black12,
               radius: 30,
               backgroundImage: AssetImage('assets/images/${model.user!.userPhoto!}',),

             ),

             const SizedBox(width: 15,),

             Expanded(
               child: Text(
                 '${model.rank}. ${model.user!.fullName!}',
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: TextStyle(
                   fontSize: 18,
                   fontWeight: FontWeight.w500,
                   color: userId==model.user!.id! ? goldenColor : null,
                 ),
               ),
             ),

             const SizedBox(width: 5,),

             Text(
             '${model.user!.points!}',
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
             style: const TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.w500,

             ),
             ),

           ],
         ),

         const SizedBox(height: 10,)
       ],
     ),
   );
  }

}
