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
    List<LeaderboardsItem> myModel= leaderboardItemCalculator(userModel, leaderModel);
    print('currentModel is ${myModel.length}');
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
              itemBuilder: (context,index)=> itemBuilder(cubit, myModel[index], userModel.user!.id!),
              separatorBuilder: (context,index) => myDivider(),
              itemCount: myModel.length,
            ),
          ),

        ],
      ),
    );
  }


  //Setting the Five Users to show.
  List<LeaderboardsItem> leaderboardItemCalculator(UserModel userModel, LeaderboardsModel leaderboardsModel)
  {
    List<LeaderboardsItem> modelList= <LeaderboardsItem>[]; //List to be returned containing 5 users.

    LeaderboardsItem? userRegisteredModel;

    int i=0; //Keep item tracking

    if(leaderboardsModel.item.length >=5)  //There Are 5 Users or more in the list
      {
        for (var element in leaderboardsModel.item) //Looping through user's to find current user.
          {
            if(i<4) //Start to loop through 4 items
                {
                  if(element.id == userModel.user!.id)
                  {
                    userRegisteredModel= LeaderboardsItem(id: element.id, firstName: element.firstName, lastName: element.lastName, fullName: element.fullName, points: element.points, userPhoto: element.userPhoto, rank: i);
                    modelList.add(userRegisteredModel);
                    print('PHOTO, ${modelList[i].userPhoto}');
                  }

                  else
                  {
                    LeaderboardsItem? newModel= LeaderboardsItem(id: element.id, firstName: element.firstName, lastName: element.lastName, fullName: element.fullName, points: element.points, userPhoto: element.userPhoto, rank: i);
                    modelList.add(newModel);
                    newModel =null; //Clearing newModel
                  }
                  i++; //Incrementing the number of registered users.
                }

            else if (i==4 && userRegisteredModel ==null) //4 Items have been registered and the user isn't among them, then find him and add him
                {
                  if(element.id == userModel.user!.id)
                  {
                    userRegisteredModel= LeaderboardsItem(id: element.id, firstName: element.firstName, lastName: element.lastName, fullName: element.fullName, points: element.points, userPhoto: element.userPhoto, rank: i);
                    modelList.add(userRegisteredModel);
                    i++;
                  }
                }

            else if (i==4 && userRegisteredModel!.firstName!.isNotEmpty) //4 Items have been registered and the user is among them, add the last item.
                {
                  LeaderboardsItem? newModel= LeaderboardsItem(id: element.id, firstName: element.firstName, lastName: element.lastName, fullName: element.fullName, points: element.points, userPhoto: element.userPhoto, rank: i);
                  modelList.add(newModel);
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
  Widget itemBuilder(AppCubit cubit, LeaderboardsItem model, int userId)
  {
   return Padding(
     padding: const EdgeInsetsDirectional.only(end: 15.0),
     child: Column(
       children: [
         const SizedBox(height: 20,),

         Row(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.center,
           //mainAxisSize: MainAxisSize.max,
           children:
           [
             Stack(
               alignment: Alignment.topLeft,
               children:
               [
                 CircleAvatar(
                   backgroundColor: Colors.black12,
                   radius: 40,
                   backgroundImage: AssetImage('assets/images/${model.userPhoto!}',),

                 ),

                 Padding(
                   padding: const EdgeInsetsDirectional.only(top: 1.0, start: 1.0 ),
                   child: Text(
                       '${model.rank}',
                     style: TextStyle(
                       color: cubit.isDarkTheme ? Colors.redAccent : Colors.black,
                       fontSize: 18
                     ),
                   ),
                 ),
               ],
             ),

             const SizedBox(width: 15,),

             Expanded(
               child: Text(
                 model.fullName!,
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: TextStyle(
                   fontSize: 20,
                   fontWeight: FontWeight.w500,
                   color: userId==model.id! ? goldenColor : null,
                 ),
               ),
             ),

             const SizedBox(width: 5,),

             Text(
             '${model.points!}',
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
             style: const TextStyle(
               fontSize: 18,
               fontWeight: FontWeight.w500,

             ),
             ),

           ],
         ),

         const SizedBox(height: 20,)
       ],
     ),
   );
  }
}
