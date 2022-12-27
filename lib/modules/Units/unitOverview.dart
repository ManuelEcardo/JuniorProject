import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';

//ignore: must_be_immutable
class UnitOverview extends StatelessWidget {

  List<String> model;

  UnitOverview(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(

      listener: (context,state)
      {},

      builder: (context,state)
      {
        return Scaffold(
          appBar: AppBar(
            actions:
            [
              IconButton(
                  onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
            ],
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(  //was Container
                //height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: itemBuilder(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget itemBuilder(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
         Center(
          child:  Text(
            'Unit Overview:',
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
          'What you will Learn:',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color:  AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
          ),
        ),

        const SizedBox(height: 10,),

        ListView.builder(
            itemCount: model.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context,index)
            {
              return Text(
                model[index],
                textAlign: TextAlign.start,
                style:const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                ),
              );
            },
        ),

        const SizedBox(height: 20,),

         Center(
          child: Text(
            'Good Luck...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color:  AppCubit.get(context).isDarkTheme? defaultColor : defaultDarkColor,
            ),
          ),
        ),

      ],
    );
  }
}


