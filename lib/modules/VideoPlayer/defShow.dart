import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/states.dart';
import 'package:juniorproj/models/MainModel/favourites_model.dart';
import 'package:juniorproj/models/MerriamWebster_model/merriam_model.dart';
import 'package:juniorproj/modules/VideoPlayer/cubit/cubit.dart';
import 'package:juniorproj/modules/VideoPlayer/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../layout/cubit/cubit.dart';

class DefinitionShow extends StatefulWidget {
  const DefinitionShow({Key? key}) : super(key: key);

  @override
  State<DefinitionShow> createState() => _DefinitionShowState();
}

class _DefinitionShowState extends State<DefinitionShow> {
  final AudioPlayer myAudioPlayer = AudioPlayer();
  late Source audioUrl;

  @override
  void dispose() {
    myAudioPlayer.dispose();
    WordCubit.model = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WordCubit, WordStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var appCubit = AppCubit.get(context);
        var favouritesModel = AppCubit.favouritesModel;

        var cubit = WordCubit.get(context);
        var model = WordCubit.model;

        appCubit.checkWordAtUser(favouritesModel, cubit.currentWord!);
        // WordCubit.model=null;
        return BlocConsumer<AppCubit, AppStates>(
          // I'VE NEVER CONSUMED 2 BLOCKS AT THE SAME TIME, KEEP EYE ON IT THOUGH NO ERRORS SHOW.
          listener: (context, state) {},
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      AppCubit.get(context).changeTheme();
                    },
                    icon: const Icon(Icons.sunny)),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: ConditionalBuilder(
                  condition: model != null,
                  fallback: (context) => const Center(
                    child: LinearProgressIndicator(),
                  ),
                  builder: (context) =>
                      itemBuilder(cubit, model!, favouritesModel, appCubit),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget itemBuilder(WordCubit cubit, MerriamModel model,
      FavouritesModel? favouritesModel, AppCubit appCubit) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${cubit.currentWord!.capitalize} :',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 35, fontWeight: FontWeight.w400),
              ),

              const Spacer(),

              //Show Favourite Icon if the word is favourite, else will show non filled favourite icon
              IconButton(
                icon: Icon(
                  appCubit.isWordFav
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  size: 30,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  if (appCubit.isWordFav == true) //Delete Word
                  {
                    // appCubit.changeFav(false);
                    appCubit.deleteFavourite(cubit.currentWord!);
                  } else if (appCubit.isWordFav == false) //Add Word
                  {
                    appCubit.addFavourites(cubit.currentWord!);
                    // appCubit.changeFav(true);
                  }
                },
              ),

              const SizedBox(
                width: 10,
              ),

              //Audio Button
              if (model.hwi!.prs!.isNotEmpty)
                if (model.hwi?.prs?[0]?.sound?.audio != null)
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      size: 30,
                    ),
                    onPressed: () async {
                      //Audio Link differs depending on the name of the word, all the cases are from Merriam Webster API documentation, refer to: https://dictionaryapi.com/products/json

                      late String audioLink;
                      var regularExpression =
                          RegExp("[^a-z]"); //Not Alphabetic  //^[^a-zA-Z]*

                      print(
                          'Audio name format is : ${model.hwi?.prs?[0]?.sound?.audio}');

                      if (model.hwi?.prs?[0]?.sound?.audio?.substring(0, 2) ==
                          'gg') //Starts with gg
                      {
                        print(
                            'Word Audio Link is gg : ${'https://media.merriam-webster.com/audio/prons/en/us/mp3/gg/${model.hwi?.prs?[0]?.sound?.audio}.mp3'}');

                        audioLink =
                            'https://media.merriam-webster.com/audio/prons/en/us/mp3/gg/${model.hwi?.prs?[0]?.sound?.audio}.mp3';
                      } else if (model.hwi?.prs?[0]?.sound?.audio
                              ?.substring(0, 3) ==
                          'bix') //Starts with bix
                      {
                        print(
                            'Word Audio Link is bix : ${'https://media.merriam-webster.com/audio/prons/en/us/mp3/bix/${model.hwi?.prs?[0]?.sound?.audio}.mp3'}');
                        audioLink =
                            'https://media.merriam-webster.com/audio/prons/en/us/mp3/bix/${model.hwi?.prs?[0]?.sound?.audio}.mp3';
                      } else if (regularExpression.firstMatch(model
                              .hwi!.prs![0]!.sound!.audio!
                              .substring(0, 1)
                              .toLowerCase()) !=
                          null) // Doesn't Start with Alphabetic
                      {
                        print(
                            'Word Audio Link is : ${'https://media.merriam-webster.com/audio/prons/en/us/mp3/number/${model.hwi?.prs?[0]?.sound?.audio}.mp3'}');
                        audioLink =
                            'https://media.merriam-webster.com/audio/prons/en/us/mp3/number/${model.hwi?.prs?[0]?.sound?.audio}.mp3';
                      } else //None of the above, then add first char of audio
                      {
                        String? directory =
                            model.hwi?.prs?[0]?.sound?.audio?.substring(0, 1);
                        print(
                            'Word Audio Link is : ${'https://media.merriam-webster.com/audio/prons/en/us/mp3/$directory/${model.hwi?.prs?[0]?.sound?.audio}.mp3'}');
                        audioLink =
                            'https://media.merriam-webster.com/audio/prons/en/us/mp3/$directory/${model.hwi?.prs?[0]?.sound?.audio}.mp3';
                      }
                      audioUrl = UrlSource(audioLink);
                      await myAudioPlayer.play(audioUrl);
                    },
                  ),
            ],
          ), //Word

          const SizedBox(
            height: 10,
          ),

          myDivider(c: goldenColor),

          const SizedBox(
            height: 15,
          ),

          Row(
            children: [
              Text(
                model.fl != null
                    ? '${model.fl.capitalize}'
                    : 'Couldn\'t get Type', //Word Type; Noun-verb
                style: TextStyle(
                  fontSize: 22,
                  color: defaultColor,
                ),
              ),
              //Type

              const Spacer(),

              //TextSpan in order to read the IPA (International Phonetic Alphabet)
              if (model.hwi!.prs!.isNotEmpty)
                RichText(
                  text: TextSpan(
                    text: model.hwi?.prs?[0]?.mw != null
                        ? '${model.hwi?.prs?[0]?.mw}'
                        : 'IPA',
                    style: TextStyle(
                      fontSize: 22,
                      color: defaultDarkColor,
                    ),
                  ),
                ),
              //Pronunciation
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          const Text(
            'Definitions:',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: model.shortdef?.length,
            itemBuilder: (context, index) => Text(
              model.shortdef != null
                  ? '${index + 1}. ${model.shortdef![index]}. \n'
                  : ' \' Couldn\'t Get Definition \' ',
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: myDivider(),
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(
            'Date of Use:',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
            ),
          ),

          Text(
            model.date != null ? '${model.date}' : 'Couldn\'t get Date ',
            style: TextStyle(
              fontSize: 22,
              color: defaultColor,
            ),
          ),

          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
