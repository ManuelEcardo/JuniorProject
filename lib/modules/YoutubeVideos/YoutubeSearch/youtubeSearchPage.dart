import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/modules/YoutubeVideos/cubit/cubit.dart';
import 'package:juniorproj/modules/YoutubeVideos/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../../models/MainModel/content_model.dart';
import '../../../models/YoutubeModel/SearchVideos/YoutubeSearchModel.dart';
import '../../../shared/styles/colors.dart';
import '../../VideoPlayer/videoPlayer.dart';

class YoutubeSearchPage extends StatelessWidget {
  const YoutubeSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey= GlobalKey<FormState>();
    var searchController= TextEditingController();
    return BlocConsumer<YoutubeCubit,YoutubeStates>(
        listener: (context,state)
        {},
        builder: (context,state)
        {
          var cubit=YoutubeCubit.get(context);
          var yt = YoutubeExplode(); //Youtube Package Helper to get video's details
          var captionScraper = YouTubeCaptionScraper(); //Get video captions

          return Scaffold(
            appBar: AppBar(
              actions:
              [
                IconButton(
                    onPressed: ()
                    {
                      AppCubit.get(context).changeTheme();
                    },
                    icon: const Icon(Icons.sunny)),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children:
                    [
                      defaultFormField(
                          controller: searchController,
                          keyboard: TextInputType.text,
                          label: 'Search',
                          prefix: Icons.search,
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'Enter Data';
                            }
                            return null;
                          },
                          onSubmit: (String text)
                          {
                            if(formKey.currentState?.validate()==true)
                            {
                              YoutubeCubit.get(context).youtubeSearch(item: text);
                            }
                          }
                      ),

                      const SizedBox(height: 15,),

                      if(state is YoutubeSearchLoadingState)  //If video is Loading or Getting Captions then show Linear Progress Indicator
                        const LinearProgressIndicator(),

                      if(state is YoutubeSearchSuccessState)
                        ConditionalBuilder(
                            condition: YoutubeCubit.youtubeSearchModel !=null,
                            fallback: (context)=> const Center(child: LinearProgressIndicator(),),
                            builder: (context)=> videoListViewBuilder(YoutubeCubit.youtubeSearchModel!,cubit, yt, captionScraper, searchController.value.text),
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

  Widget videoListViewBuilder(YoutubeSearchModel model, YoutubeCubit cubit, YoutubeExplode yt, YouTubeCaptionScraper captionScraper, String query)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children:
      [
        const SizedBox(height: 30,),

        ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context,index)=>myDivider(),
            itemBuilder: (context,index)=>videoItemBuilder(context, model.items![index], yt ,captionScraper),
            itemCount: model.items!.length),

        Row(
          children:
          [
            Visibility(
              visible: model.prevPageToken!=null,
              child: Align(
                alignment: AlignmentDirectional.bottomStart,
                child: TextButton(
                  child:const Text(
                    'Previous',
                    style:TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  onPressed: ()
                  {
                    cubit.youtubeSearch(pageToken: model.prevPageToken, item: query);
                  },
                ),
              ),
            ),

            const Spacer(),

            Visibility(
              visible: model.nextPageToken !=null,
              child: Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: TextButton(
                  child:const Text(
                    'Next',
                    style:TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  onPressed: ()
                  {
                    cubit.youtubeSearch(pageToken: model.nextPageToken, item: query);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget videoItemBuilder(BuildContext context, YoutubeSearchVideoItem model, YoutubeExplode yt, YouTubeCaptionScraper captionScraper )
  {
    return InkWell(
      borderRadius: BorderRadius.circular(20),

      highlightColor:defaultColor.withOpacity(0.2),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children:
        [
          Image(
            image: NetworkImage(model.snippet!.thumbnail!.high!.url!),
            width: 110,
            height: 110,
          ),

          const SizedBox(width: 10,),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.snippet!.title!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Text(
                          model.snippet!.channelTitle!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: defaultColor,
                            fontStyle: FontStyle.italic,
                            fontSize: 15,

                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


        ],
      ),

      onTap: ()
      async {
        String videoLink= await videoStreamGetter(model.id!,yt);  //Get Video Stream link
        String videoCaptions= await captionsGetter(model.id!, captionScraper); //Get Caption link

        if(videoLink == 'no stream')
        {
          defaultToast(msg: 'Video Streams are not available because of some restrictions');
        }

        if(videoCaptions != 'noCaption' && videoLink != 'no stream')  //No Problem with either Video stream or captions, then show video.
            {
          Videos v1= Videos(
            videoDescription: model.snippet!.description!,
            videoLink: videoLink,
            videoTitle: model.snippet!.title!,
            videoSubtitle: videoCaptions,
          );

          navigateTo(context, VideoGetter(v1));
        }

        else if (videoCaptions == 'noCaption' && videoLink != 'no stream')
        {
          defaultToast(msg: 'No Captions for This Video');

          Videos v1= Videos(
            videoDescription: model.snippet!.description!,
            videoLink: videoLink,
            videoTitle: model.snippet!.title!,
            videoSubtitle: videoCaptions,
          );

          navigateTo(context, VideoGetter(v1));
        }
      },
    );
  }
}
