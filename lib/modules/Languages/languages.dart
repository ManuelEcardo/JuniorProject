import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/models/MainModel/languages_model.dart';
import 'package:juniorproj/modules/Units/units.dart';
import 'package:juniorproj/modules/YoutubeVideos/cubit/cubit.dart';
import 'package:juniorproj/modules/YoutubeVideos/YoutubeMain/youtubeHomePage.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/network/local/cache_helper.dart';

import '../../shared/styles/colors.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(

      listener: (context,state)
      {
      },

      builder: (context,state)
      {
        var cubit= AppCubit.get(context);
        var model= AppCubit.languagesModel;
        var userModel= AppCubit.userModel;

        return ConditionalBuilder(
            condition: model !=null && userModel !=null,
            fallback: (context)=>const Center(child: CircularProgressIndicator(),),
            builder: (context)=>SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [

                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics() ,
                    shrinkWrap: true,
                    itemBuilder: (context,index)=> languagesToBuild(cubit, context, userModel!.user!.userLanguages[index], model!.item),  //buildCatItem(cubit, model!.item[index], context), 1 should be user languages
                    separatorBuilder: (context,index)=> myDivider(),
                    itemCount: userModel!.user!.userLanguages.length,  //model!.item.length
                  ),

                  if(userModel.user!.userLanguages.isNotEmpty)
                  myDivider(),

                  youtubeLibraryItem(cubit,context),

                ],
              ),
            ),
        );
      },

    );
  }

Widget languagesToBuild(AppCubit cubit, BuildContext context,int userLanguageId, List<Languages> model) //Build the languages depending on what languages the user have.
{
  for (var element in model)
  {
    if(element.id == userLanguageId)  //userLanguageId is from userLanguages which is a list contains the ids of taken languages.
      {
        return buildCatItem(cubit, element, context);
      }
  }
  return const SizedBox();
}

Widget buildCatItem(AppCubit cubit, Languages? model, BuildContext context) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: InkWell(
    borderRadius: BorderRadius.circular(20),
    highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
    onTap: ()
    {
      List<String> list=[model!.id!.toString(), model.languageName!];
      cubit.getAllUnits(model.id!);
      CacheHelper.saveData(key: 'lastAccessedUnit', value: list).then((value) //Caching the last opened item so it can be accessed in the main page.
      {
          print('Last Accessed Unit ID is : ${model.id!}, Language Name is: ${model.languageName}, and it\'s Cached');
          navigateTo(context, Units(model.languageName!),);
      });

    },


    child: Row(
      children:
       [
        Image(
          image: AssetImage(model!.languagePhoto !=null ? 'assets/images/${model.languagePhoto!}' : 'assets/images/english.png'),
          width: 80.0,
          height: 80.0,
          fit: BoxFit.contain,
          errorBuilder: (context,error,stackTrace)
          {
            print('Couldn\'t get specified image, setting default image, ${error.toString()} ');
            return Image.asset(
              'assets/images/defaultFlag.png',
              width: 80.0,
              height: 80.0,
              fit: BoxFit.contain,
            );
          },
        ),

        const SizedBox(
          width: 20.0,
        ),

        Text(
          model.languageName!,
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


Widget youtubeLibraryItem(AppCubit cubit,BuildContext context) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
      onTap: ()
      {
        YoutubeCubit.get(context).youtubeGetVideos(); //Get Youtube Videos
        navigateTo(context, const YoutubeHomePage());
      },

      child: Row(
        children:const
        [
          Image(
            image: AssetImage('assets/images/Youtube.png'),
            width: 80.0,
            height: 80.0,
            fit: BoxFit.contain,
          ),

           SizedBox(
            width: 20.0,
          ),

          Text(
            'Youtube Library',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
            ),
          ),

           Spacer(),

           Icon(Icons.arrow_forward_sharp,),
        ],
      ),
    ),
  );

}
