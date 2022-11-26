import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/styles.dart';

class AddLanguage extends StatelessWidget {
  const AddLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit= AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions:
            [
              IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
            ],
          ),

          body: ConditionalBuilder(
              condition: true,
              builder: (context)=> itemBuilder(cubit),
              fallback: (context) => const Center(child: CircularProgressIndicator(),),
          ),
        );
      },
    );
  }

  Widget itemBuilder(AppCubit cubit)
  {
    return Padding(
      padding: const EdgeInsetsDirectional.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children:
          [
            Text(
              'Choose a Language:',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: defaultHeadlineTextStyle,
            ),

            const SizedBox(height: 25,),

            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              childAspectRatio: 1/1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children:
              List.generate(
                4,
                    (index)=> languageItemBuilder(
                    function: ()
                    {},
                    text: 'English',
                    cubit: cubit,
                    ),
              )
              ,
            ),
          ],
        ),
      ),
    );
  }

}

