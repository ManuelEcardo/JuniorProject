
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/modules/Units/units.dart';
import 'package:juniorproj/shared/components/components.dart';

import '../../shared/styles/colors.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(

      listener: (context,state)
      {},

      builder: (context,state)
      {
        var cubit= AppCubit.get(context);
        List<String> lang=['English','Arabic','Spain'];
        List<String> path=['assets/images/english.png', 'assets/images/arabic.png', 'assets/images/spain.jpg'];
        return ListView.separated(
            physics: const BouncingScrollPhysics() ,
            itemBuilder: (context,index)=> buildCatItem(lang[index], path[index], context),
            separatorBuilder: (context,index)=> myDivider(),
            itemCount: lang.length,
        );
      },

    );
  }

Widget buildCatItem(String text, String path, BuildContext context) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: InkWell(

    highlightColor: defaultColor.withOpacity(0.2),

    onTap: ()
    {
      navigateTo(
        context,
        const Units(),
      );
    },

    child: Row(
      children:
       [
        Image(
          image: AssetImage(path),
          width: 80.0,
          height: 80.0,
          fit: BoxFit.contain,
        ),

        const SizedBox(
          width: 20.0,
        ),

        Text(
          text,
          style:const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
          ),
        ),

        const Spacer(),

        const Icon(Icons.arrow_forward_sharp,),
      ],
    ),
  ),
);

}
