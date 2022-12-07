import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';

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

          List<List<String>> list=
          [
            [
              'assets/images/illustration-2.gif', 'Nerdy Robot', '1000'
            ],

            [
              'assets/images/illustration-3.gif', 'Fighter Robot', '500'
            ],
            [
              'assets/images/illustration-4.gif', 'Newbie Robot', '250'
            ],
          ];
          return Scaffold(
            appBar: AppBar(
              actions:
              [
                IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
              ],
            ),

            body: Padding(
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
                        itemBuilder: (context,index)=> itemBuilder(list[index]),
                        separatorBuilder: (context,index) => myDivider(),
                        itemCount: list.length,
                    ),
                  ),

                ],
              ),
            ),
          );
        },
    );
  }

  Widget itemBuilder(List<String> list)
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
             CircleAvatar(
               backgroundColor: Colors.black12,
               radius: 40,
               backgroundImage: AssetImage(
                   list[0]),
             ),

             const SizedBox(width: 15,),

             Expanded(
               child: Text(
                 list[1],
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: const TextStyle(
                   fontSize: 20,
                   fontWeight: FontWeight.w500,
                 ),
               ),
             ),

             const SizedBox(width: 5,),

             Text(
             list[2],
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
