import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/models/MainModel/favourites_model.dart';
import 'package:juniorproj/modules/VideoPlayer/cubit/cubit.dart';
import 'package:juniorproj/modules/VideoPlayer/cubit/states.dart';
import 'package:juniorproj/modules/VideoPlayer/defShow.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/styles.dart';
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
                          'Favourite Words:',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: defaultHeadlineTextStyle,
                        ),
                      ),

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
        navigateTo(context, const DefinitionShow());
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
