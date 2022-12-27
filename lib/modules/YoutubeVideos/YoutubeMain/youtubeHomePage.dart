import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorproj/layout/cubit/cubit.dart';
import 'package:juniorproj/models/YoutubeModel/PopularVideos/popularVideos.dart';
import 'package:juniorproj/modules/YoutubeVideos/YoutubeSearch/youtubeSearchPage.dart';
import 'package:juniorproj/modules/YoutubeVideos/cubit/cubit.dart';
import 'package:juniorproj/modules/YoutubeVideos/cubit/states.dart';
import 'package:juniorproj/shared/components/components.dart';
import 'package:juniorproj/shared/styles/colors.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../../models/MainModel/content_model.dart';
import '../../VideoPlayer/videoPlayer.dart';

class YoutubeHomePage extends StatelessWidget {
  const YoutubeHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<YoutubeCubit,YoutubeStates>(
        listener: (context,state)
        {},
        builder: (context,state)
        {
          var cubit=YoutubeCubit.get(context);
          var yt = YoutubeExplode();
          var captionScraper = YouTubeCaptionScraper(); //Get video captions
          PopularYoutubeVideos? model= YoutubeCubit.youtubeVideosModel;
          return WillPopScope(
            child: Scaffold(
              appBar: AppBar(
                actions:
                [
                  IconButton(
                      onPressed: ()
                      {
                        navigateTo(context, const YoutubeSearchPage());
                      },
                      icon: const Icon(Icons.search_rounded)),

                  IconButton(
                      onPressed: ()
                      {
                        AppCubit.get(context).changeTheme();
                      },
                      icon: const Icon(Icons.sunny)),
                ],
              ),

              body: Padding(
                padding: const EdgeInsetsDirectional.all(24.0),
                child: SingleChildScrollView(
                  child: ConditionalBuilder(
                    condition: model !=null,
                    fallback: (context)=>const Center(child: LinearProgressIndicator(),),
                    builder: (context)=> videoListViewBuilder(context, model!,cubit, yt, captionScraper),
                  ),
                ),
              ),
            ),

            onWillPop: () async
            {
              model=null;
              YoutubeCubit.youtubeVideosModel=null;
              return true;
            },
          );
        },
    );
  }

  Widget videoListViewBuilder(BuildContext context, PopularYoutubeVideos model, YoutubeCubit cubit, YoutubeExplode yt, YouTubeCaptionScraper captionScraper)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children:
      [
        Text(
          'Youtube Videos',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: pistachioColor,
          ),
        ),

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
                    cubit.youtubeGetVideos(pageToken: model.prevPageToken);
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
                    cubit.youtubeGetVideos(pageToken: model.nextPageToken);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget videoItemBuilder(BuildContext context, YoutubeVideoItem model, YoutubeExplode yt, YouTubeCaptionScraper captionScraper )
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
          //Old Image Style
          // Image(
          //     image: NetworkImage(model.snippet!.thumbnail!.high!.url!),
          //     width: 110,
          //     height: 110,
          //     fit: BoxFit.fitWidth,
          // ),

          ClipRRect(
            borderRadius: BorderRadius.circular(15), // Image border
            child: SizedBox.fromSize(
              size: const Size.fromRadius(50), // Image radius
              child: Image.network(
                  model.snippet!.thumbnail!.high!.url!,
                  fit: BoxFit.contain,
                  width: 110,
                  height: 110,
              ),
            ),
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
                    SizedBox(
                      width: 50,
                      child: Text(
                        model.contentDetails!.definition!.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent
                        ),
                      ),
                    ),

                    const SizedBox(width: 50,),

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

        defaultToast(msg: 'Loading');
        String videoLink= await videoStreamGetter(model.id!,yt);  //Get Video Stream link

        String videoCaptions= await captionsGetter(model.id!, captionScraper); //Get Caption link

        if(videoCaptions != 'noCaption')
          {
            Videos v1= Videos(
              videoDescription: model.snippet!.description!,
              videoLink: videoLink,
              videoTitle: model.snippet!.title!,
              videoSubtitle: videoCaptions,
            );

            navigateTo(context, VideoGetter(v1));
          }

        else
          {
            defaultToast(msg: 'No Captions for This Video');
          }
      },
    );
  }


}
