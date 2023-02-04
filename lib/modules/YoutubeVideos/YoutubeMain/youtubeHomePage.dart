import 'dart:io';
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
import 'package:showcaseview/showcaseview.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeHomePage extends StatefulWidget {

  final String youtubeMainCache='myYoutubeMainCache';  //Page Cache name, in order to not show again after first app launch

  const YoutubeHomePage({Key? key}) : super(key: key);

  @override
  State<YoutubeHomePage> createState() => _YoutubeHomePageState();
}

class _YoutubeHomePageState extends State<YoutubeHomePage> {

  final GlobalKey searchGlobalKey = GlobalKey();

  @override
  void initState()
  {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp)
    {
      isFirstLaunch(widget.youtubeMainCache).then((value)
      {
        if(value)
        {
          print('SHOWING SHOWCASE IN YOUTUBE');
          ShowCaseWidget.of(context).startShowCase([searchGlobalKey]);
        }

        else
        {
            print('NO SHOWCASE IN YOUTUBE');
          }

      });
    });
  }

  @override
  void dispose()
  {
    super.dispose();
  }

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
                  ShowCaseView(
                    globalKey: searchGlobalKey,
                    title: 'Youtube Search',
                    description: 'Search for your favourite items here.\nRemember, only videos with english subtitles will be played',
                    child: IconButton(
                        onPressed: ()
                        {
                          navigateTo(context, const YoutubeSearchPage());
                        },
                        icon: const Icon(Icons.search_rounded)),
                  ),

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
                    builder: (context)=> videoListViewBuilder(context, model!,cubit, yt, captionScraper, state),
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

  Widget videoListViewBuilder(BuildContext context, PopularYoutubeVideos model, YoutubeCubit cubit, YoutubeExplode yt, YouTubeCaptionScraper captionScraper, YoutubeStates currentState)
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
            itemBuilder: (context,index)=>videoItemBuilder(context, model.items![index], yt ,captionScraper, cubit),
            itemCount: model.items!.length),

        Row(
          mainAxisSize: MainAxisSize.min,
          children:
          [
            //If Video is Being Loaded (Waiting for SRT file from main server) => then show Linear Progress Indicator
            Visibility(
              visible: currentState is YoutubeGetSrtLoadingState,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width /1.5,
                  child: const LinearProgressIndicator()
                ),
              ),
            ),

            //Show Next List if Available and not Waiting for SRT Files
            Visibility(
              visible: model.prevPageToken!=null && currentState is! YoutubeGetSrtLoadingState,
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


            //Put Spacer Between Previous and Next if one of the two lists is available at least AND not waiting for SRT Files
            Visibility(
              visible: (model.prevPageToken!=null || model.nextPageToken !=null) && currentState is! YoutubeGetSrtLoadingState,
              child: const Spacer(),
            ),

            //Show Previous List if Available and not Waiting for SRT Files.
            Visibility(
              visible: model.nextPageToken !=null && currentState is! YoutubeGetSrtLoadingState,
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

  Widget videoItemBuilder(BuildContext context, YoutubeVideoItem model, YoutubeExplode yt, YouTubeCaptionScraper captionScraper, YoutubeCubit cubit )
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

          ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
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

        // Object videoCaptions= await captionsGetter(model.id!, captionScraper); //Get Caption link

        captionsGetter(model.id!, captionScraper).then((videoCaptions)
        {
          if(videoCaptions is File) //if returned value is file, then subtitles are true
          {
            defaultToast(msg: 'Captions are Getting Exported');

            cubit.getSub(
                videoCaptions,
                context: context,
                videoDescription: model.snippet!.description!,
                videoLink: videoLink,
                videoTitle: model.snippet!.title!,
            ).catchError((error)
            {
              print('Couldn\'t Get Subtitles');
            });

          }

          if(videoCaptions is String) //If returned value is String, then error
          {
            print('videoCaptions is STRING, error happened when getting youtube captions');

            if(videoCaptions == 'noCaption')
            {
              defaultToast(msg: 'No Captions for This Video');
            }
          }

        });
      },
    );
  }
}
