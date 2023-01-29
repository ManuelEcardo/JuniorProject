import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/models/MainModel/favourites_model.dart';
import 'package:juniorproj/modules/Videos/VideoPlayer/cubit/cubit.dart';
import 'package:juniorproj/modules/Videos/VideoPlayer/cubit/states.dart';
import 'package:juniorproj/modules/Translator/defShow.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/styles.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:string_extensions/string_extensions.dart';
import '../../layout/cubit/states.dart';
import '../../shared/styles/colors.dart';

class Favourites extends StatelessWidget {


  const Favourites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WordCubit,WordStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var appCubit= AppCubit.get(context);
          var cubit= WordCubit.get(context);
          FavouritesModel? favouritesModel= AppCubit.favouritesModel;
          return Scaffold(
            appBar: AppBar(
              actions:
              [
                IconButton(
                  icon:const Icon(Icons.question_mark_rounded),
                  onPressed: ()
                  async {
                    await showDialog(
                        context: context,
                        builder: (context)
                        {

                          return defaultAlertDialog(
                            context: context,
                            title: 'Favourite Words',
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children:
                                const[
                                  Text('Each time you translate a word, you can add it to your favourites list!',),

                                  Text('-By Clicking the Like Button you can add a new word or remove it',),
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  },
                ),


                IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
              ],
            ),

            body: BlocConsumer<AppCubit,AppStates>(
              listener: (context,state){},
              builder: (context,state)=>ConditionalBuilder(
                condition: AppCubit.favouritesModel !=null,
                fallback: (context)=> const Center(child: CircularProgressIndicator(),),
                builder: (context)=>  SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                    [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Favourite Words',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: defaultHeadlineTextStyle,
                        ),
                      ),

                      if(AppCubit.favouritesModel!.item.isEmpty)  //If list is empty then show a text
                        const Center(
                            child: Text(
                              'Wow,Such Empty!',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )),

                      if(AppCubit.favouritesModel!.item.isNotEmpty) //If there are items, then show them.
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,index)=> itemBuilder(cubit, appCubit, context, favouritesModel!.item[index], favouritesModel),
                        separatorBuilder: (context,index)=> Padding(padding: const EdgeInsets.symmetric(horizontal:  16.0), child: myDivider(),),
                        itemCount: favouritesModel!.item.length,
                      ),
                    ],
                  ),
                ),

              ),
            ),
          );
        },
    );
  }

  Widget itemBuilder(WordCubit cubit, AppCubit appCubit, BuildContext context, FavouritesItem model, FavouritesModel favouritesModel) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      highlightColor: AppCubit.get(context).isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
      onTap: ()
      {
        appCubit.checkWordAtUser(favouritesModel, model.vocabulary!);
        cubit.currentWord=model.vocabulary;
        cubit.search(model.vocabulary!);
        navigateTo(
            context,
            ShowCaseWidget(builder: Builder(builder: (context)=>const DefinitionShow())),
        );
      },

      child: Row(
        children:
        [
           Text(
            '${model.vocabulary}'.capitalize!,
            style:const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500
            ),
          ),

          const Spacer(),

          const Icon(Icons.arrow_forward_sharp,),
        ],
      ),
    ),
  );
}
