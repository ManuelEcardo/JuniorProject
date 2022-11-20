import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Languages/languages.dart';
import 'package:juniorproj/shared/components/components.dart';

class HomeLayout extends StatelessWidget {
   HomeLayout({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {},

      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        return WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title:  GestureDetector(
                onTap: ()
                  {
                    defaultLaunchUrl('https://www.google.com');
                  },
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    color: cubit.isDarkTheme? Colors.deepOrange : Colors.blue,
                    fit: BoxFit.cover,
                    semanticsLabel: 'Logo',

                  ),

                   //const Text(
                //                   'HABLAR',
                //                   style: TextStyle(letterSpacing: 3),
                //                 ),
              ),
              actions:
              [
                //If is Profile => Question mark Icon will show.
                Visibility(
                  visible: cubit.isProfile(),
                  child: IconButton(onPressed: (){}, icon: const Icon(Icons.question_mark_rounded))
                ),

                IconButton(onPressed: (){AppCubit.get(context).ChangeTheme();}, icon: const Icon(Icons.sunny)),
              ],
            ),

            body:  cubit.list[cubit.currentIndex],

            bottomNavigationBar: BottomNavigationBar(

              currentIndex: cubit.currentIndex,

              onTap: (index)
              {
                cubit.changeBottom(index);
              },

              items:
              const [
                BottomNavigationBarItem(label: 'Home' , icon: Icon(Icons.home_rounded)),

                BottomNavigationBarItem(label: 'Languages' , icon: Icon(Icons.language_rounded)),

                BottomNavigationBarItem(label: 'Achievements' , icon: Icon(Icons.gamepad_rounded)),

                BottomNavigationBarItem(label: 'Profile' , icon: Icon(Icons.person_rounded)),

              ],

            ),

            floatingActionButton:Visibility(  //used visibility in order to see if it's the languages page => then show the floating action button.
              visible: cubit.isLanguage(),
              child: FloatingActionButton(
                onPressed: ()
                {

                },
                child: const Icon(Icons.add,),

              ) ,
            ),


          ),

          //Alert Dialog if the user wants to log out.
          onWillPop: ()async
          {
            return ( await showDialog(
                context: context,
                builder: (context)
                {
                  return AlertDialog(
                    title: const Text('Are you sure?', textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                    content: const Icon(Icons.waving_hand, color: Colors.black87, size: 30,),
                    actions:
                    [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                }
            )) ?? false;
          },
        );
      },
    );
  }

}
