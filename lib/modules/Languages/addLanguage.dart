import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import '../../models/MainModel/languages_model.dart';
import '../../shared/styles/styles.dart';

class AddLanguage extends StatelessWidget {
  const AddLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state)
      {
        if(state is AppPostUserLanguageLoadingState)
          {
            defaultToast(msg: 'Adding Language');
          }

        if(state is AppPostUserLanguageSuccessState)
          {
            defaultToast(msg: 'Added Successfully');
          }
      },
      builder: (context, state) {
        var cubit= AppCubit.get(context);
        LanguageModel? model= AppCubit.languagesModel;
        return Scaffold(
          appBar: AppBar(
            actions:
            [
              IconButton(onPressed: (){AppCubit.get(context).changeTheme();}, icon: const Icon(Icons.sunny)),
            ],
          ),
          body: ConditionalBuilder(
              condition: model !=null,
              builder: (context)=> itemBuilder(cubit,model!),
              fallback: (context) => const Center(child: CircularProgressIndicator(),),
          ),
        );
      },
    );
  }

  Widget itemBuilder(AppCubit cubit, LanguageModel model)
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

            const SizedBox(height: 50,),

            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              childAspectRatio: 1/1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children:
              List.generate(
                model.item.length,
                    (index)=> languageItemBuilder(
                    text: '${model.item[index].languageName}',
                    cubit: cubit,
                    function: ()
                    {
                      cubit.postLanguageUser(model.item[index].id!);
                    },
                    model: model.item[index],
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

//Default Builder for new Languages to add

Widget languageItemBuilder({
  Color background =  Colors.grey,
  bool isUpper = true,
  double radius = 10.0,  //was 10
  double width = 150.0,
  double height = 150.0, // was 40
  required void Function()? function,
  required String text,
  required AppCubit cubit,
  required Languages model,
}) => Container(
  clipBehavior: Clip.antiAliasWithSaveLayer,
  decoration: BoxDecoration(

    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: cubit.isDarkTheme ? Colors.white : Colors.black,
    ),
  ),
  width: width,
  height: height,
  child: MaterialButton(
    onPressed: function,
    child: Column(

      children:
      [
        Image(
          image: AssetImage('assets/images/${model.languagePhoto}'), //'assets/images/${model.languagePhoto}'

          errorBuilder: (context,error,stackTrace)
          {
            print('Couldn\'t get specified image, setting default image, ${error.toString()} ');
            return Image.asset('assets/images/defaultFlag.png', width: 100, height: 100,);
          },
          height: 100,
          width: 100,
        ),

        Text(
          isUpper ? text.toUpperCase() : text,
          style:TextStyle(
              color: pistachioColor,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    ),
  ),
);


